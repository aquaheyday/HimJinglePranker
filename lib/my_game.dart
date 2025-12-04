import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:him_jingle_pranker/bird.dart';
import 'package:him_jingle_pranker/pipe.dart';
import 'dart:math';

class MyGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  late Bird bird;
  int score = 0;
  double pipeSpawnTimer = 0;

  @override
  Future<void> onLoad() async {
    bird = Bird();
    add(bird);
  }

  @override
  void update(double dt) {
    super.update(dt);

    pipeSpawnTimer += dt;
    if (pipeSpawnTimer > 2) {
      pipeSpawnTimer = 0;
      spawnPipe();
      score++;
      print("Score: $score");
    }
  }

  void spawnPipe() {
    final height = size.y;
    final gap = 150.0;
    final pipeWidth = 60.0;
    final minPipeHeight = 50.0;
    final rand = Random(); // ← random 생성

    final randomY =
        minPipeHeight + rand.nextDouble() * (height - gap - minPipeHeight * 2);

    final bottomPipeHeight = height - randomY - gap;
    final topPipeHeight = randomY;

    // 아래 파이프
    add(Pipe(
      position: Vector2(size.x, randomY + gap),
      size: Vector2(pipeWidth, bottomPipeHeight),
    ));

    // 위 파이프
    add(Pipe(
      position: Vector2(size.x, 0),
      size: Vector2(pipeWidth, topPipeHeight),
    ));
  }

  @override
  void onTapDown(TapDownEvent event) {
    bird.jump();
    print("TAP EVENT"); // 디버그 출력!
  }

  void over() {
    pauseEngine();
    print("GAME OVER Score: $score");
  }
}
