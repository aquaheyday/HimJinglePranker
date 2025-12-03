import 'dart:async';

import 'package:flame/components.dart';
import 'package:him_jingle_pranker/manager/assets.dart';
import 'package:him_jingle_pranker/manager/main_game.dart';

import '../manager/config.dart';

class Item extends SpriteGroupComponent<ItemType> with HasGameReference<MainGame> {
  final ItemType itemType;
  final Vector2 itemPosition;

  Item({
    required this.itemType,
    required this.itemPosition,
  });

  @override
  FutureOr<void> onLoad() async {
    position = itemPosition;
    size = Config.itemSize;
    priority = 2;
    sprites = {
      ItemType.snowball: Sprite(game.images.fromCache(ImageAssets.snowball)), // item
    };
    current = itemType;
    print(Sprite(game.images.fromCache(ImageAssets.snowball)));
    return super.onLoad();
  }
}

enum ItemType { snowball }
