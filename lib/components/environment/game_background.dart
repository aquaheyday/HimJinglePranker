import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';

import '../../core/assets.dart';
import '../../core/game_config.dart';
import '../../game/my_game.dart';

/// 패럴랙스 배경 래퍼 컴포넌트
class GameBackground extends Component with HasGameRef<MyGame> {
  late ParallaxComponent _parallax;

  double _scrollSpeed = 0;

  @override
  Future<void> onLoad() async {
    _parallax = await gameRef.loadParallaxComponent(
      [ParallaxImageData(Assets.background)],
      baseVelocity: Vector2.zero(),
      repeat: ImageRepeat.repeat,
    );

    add(_parallax);
  }

  void startScrolling() {
    _scrollSpeed = GameConfig.backgroundScrollSpeed;
    _updateVelocity();
  }

  void stopScrolling() {
    _scrollSpeed = 0;
    _updateVelocity();
  }

  void updateSpeed(double speed) {
    _scrollSpeed = speed;
    _updateVelocity();
  }

  void _updateVelocity() {
    _parallax.parallax?.baseVelocity = Vector2(_scrollSpeed, 0);
  }

  void reset() {
    stopScrolling();
  }
}