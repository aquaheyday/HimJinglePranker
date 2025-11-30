import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

void main() {
  runApp(
    GameWidget(
      game: MyGame(),
    ),
  );
}

class MyGame extends FlameGame with HasTappables, TapDetector {
  late Ball ball;

  @override
  Future<void> onLoad() async {
    ball = Ball()
      ..position = Vector2(100, 200)
      ..radius = 20;

    add(ball);
  }

  @override
  void onTapDown(TapDownInfo info) {
    final pos = info.eventPosition.game;
    ball.position = pos.clone();
  }
}
