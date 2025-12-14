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

    final groundY = gameRef.size.y - MyGame.groundHeight;
    position = Vector2(
      gameRef.size.x / 5,
      groundY - height,
    );

    // 확인
    print("Bird 중심 Y: ${position.y}");
    print("Bird 아래쪽 Y: ${position.y + height / 2}");
    print("바닥 Y: $groundY");
    print("차이: ${groundY - (position.y + height / 2)}");

    isOnGround = true;
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    speedY += gravity * dt;
    position.y += speedY * dt;

    final groundY = gameRef.size.y - MyGame.groundHeight;

    // ✅ 바닥 충돌
    if (position.y + height >= groundY) {
      position.y = groundY - height;
      speedY = 0;
      isOnGround = true;

      if (gameRef.isHolding) {
        jump();
      }
    } else {
      isOnGround = false;
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
