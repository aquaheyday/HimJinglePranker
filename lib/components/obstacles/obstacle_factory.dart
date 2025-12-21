import 'dart:math';

import 'obstacle.dart';
import 'ground_obstacle.dart';
import 'ceiling_obstacle.dart';

class ObstacleFactory {
  final Random _random = Random();

  /// ⭐ 파이프 6 : 절벽 4
  Obstacle createRandom() {
    final int roll = _random.nextInt(10); // 0 ~ 9

    if (roll < 6) {
      // 60% → 파이프
      return GroundObstacle(
        height: 50 + _random.nextDouble() * 40,
        isScoreTrigger: true,
      );
    } else {
      // 40% → 절벽
      return CeilingObstacle(
        height: 100 + _random.nextDouble() * 120,
      );
    }
  }
}