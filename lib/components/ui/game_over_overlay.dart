import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../core/game_config.dart';
import '../../game/my_game.dart';

/// 게임오버 시 표시되는 오버레이
class GameOverOverlay extends PositionComponent with HasGameRef<MyGame> {
  late TextComponent _gameOverText;
  late TextComponent _scoreText;
  late TextComponent _highScoreText;
  late TextComponent _restartText;
  late TextComponent _newHighScoreText;

  bool _isVisible = false;

  @override
  Future<void> onLoad() async {
    final centerX = gameRef.size.x / 2;
    final centerY = gameRef.size.y / 2;

    // 게임오버 제목
    _gameOverText = TextComponent(
      text: 'GAME OVER',
      anchor: Anchor.center,
      position: Vector2(centerX, centerY - 80),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: GameConfig.gameOverFontSize,
          fontWeight: FontWeight.bold,
          color: Colors.red,
          shadows: [
            Shadow(
              blurRadius: 8,
              color: Colors.black,
              offset: Offset(3, 3),
            ),
          ],
        ),
      ),
    );

    // 점수 표시
    _scoreText = TextComponent(
      text: 'Score: 0',
      anchor: Anchor.center,
      position: Vector2(centerX, centerY - 20),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 28,
          color: Colors.white,
        ),
      ),
    );

    // 최고 점수 표시
    _highScoreText = TextComponent(
      text: 'Best: 0',
      anchor: Anchor.center,
      position: Vector2(centerX, centerY + 20),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          color: Colors.white70,
        ),
      ),
    );

    // 새 최고 점수 표시
    _newHighScoreText = TextComponent(
      text: '🎉 NEW HIGH SCORE! 🎉',
      anchor: Anchor.center,
      position: Vector2(centerX, centerY + 60),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
    );

    // 재시작 안내
    _restartText = TextComponent(
      text: 'Tap to Restart',
      anchor: Anchor.center,
      position: Vector2(centerX, centerY + 100),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white60,
        ),
      ),
    );

    priority = 100;
  }

  /// 오버레이 표시
  void show({
    required int score,
    required int highScore,
    required bool isNewHighScore,
  }) {
    if (_isVisible) return;
    _isVisible = true;

    _scoreText.text = 'Score: $score';
    _highScoreText.text = 'Best: $highScore';

    add(_gameOverText);
    add(_scoreText);
    add(_highScoreText);
    add(_restartText);

    if (isNewHighScore) {
      add(_newHighScoreText);
    }
  }

  /// 오버레이 숨기기
  void hide() {
    if (!_isVisible) return;
    _isVisible = false;

    _gameOverText.removeFromParent();
    _scoreText.removeFromParent();
    _highScoreText.removeFromParent();
    _restartText.removeFromParent();
    _newHighScoreText.removeFromParent();
  }

  bool get isVisible => _isVisible;
}
