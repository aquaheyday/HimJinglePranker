import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../core/game_config.dart';
import '../../game/my_game.dart';

/// 게임 시작 전 표시되는 오버레이
class StartOverlay extends PositionComponent with HasGameRef<MyGame> {
  late TextComponent _startText;

  @override
  Future<void> onLoad() async {
    _startText = TextComponent(
      text: 'TAP TO START',
      anchor: Anchor.center,
      position: gameRef.size / 2,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: GameConfig.startTextFontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 6,
              color: Colors.black87,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
    );
    add(_startText);

    priority = 150;
  }

  /// 오버레이 숨기기 (게임 시작 시)
  void hide() {
    removeFromParent();
  }
}
