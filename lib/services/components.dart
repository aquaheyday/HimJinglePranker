import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class Ball extends PositionComponent {
  double radius = 20;
  Vector2 velocity = Vector2(150, 0); // 초당 150px 오른쪽으로 이동

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.red;
    canvas.drawCircle(Offset.zero, radius, paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    // 화면 밖으로 나가면 x축 방향 반전
    if (position.x + radius > gameRef.size.x || position.x - radius < 0) {
      velocity.x *= -1;
    }
  }

  @override
  Vector2 get size => Vector2.all(radius * 2);
}
