import 'package:flame/components.dart';

import '../../core/assets.dart';
import '../../core/game_config.dart';
import 'base_obstacle.dart';

/// 천장에서 내려오는 장애물 (지붕 끝)
class CeilingObstacle extends BaseObstacle {
  CeilingObstacle({
    required double height,
    required double speed,
    bool isScoreTrigger = true,
  }) : super(
    position: Vector2.zero(), // onPositionReady에서 설정
    size: Vector2(GameConfig.obstacleWidth, height),
    imagePath: Assets.roofEdge,
    speed: speed,
    isScoreTrigger: isScoreTrigger,
  );

  @override
  void onPositionReady() {
    // 천장에서 시작 (y = 0)
    position.y = 0;
  }
}
