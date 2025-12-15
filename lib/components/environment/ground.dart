import 'package:flame/components.dart';
import 'package:him_jingle_pranker/game/my_game.dart';

class ScrollingGround extends SpriteComponent with HasGameRef<MyGame> {
  final double scrollSpeed;

  ScrollingGround({
    required this.scrollSpeed,
  });

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('pipe3.png');

    final groundHeight = 100.0;
    size = Vector2(gameRef.size.x * 2, groundHeight); // 2배 너비!
    position = Vector2(0, gameRef.size.y - groundHeight);
    priority = 10;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 왼쪽으로 스크롤
    position.x -= scrollSpeed * dt;

    // 화면 절반만큼 나가면 원위치
    if (position.x <= -gameRef.size.x) {
      position.x = 0;
    }
  }
}