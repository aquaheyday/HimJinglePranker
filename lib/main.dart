import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:him_jingle_pranker/services/components.dart';

import 'manager/main_game.dart';

void main() {
  final mainGame = MainGame();
  runApp(GameWidget(game: mainGame));
}
