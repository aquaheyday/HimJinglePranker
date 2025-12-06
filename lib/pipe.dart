import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'dart:ui';

class Pipe extends SpriteComponent with CollisionCallbacks, HasGameRef {
  Pipe({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load('pipe3.png');
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    if (sprite == null) return;

    final img = sprite!.image;
    final imgW = img.width.toDouble();
    final imgH = img.height.toDouble();

    double filled = 0; // 현재 채운 높이

    while (filled < size.y) {
      double drawH = imgH;
      if (filled + drawH > size.y) {
        drawH = size.y - filled; // 마지막 자투리만 자르기
      }

      canvas.drawImageRect(
        img,
        Rect.fromLTWH(0, 0, imgW, drawH), // 원본에서 drawH 만큼만 잘라서
        Rect.fromLTWH(0, filled, size.x, drawH), // y 위치에 계속 붙이기
        Paint(),
      );

      filled += drawH;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= 200 * dt;
    if (position.x + width < 0) removeFromParent();
  }
}
