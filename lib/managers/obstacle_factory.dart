import 'dart:math';
import 'package:flame/components.dart';
import '../components/obstacles/obstacle.dart';
import '../config/assets.dart';
import '../config/game_config.dart';

enum ObstacleType { chimney, roofEdge }

class ObstacleFactory {
  final Vector2 screenSize;
  final Random _random = Random();

  ObstacleFactory(this.screenSize);

  /// 굴뚝 생성
  Obstacle createChimney() {
    return Obstacle(
      position: Vector2(
        screenSize.x,
        screenSize.y - GameConfig.groundHeight - GameConfig.chimneyHeight,
      ),
      size: Vector2(
        GameConfig.obstacleWidth,
        GameConfig.chimneyHeight,
      ),
      img: Assets.chimney,
      obstacleSpawnProbability: 4,
    )..priority = 300;
  }

  /// 지붕 끝 생성
  Obstacle createRoofEdge() {
    final randomHeight = GameConfig.minObstacleHeight +
        _random.nextDouble() *
            (screenSize.y - GameConfig.gapSize - GameConfig.minObstacleHeight * 2);

    return Obstacle(
      position: Vector2(
        screenSize.x,
        screenSize.y - GameConfig.groundHeight - 50 - randomHeight,
      ),
      size: Vector2(
        GameConfig.obstacleWidth,
        randomHeight,
      ),
      img: Assets.roofEdge,
      obstacleSpawnProbability: 6,
    )..priority = 300;
  }

  /// 랜덤 장애물 생성
  Obstacle createRandom() {
    final types = [ObstacleType.chimney, ObstacleType.roofEdge];
    final randomType = types[_random.nextInt(types.length)];

    return create(randomType);
  }

  /// 타입별 장애물 생성
  Obstacle create(ObstacleType type) {
    switch (type) {
      case ObstacleType.chimney:
        return createChimney();
      case ObstacleType.roofEdge:
        return createRoofEdge();
    }
  }

  /// 장애물 세트 생성 (굴뚝 + 지붕)
  List<Obstacle> createPair() {
    return [
      createChimney(),
      createRoofEdge(),
    ];
  }
}