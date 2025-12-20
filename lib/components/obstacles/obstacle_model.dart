import 'dart:ui';

import 'package:flame/components.dart';

class ObstacleInstance {
  // // final ObstacleSpec spec;
  // final Vector2 position;
  // final Vector2 size;
  // final double speed;
  // final double createdAt;

  // late Sprite? sprite;
  late String img;
  late double? obstacleSpawnProbability; // 장애물 발생 확률
  // late List<double> rect; // drawRect
  late double? rectLeft;
  late double? rectTop;
  late double? rectWidth;
  late double? rectHeight;
  late Rect? rect;

  ObstacleInstance({
    // required this.spec,
    // required this.position,
    // required this.size,
    // required this.speed,
    // required this.createdAt,

    // this.sprite,
    required this.img,
    this.rectLeft,
    this.rectTop,
    this.rectWidth,
    this.rectHeight,
    this.rect,
    this.obstacleSpawnProbability,
  });

  factory ObstacleInstance.fromSpec({
    // required ObstacleSpec spec,
    // required Vector2 position,
    // required double createdAt,
    // double? speed,
    // Vector2? size,
    required img,
    rectLeft,
    rectTop,
    rectWidth,
    rectHeight,
    rect,
    obstacleSpawnProbability,
  }) {
    return ObstacleInstance(
      img: img,
      rectLeft: rectLeft ?? '',
      rectTop: rectTop ?? '',
      rectWidth: rectWidth ?? '',
      rectHeight: rectHeight ?? '',
      rect: rect ?? '',
      obstacleSpawnProbability: obstacleSpawnProbability ?? '',
      // spec: spec,
      // position: position,
      // size: size ?? spec.size,
      // speed: speed ?? spec.baseSpeed,
      // createdAt: createdAt,
    );
  }
}
