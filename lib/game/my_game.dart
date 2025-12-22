import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../components/environment/game_background.dart';
import '../components/environment/scrolling_ground.dart';
import '../components/obstacles/base_obstacle.dart';
import '../components/obstacles/obstacle_spawner.dart';
import '../components/player/santa.dart';
import '../components/ui/game_hud.dart';
import '../components/ui/game_over_overlay.dart';
import '../components/ui/start_overlay.dart';
import '../services/audio_service.dart';
import '../services/difficulty_service.dart';
import '../services/score_service.dart';
import 'game_state.dart';

/// 메인 게임 클래스
///
/// FlameGame을 상속받아 게임의 핵심 로직을 관리
/// 각 기능은 서비스와 컴포넌트로 분리되어 있음
class MyGame extends FlameGame
    with TapCallbacks, KeyboardEvents, HasCollisionDetection {

  // ============================================
  // 서비스
  // ============================================
  late final AudioService audioService;
  late final ScoreService scoreService;
  late final DifficultyService difficultyService;

  // ============================================
  // 컴포넌트
  // ============================================
  late final GameBackground background;
  late final ScrollingGround ground;
  late final Santa santa;
  late final ObstacleSpawner obstacleSpawner;
  late final GameHud hud;
  late final StartOverlay startOverlay;
  late final GameOverOverlay gameOverOverlay;

  // ============================================
  // 상태
  // ============================================
  GameState _gameState = GameState.ready;
  bool _isHolding = false;

  GameState get gameState => _gameState;
  bool get isHolding => _isHolding;

  // ============================================
  // 라이프사이클
  // ============================================

  @override
  Future<void> onLoad() async {
    // 서비스 초기화
    await _initializeServices();

    // 컴포넌트 로드
    await _loadComponents();
  }

  Future<void> _initializeServices() async {
    audioService = AudioService();
    await audioService.initialize();

    scoreService = ScoreService();
    await scoreService.initialize();

    difficultyService = DifficultyService();
  }

  Future<void> _loadComponents() async {
    // 배경 (가장 먼저 - 가장 뒤에 렌더링)
    background = GameBackground();
    await add(background);

    // 바닥
    ground = ScrollingGround();
    await add(ground);

    // 플레이어
    santa = Santa();
    await add(santa);

    // 장애물 스포너
    obstacleSpawner = ObstacleSpawner();
    await add(obstacleSpawner);

    // UI
    hud = GameHud();
    await add(hud);

    startOverlay = StartOverlay();
    await add(startOverlay);

    gameOverOverlay = GameOverOverlay();
    await add(gameOverOverlay);
  }

  // ============================================
  // 게임 상태 관리
  // ============================================

  /// 게임 시작
  void startGame() {
    if (_gameState != GameState.ready) return;

    _gameState = GameState.playing;

    // 스크롤 시작
    background.startScrolling();
    ground.startScrolling();

    // 오디오 시작
    audioService.playBackgroundMusic();

    // 시작 오버레이 숨기기
    startOverlay.hide();
  }

  /// 게임 일시정지
  void pauseGame() {
    if (!_gameState.canPause) return;

    _gameState = GameState.paused;
    pauseEngine();
    audioService.pauseBackgroundMusic();
  }

  /// 게임 재개
  void resumeGame() {
    if (_gameState != GameState.paused) return;

    _gameState = GameState.playing;
    resumeEngine();
    audioService.resumeBackgroundMusic();
  }

  /// 일시정지 토글
  void togglePause() {
    if (_gameState == GameState.playing) {
      pauseGame();
    } else if (_gameState == GameState.paused) {
      resumeGame();
    }
  }

  /// 게임오버
  void gameOver() {
    if (_gameState == GameState.gameOver) return;

    _gameState = GameState.gameOver;

    // 스크롤 정지
    background.stopScrolling();
    ground.stopScrolling();

    // 오디오
    audioService.pauseBackgroundMusic();
    audioService.playGameOver();

    // 게임오버 오버레이 표시
    gameOverOverlay.show(
      score: scoreService.score,
      highScore: scoreService.highScore,
      isNewHighScore: scoreService.isNewHighScore,
    );

    // 엔진 일시정지
    pauseEngine();
  }

  /// 게임 재시작
  void restartGame() {
    if (!_gameState.canRestart) return;

    _gameState = GameState.playing;

    // 서비스 리셋
    scoreService.reset();
    difficultyService.reset();

    // 컴포넌트 리셋
    _resetComponents();

    // 장애물 제거
    _removeAllObstacles();

    // 스크롤 시작
    background.startScrolling();
    ground.startScrolling();

    // 오디오 시작
    audioService.playBackgroundMusic();

    // UI 업데이트
    hud.refresh();
    gameOverOverlay.hide();

    // 엔진 재개
    resumeEngine();
  }

  void _resetComponents() {
    santa.reset();
    ground.reset();
    ground.startScrolling();
    background.reset();
    background.startScrolling();
    obstacleSpawner.reset();
  }

  void _removeAllObstacles() {
    children.whereType<BaseObstacle>().toList().forEach((obstacle) {
      obstacle.removeFromParent();
    });
  }

  // ============================================
  // 게임 이벤트 콜백
  // ============================================

  /// 장애물 통과 시 호출
  void onObstaclePassed() {
    scoreService.increment();
    hud.updateScore(scoreService.score);

    // 난이도 업데이트
    difficultyService.updateForScore(scoreService.score);
    _applyDifficulty();

    // 점수 사운드 (선택적)
    // audioService.playScore();
  }

  /// 플레이어 피격 시 호출
  void onPlayerHit() {
    gameOver();
  }

  void _applyDifficulty() {
    obstacleSpawner.updateSpawnInterval(difficultyService.spawnInterval);
    obstacleSpawner.updateSpeed(difficultyService.obstacleSpeed);
    ground.updateSpeed(difficultyService.groundSpeed);
    background.updateSpeed(difficultyService.backgroundSpeed);
  }

  // ============================================
  // 게임 루프
  // ============================================

  @override
  void update(double dt) {
    super.update(dt);

    // 홀딩 중이고 바닥에 있으면 자동 점프
    if (_gameState.isActive && _isHolding && santa.isOnGround) {
      santa.jump();
    }
  }

  // ============================================
  // 입력 처리
  // ============================================

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event,
      Set<LogicalKeyboardKey> keysPressed,
      ) {
    if (event.logicalKey == LogicalKeyboardKey.space) {
      if (event is KeyDownEvent) {
        _isHolding = true;
        _handleInput();
      } else if (event is KeyUpEvent) {
        _isHolding = false;
      }
      return KeyEventResult.handled;
    }

    // ESC로 일시정지
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      togglePause();
      return KeyEventResult.handled;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onTapDown(TapDownEvent event) {
    _isHolding = true;
    _handleInput();
  }

  @override
  void onTapUp(TapUpEvent event) {
    _isHolding = false;
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    _isHolding = false;
  }

  void _handleInput() {
    switch (_gameState) {
      case GameState.ready:
        startGame();
        break;
      case GameState.playing:
        santa.jump();
        break;
      case GameState.gameOver:
        restartGame();
        break;
      case GameState.paused:
        resumeGame();
        break;
    }
  }
}
