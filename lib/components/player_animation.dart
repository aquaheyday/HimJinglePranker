import 'dart:async';

import 'package:flame/components.dart';
import 'package:him_jingle_pranker/manager/assets.dart';
import 'package:him_jingle_pranker/manager/main_game.dart';

import '../manager/config.dart';

class PlayerAnimation extends SpriteAnimationGroupComponent with HasGameReference<MainGame> {
  @override
  FutureOr<void> onLoad() async {
    position = Config.playerInitPosition;

    final idleAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache(ImageAssets.santa),
      SpriteAnimationData.sequenced(
        amount: 7,
        stepTime: Config.playerSpeed, // Config.stepTime
        textureSize: Config.playerSize,
      ),
    );
    final walkAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache(ImageAssets.santa),
      SpriteAnimationData.sequenced(
        amount: 7,
        stepTime: Config.playerSpeed, // Config.stepTime
        textureSize: Config.playerSize,
      ),
    );
    final trackAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache(ImageAssets.santa),
      SpriteAnimationData.sequenced(
        amount: 7,
        stepTime: Config.playerSpeed, // Config.stepTime
        textureSize: Config.playerSize,
      ),
    );

    animations = {
      PlayerState.idle: idleAnimation,
    };
    current = PlayerState.idle;
    return super.onLoad();
  }
}

enum PlayerState {
  idle,
  track,
  walk,
}
