import 'package:flame/components.dart';

import '../main.dart';

class Config {
  static final itemSize = Vector2.all(32);
  static final playerSize = Vector2.all(10);
  static final playerInitPosition = Vector2.all(422);
  static const playerSpeed = 2.0;

  static get sceneSize => customizeSize;
}

class Global {
  static const int score = 0;
}
