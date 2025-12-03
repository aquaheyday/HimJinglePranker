import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:him_jingle_pranker/components/item_position.dart';
import 'package:him_jingle_pranker/components/player_animation.dart';
import 'package:him_jingle_pranker/manager/keyboard.dart';

import '../components/game_background.dart';

class MainGame extends FlameGame with HasKeyboardHandlerComponents {
  late final Keyboard keyboard;
  late final ItemPosition itemPosition;
  late final PlayerAnimation player;

  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    await images.loadAllImages();
    addAll([
      GameBackground(),
      keyboard = Keyboard(),
      itemPosition = ItemPosition(),
      player = PlayerAnimation(),
    ]);
    return super.onLoad();
  }
}
