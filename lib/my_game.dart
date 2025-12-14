import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:him_jingle_pranker/bird.dart';
import 'package:him_jingle_pranker/pipe.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/parallax.dart';
import 'package:him_jingle_pranker/ground.dart';

enum GameState { playing, gameOver }

class MyGame extends FlameGame with TapCallbacks, KeyboardEvents, HasCollisionDetection {
  static const double groundHeight = 100.0;
  late Bird bird;
  int score = 0;
  double pipeSpawnTimer = 0;
  GameState gameState = GameState.playing;
  late TextComponent gameOverText;
  late TextComponent scoreText;
  late ScrollingGround ground;
  bool isHolding = false;

  @override
  Future<void> onLoad() async {
    // 1. 배경을 가장 먼저 로드 (가장 아래 레이어)
    final parallax = await loadParallaxComponent(
      [
        ParallaxImageData('nightbackground2.png'), // 생성한 이끼 벽돌 이미지 파일명
      ],
      baseVelocity: Vector2(20, 0), // 옆으로 흐르는 속도 (원하는 방향에 따라 X, Y 조절)
      repeat: ImageRepeat.repeat, // 화면을 꽉 채우며 무한 반복
    );
    add(parallax);

    // 2. 스크롤 바닥 추가
    ground = ScrollingGround(scrollSpeed: 200); // 파이프와 같은 속도
    add(ground);

    bird = Bird();
    add(bird);

    // Score UI
    scoreText = TextComponent(
      text: '0',
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, 20), // 화면 중앙 상단
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        ),
      ),
    )..priority = 200; // 가장 위로

    add(scoreText);

    gameOverText =
        TextComponent(
            text: 'GAME OVER\nTap to Restart',
            anchor: Anchor.center,
            textRenderer: TextPaint(
              style: const TextStyle(
                fontSize: 40,
                color: Color(0x00FFFFFF),
              ),
            ),
          )
          ..position = size / 2
          ..priority = 100;

    add(gameOverText);
  }

  /// Key Event
  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {

    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.space) {
        isHolding = true;
        if (gameState == GameState.gameOver) {
          restart();
        } else {
          bird.jump();
        }
      }
      return KeyEventResult.handled;
    }

    if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.space) {
        isHolding = false;
      }
      return KeyEventResult.handled;
    }


    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameState == GameState.gameOver) return;

    pipeSpawnTimer += dt;
    if (pipeSpawnTimer > 2) {
      pipeSpawnTimer = 0;
      spawnPipe();
      score++;
      scoreText.text = score.toString();
      print("Score: $score");
    }
  }

  /// 장애물  크기
  void spawnPipe() {
    final height = size.y;
    final gap = 150.0;
    final pipeWidth = 60.0;
    // final minPipeHeight = 50.0;
    final minPipeHeight = 20.0;
    final maxPipeHeight = 50;
    final rand = Random(); // ← random 생성

    // if(rand.nextDouble())
    final randomY = minPipeHeight + rand.nextDouble() * (height - gap - minPipeHeight * 2);
    print(rand.nextDouble());
    print(randomY);

    final bottomPipeHeight = height - randomY - gap;
    final topPipeHeight = randomY;

    // 아래 파이프
    add(
      Pipe(
        position: Vector2(size.x, randomY + gap),
        size: Vector2(pipeWidth, bottomPipeHeight),
        isTop: false,
      ),
    );

    // 위 파이프
    add(
      Pipe(
        position: Vector2(size.x, 0),
        size: Vector2(pipeWidth, topPipeHeight),
        isTop: true,
      ),
    );
  }

  /// ReStart
  @override
  void onTapDown(TapDownEvent event) {
    isHolding = true;

    if (gameState == GameState.gameOver) {
      restart();
    } else {
      bird.jump();
    }
    print("TAP EVENT"); // 디버그 출력!
  }

  @override
  void onTapUp(TapUpEvent event) {
    isHolding = false;
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    isHolding = false;
  }

  void over() {
    if (gameState == GameState.gameOver) return;

    gameState = GameState.gameOver;
    gameOverText.textRenderer = TextPaint(
      style: const TextStyle(
        fontSize: 40,
        color: Color(0xFFFFFFFF), // 불투명하게!
      ),
    );
    pauseEngine();
    print("GAME OVER Score: $score");
  }

  void restart() {
    gameState = GameState.playing;
    score = 0;
    scoreText.text = '0';
    pipeSpawnTimer = 0;

    gameOverText.textRenderer = TextPaint(
      style: const TextStyle(
        fontSize: 40,
        color: Color(0x00FFFFFF), // 다시 투명
      ),
    );

    // 기존 장애물 모두 제거
    children.whereType<Pipe>().forEach((pipe) => pipe.removeFromParent());

    // Bird 위치 초기화

    final groundY = size.y - MyGame.groundHeight;
    bird.position = Vector2(size.x / 5, groundY - bird.height);
    bird.speedY = 0;
    bird.isOnGround = true;

    resumeEngine();
  }
}
