import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class Keyboard extends Component with KeyboardHandler {
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // TODO: implement onKeyEvent
    /// 종료 ?
    final escape = keysPressed.contains(LogicalKeyboardKey.escape);
    if (escape) SystemNavigator.pop();
    return super.onKeyEvent(event, keysPressed);
  }
}
