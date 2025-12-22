import 'package:flame/components.dart';

import '../../core/assets.dart';
import '../../core/game_config.dart';
import 'base_obstacle.dart';

/// 바닥에서 올라오는 장애물 (굴뚝)
class GroundObstacle extends BaseObstacle {
  GroundObstacle({
    required double height,
    required double speed,
    bool isScoreTrigger = true,
  }) : super(
    position: Vector2.zero(), // onPositionReady에서 설정
    size: Vector2(GameConfig.obstacleWidth, height),
    imagePath: Assets.chimney,
    speed: speed,
    isScoreTrigger: isScoreTrigger,
  );

  @override
  void onPositionReady() {
    // 바닥 위에 위치
    position.y = gameRef.size.y - GameConfig.groundHeight - height;
  }
}
