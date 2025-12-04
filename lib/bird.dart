import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:him_jingle_pranker/my_game.dart';

class Bird extends SpriteComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  double speedY = 0;
  final double gravity = 600;
  final double jumpForce = -300;

  Bird() : super(size: Vector2(50, 50));

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('bird.png');
    position = gameRef.size / 2;
    add(CircleHitbox()); // 충돌 범위
  }

  @override
  void update(double dt) {
    super.update(dt);

    speedY += gravity * dt;
    position.y += speedY * dt;

    if (position.y > gameRef.size.y - height) {
      position.y = gameRef.size.y - height;
      speedY = 0;
      gameRef.over();
    }
  }

  void jump() {
    speedY = jumpForce;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints,
      PositionComponent other,
      ) {
    super.onCollisionStart(intersectionPoints, other);
    gameRef.over(); // 장애물에 닿으면 GameOver
  }
}
