import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:him_jingle_pranker/game/my_game.dart';

import '../../managers/audio_manager.dart';
import '../../config/assets_path.dart';

class Santa extends SpriteComponent with HasGameRef<MyGame>, CollisionCallbacks {
  static final Vector2 birdSize = Vector2(100.0, 100.0); // 산타 캐릭터 사이즈
  final double gravity = 600; // 중력
  final double jumpForce = -600; // 점프 높이
  double speedY = 0;
  bool isOnGround = true;

  Santa() : super(size: birdSize);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(AssetsPath.santa);

    final groundY = gameRef.size.y - MyGame.groundHeight;
    position = Vector2(
      gameRef.size.x / 5,
      groundY - height,
    );

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
    if (!isOnGround) return;

    speedY = jumpForce;
    isOnGround = false;

    AudioManager().playJump();
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
