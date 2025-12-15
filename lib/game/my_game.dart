import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flame/parallax.dart';

import '../components/player/santa.dart';
import '../components/environment/ground.dart';
import '../components/obstacles/obstacle.dart';
import '../config/game_config.dart';
import '../managers/spawn_manager.dart';
import '../managers/score_manager.dart';
import 'game_state.dart';

class MyGame extends FlameGame
    with HasGameRef<MyGame>, TapCallbacks, KeyboardEvents, HasCollisionDetection {

  // Components
  late Santa santa;
  late ScrollingGround ground;
  late TextComponent scoreText;
  late TextComponent gameOverText;

  // Managers
  late SpawnManager spawnManager;
  late ScoreManager scoreManager;

  // State
  GameState gameState = GameState.playing;
  bool isHolding = false;

  // Getters for external access
  static double get groundHeight => GameConfig.groundHeight;
  int get score => scoreManager.score;

  @override
  Future<void> onLoad() async {
    // Managers 초기화
    scoreManager = ScoreManager();
    spawnManager = SpawnManager(this);

    // 배경
    await _loadBackground();

    // 바닥
    _loadGround();

    // 플레이어
    _loadSanta();

    // UI
    _loadUI();
  }

  Future<void> _loadBackground() async {
    final parallax = await loadParallaxComponent(
      [ParallaxImageData(Assets.background)],
      baseVelocity: Vector2(GameConfig.backgroundScrollSpeed, 0),
      repeat: ImageRepeat.repeat,
    );
    add(parallax);
  }

  void _loadGround() {
    ground = ScrollingGround(
      scrollSpeed: GameConfig.groundScrollSpeed,
    );
    add(ground);
  }

  void _loadSanta() {
    santa = Santa();
    add(santa);
  }

  void _loadUI() {
    // 점수 텍스트
    scoreText = TextComponent(
      text: '0',
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, 20),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: GameConfig.scoreFontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    )..priority = 200;
    add(scoreText);

    // 게임오버 텍스트
    gameOverText = TextComponent(
      text: 'GAME OVER\nTap to Restart',
      anchor: Anchor.center,
      position: size / 2,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: GameConfig.gameOverFontSize,
          color: Colors.transparent,
        ),
      ),
    )..priority = 100;
    add(gameOverText);
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event,
      Set<LogicalKeyboardKey> keysPressed,
      ) {
    if (event.logicalKey == LogicalKeyboardKey.space) {
      if (event is KeyDownEvent) {
        isHolding = true;
        _handleJumpOrRestart();
      } else if (event is KeyUpEvent) {
        isHolding = false;
      }
      return KeyEventResult.handled;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onTapDown(TapDownEvent event) {
    isHolding = true;
    _handleJumpOrRestart();
  }

  @override
  void onTapUp(TapUpEvent event) {
    isHolding = false;
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    isHolding = false;
  }

  void _handleJumpOrRestart() {
    if (gameState == GameState.gameOver) {
      restart();
    } else {
      santa.jump();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameState == GameState.gameOver) return;

    // 스페이스바 홀딩 시 자동 점프
    if (isHolding && santa.isOnGround) {
      santa.jump();
    }

    // 장애물 생성
    spawnManager.update(dt);
  }

  /// 점수 증가
  void increaseScore() {
    scoreManager.increase();
    scoreText.text = scoreManager.score.toString();
  }

  /// 게임오버
  void over() {
    if (gameState == GameState.gameOver) return;

    gameState = GameState.gameOver;

    gameOverText.textRenderer = TextPaint(
      style: const TextStyle(
        fontSize: GameConfig.gameOverFontSize,
        color: Colors.white,
      ),
    );

    pauseEngine();
    print('GAME OVER - Score: ${scoreManager.score}');
  }

  /// 재시작
  void restart() {
    gameState = GameState.playing;

    // 매니저 초기화
    scoreManager.reset();
    spawnManager.reset();

    // UI 업데이트
    scoreText.text = '0';
    gameOverText.textRenderer = TextPaint(
      style: const TextStyle(
        fontSize: GameConfig.gameOverFontSize,
        color: Colors.transparent,
      ),
    );

    // 장애물 제거
    _removeAllObstacles();

    // Santa 위치 초기화
    _resetSanta();

    // Ground 위치 초기화
    ground.position.x = 0;

    resumeEngine();
    print('Game Restarted');
  }

  void _removeAllObstacles() {
    children.whereType<Obstacle>().toList().forEach((obstacle) {
      obstacle.removeFromParent();
    });
  }

  void _resetSanta() {
    final groundY = size.y - GameConfig.groundHeight;
    santa.position = Vector2(
      size.x / 5,
      groundY - santa.height / 2,
    );
    santa.speedY = 0;
    santa.isOnGround = true;
  }
}