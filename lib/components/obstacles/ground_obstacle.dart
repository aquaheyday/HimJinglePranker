import 'package:flame/components.dart';
import '../../config/assets_path.dart';
import '../../config/game_config.dart';
import 'obstacle.dart';

class GroundObstacle extends Obstacle {
  final double height;

  GroundObstacle({
    required this.height,
    bool isScoreTrigger = true,
  }) : super(
    position: Vector2.zero(), // ⭐ x, y 임시값
    size: Vector2(
      GameConfig.obstacleWidth,
      height,
    ),
    img: AssetsPath.chimney,
    isScoreTrigger: isScoreTrigger,
  );

  @override
  void onPositionReady() {
    // ⭐ 핵심: 바닥 기준으로 위치 계산
    position.y = gameRef.size.y
        - GameConfig.groundHeight
        - height;
  }
}
