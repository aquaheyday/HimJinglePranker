import 'dart:typed_data';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import '../../game/my_game.dart';

/// 장애물 공통 클래스
/// - 대표 장애물(isScoreTrigger = true)만 점수 증가
class Obstacle extends PositionComponent
    with CollisionCallbacks, HasGameRef<MyGame> {

  late Sprite sprite;
  final String img;

  /// ⭐ 점수 트리거 여부
  final bool isScoreTrigger;

  bool _isPassed = false;

  Obstacle({
    required Vector2 position,
    required Vector2 size,
    required this.img,
    this.isScoreTrigger = false,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(img);
    add(RectangleHitbox());

    // ⭐ 화면 오른쪽에서 시작
    position.x = gameRef.size.x;

    // ⭐ 이게 없으면 GroundObstacle Y 계산 안 됨
    onPositionReady();
  }

  /// 하위 클래스에서 override
  void onPositionReady() {}

  @override
  void render(Canvas canvas) {
    final obstacleImg = sprite.image;

    // 가로 기준 스케일
    final double scale = width / obstacleImg.width;

    final matrix = Float64List.fromList([
      scale, 0,     0, 0,
      0,     scale, 0, 0,
      0,     0,     1, 0,
      0,     0,     0, 1,
    ]);

    final paint = Paint()
      ..shader = ImageShader(
        obstacleImg,
        TileMode.repeated,
        TileMode.repeated,
        matrix,
      );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, width, height),
      paint,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 이동
    position.x -= 200 * dt;

    // ⭐ 대표 장애물만 점수 체크
    if (isScoreTrigger &&
        !_isPassed &&
        position.x + width < gameRef.santa.position.x) {
      _isPassed = true;
      gameRef.increaseScore();
    }

    // 화면 밖 제거
    if (position.x + width < 0) {
      removeFromParent();
    }
  }
}
