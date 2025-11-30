import 'dart:async';

import 'package:flame/components.dart';

import '../manager/main_game.dart';

class GameBackground extends SpriteComponent with HasGameReference<MainGame> {
  @override
  FutureOr<void> onLoad() async {
    final map = await game.images.load('path');
    sprite = Sprite(map);
    size = game.size;

    // TODO: implement onLoad
    return super.onLoad();
  }
}
