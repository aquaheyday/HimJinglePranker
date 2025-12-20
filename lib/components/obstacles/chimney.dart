import 'dart:typed_data';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'dart:ui';

import 'package:him_jingle_pranker/config/game_config.dart';

/// 장애물
/// 6:4 (낭떠러지:굴뚝)
class Chimney extends PositionComponent with CollisionCallbacks {
  // late Sprite sprite;
  // late String img;
  // final double obstacleSpawnProbability; // 장애물 발생 확률
  // // late List<double> rect; // drawRect
  // late double? rectLeft;
  // late double? rectTop;
  // late double? rectWidth;
  // late double? rectHeight;

  // late Rect rect;
  final chimney = 'pipe.png';
  late Sprite sprite;

  // position: Vector2(game.size.x, game.size.y - 100),
  // size: Vector2(pipeWidth, chimneyHeight),
  // img: chimney,
  // obstacleSpawnProbability: 4,
  // // rect: Rect.fromLTWH(0, 0, 0, 0),
  // // 0, height - GameConfig.santaGravity, width, height
  // rectLeft: 0,
  // rectTop: GameConfig.santaGravity,
  // rectWidth: null,
  // rectHeight: null,
  Chimney({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  // Chimney({
  //   // required Vector2 position,
  //   // required Vector2 size,
  //   // required this.img,
  //   // required this.obstacleSpawnProbability,
  //   // required this.rectLeft,
  //   // required this.rectTop,
  //   // required this.rectWidth,
  //   // required this.rectHeight,
  //   // required this.rect,
  // }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(chimney);
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    if (sprite == null) return;

    final obstacleImg = sprite!.image;

    // 1. 가로 너비에 맞게 이미지를 스케일링할 배율 계산
    final double scale = width / obstacleImg.width;

    // 2. 이미지를 가로 너비에 맞춘 상태로 반복하기 위한 변환 행렬(Matrix) 생성
    // 가로와 세로를 scale만큼 키워야 패턴의 크기가 파이프 너비와 일치하게 됩니다.
    final matrix32 = Float64List.fromList([scale, 0, 0, 0, 0, scale, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]);

    // 3. Paint 객체에 반복 모드 설정
    final paint = Paint()
      ..shader = ImageShader(
        obstacleImg,
        TileMode.repeated, // 가로 반복 (필요 시)
        TileMode.repeated, // 세로 반복 (파이프가 길어지는 핵심)
        matrix32,
      );

    // 4. 원하는 크기만큼 사각형을 그리면 내부가 이미지로 채워집니다.
    // 가로는 고정된 width, 세로는 컴포넌트의 height만큼 그립니다.
    // canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);
    // canvas.drawRect(Rect.fromLTWH(rectLeft ?? 0, rectTop ?? 0, rectWidth ?? width, rectHeight ?? height), paint);
    // canvas.drawRect(rect, paint);
  }

  @override
  void update(double dt) {
    position.x -= 200 * dt;

    if (position.x + width < 0) removeFromParent();
  }
}
