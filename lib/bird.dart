import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:him_jingle_pranker/my_game.dart';

class Bird extends SpriteComponent with HasGameRef<MyGame>, CollisionCallbacks {
  double speedY = 0;
  final double gravity = 600; //중력
  final double jumpForce = -300; // 점프 높이
  bool isOnGround = true;

  Bird() : super(size: Vector2(50, 50));

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('santa.png');
    // 처음

    position = Vector2(size.x / size.x + 30, size.y / 2); // x: 30, y: 가운데
    add(CircleHitbox()); // 충돌 범위
  }

  @override
  void update(double dt) {
    super.update(dt);
    speedY += gravity * dt; // 이동 속도
    position.y += speedY * dt; // 점프

    if (position.y >= (gameRef.size.y - 75) / 2) {
      // 바닥 높이
      position.y = (gameRef.size.y - 75) / 2;
      isOnGround = true;
    } else {
      isOnGround = false;
    }

    if (position.y > gameRef.size.y - height) {
      position.y = gameRef.size.y - height;
      speedY = 0;
      gameRef.over();
    }
  }

  void jump() {
    if (isOnGround) speedY = jumpForce;
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
