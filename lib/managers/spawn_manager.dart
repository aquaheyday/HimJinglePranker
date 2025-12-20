import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:him_jingle_pranker/components/obstacles/roofEdge.dart';
import '../components/obstacles/chimney.dart';
import '../game/my_game.dart';
import '../components/obstacles/obstacle.dart';
import '../config/game_config.dart';

class SpawnManager {
  final MyGame game;
  double spawnTimer = 0;
  final double spawnInterval;
  final Random _random = Random();

  SpawnManager(
    this.game, {
    this.spawnInterval = GameConfig.spawnInterval,
  });

  void update(double dt) {
    spawnTimer += dt;

    if (spawnTimer >= spawnInterval) {
      spawnTimer = 0;
      spawnObstacles();

      // 점수 증가
      game.increaseScore();
    }
  }

  /// 기존 로직 그대로 유지
  void spawnObstacles() {
    final height = game.size.y;
    final gap = 150.0;
    final pipeWidth = 60.0;
    final minPipeHeight = 20.0;

    final randomY = minPipeHeight + _random.nextDouble() * (height - gap - minPipeHeight * 2);

    final chimneyHeight = 50.0;
    final topPipeHeight = randomY;
    final chimney = 'pipe.png';
    final roofEdge = 'pipe2.png';

    // 굴뚝
    game.add(
      Chimney(
        position: Vector2(game.size.x, game.size.y - 100),
        size: Vector2(pipeWidth, chimneyHeight),
        // img: chimney,
        // obstacleSpawnProbability: 4,
        // // rect: Rect.fromLTWH(0, 0, 0, 0),
        // // 0, height - GameConfig.santaGravity, width, height
        // rectLeft: 0,
        // rectTop: GameConfig.santaGravity,
        // rectWidth: null,
        // rectHeight: null,
      )..priority = 300,
    );

    // 지붕 낭떠러지
    game.add(
      RoofEdge(
        position: Vector2(game.size.x, game.size.y - 150),
        size: Vector2(pipeWidth, topPipeHeight),
        img: roofEdge,
        obstacleSpawnProbability: 6,
        rectLeft: 0,
        rectTop: GameConfig.santaGravity,
        rectWidth: null,
        rectHeight: null,
        // rect: Rect.fromLTWH(0, 0, 0, 0),
      )..priority = 300,
    );
  }

  void reset() {
    spawnTimer = 0;
  }
}
