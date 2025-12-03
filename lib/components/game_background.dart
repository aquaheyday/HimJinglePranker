import 'dart:async';

import 'package:flame/components.dart';
import 'package:him_jingle_pranker/manager/assets.dart';

import '../manager/main_game.dart';

class GameBackground extends SpriteComponent with HasGameReference<MainGame> {
  @override
  FutureOr<void> onLoad() async {
    /// assets/images/가 이미 포함
    sprite = Sprite(game.images.fromCache(ImageAssets.map));

    size = game.size;
    priority = 0;

    // TODO: implement onLoad
    return super.onLoad();
  }

  @override
  void onMount() {
    // TODO: implement onMount
    /// audio
    super.onMount();
  }
}
