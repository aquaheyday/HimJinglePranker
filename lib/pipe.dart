import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

class Pipe extends SpriteComponent with CollisionCallbacks, HasGameRef {
  Pipe({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('pipe.png');
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= 200 * dt; // 좌측으로 이동

    if (position.x + width < 0) {
      removeFromParent();
    }
  }
}
