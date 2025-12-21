import 'package:flame/components.dart';
import '../../config/assets_path.dart';
import '../../config/game_config.dart';
import 'obstacle.dart';

class CeilingObstacle extends Obstacle {
  final double height;

  CeilingObstacle({
    required this.height,
  }) : super(
    position: Vector2.zero(),
    size: Vector2(
      GameConfig.obstacleWidth,
      height,
    ),
    img: AssetsPath.roofEdge,
    isScoreTrigger: false,
  );

  @override
  void onPositionReady() {
    position.y = gameRef.size.y
        - GameConfig.groundHeight
        - height;
  }
}
