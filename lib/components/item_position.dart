import 'dart:async';

import 'package:flame/components.dart';
import 'package:him_jingle_pranker/manager/main_game.dart';

import 'item.dart';

class ItemPosition extends PositionComponent with HasGameReference<MainGame> {
  final itemList = [
    Item(itemType: ItemType.snowball, itemPosition: Vector2(110, 20)),
  ];

  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    addAll(itemList);
    return super.onLoad();
  }
}
