// import 'package:desktop_window/desktop_window.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'manager/main_game.dart';

final Size customizeSize = const Size(640, 360);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await windowManager.ensureInitialized();

  /// window_manager: ^0.5.1 변경 예정
  // await DesktopWindow.setWindowSize(customizeSize);
  // await windowManager.setMinimumSize(const Size(600, 400));
  // await windowManager.setMaximumSize(const Size(1920, 1080));

  final mainGame = MainGame();
  runApp(GameWidget(game: mainGame));
}
