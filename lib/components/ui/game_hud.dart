import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../core/game_config.dart';
import '../../game/my_game.dart';

/// 게임 HUD (Head-Up Display)
/// 
/// 현재 점수와 최고 점수를 화면 상단에 표시
class GameHud extends PositionComponent with HasGameRef<MyGame> {
  late TextComponent _scoreText;
  late TextComponent _highScoreText;

  @override
  Future<void> onLoad() async {
    // 현재 점수 (중앙 상단)
    _scoreText = TextComponent(
      text: '0',
      anchor: Anchor.topCenter,
      position: Vector2(gameRef.size.x / 2, 20),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: GameConfig.scoreFontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 4,
              color: Colors.black54,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
    );
    add(_scoreText);

    // 최고 점수 (우측 상단)
    _highScoreText = TextComponent(
      text: 'BEST: ${gameRef.scoreService.highScore}',
      anchor: Anchor.topRight,
      position: Vector2(gameRef.size.x - 20, 20),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: GameConfig.highScoreFontSize,
          color: Colors.white70,
          shadows: [
            Shadow(
              blurRadius: 2,
              color: Colors.black38,
              offset: Offset(1, 1),
            ),
          ],
        ),
      ),
    );
    add(_highScoreText);

    // HUD는 항상 최상단에 렌더링
    priority = 200;
  }

  /// 점수 업데이트
  void updateScore(int score) {
    _scoreText.text = score.toString();
  }

  /// 최고 점수 업데이트
  void updateHighScore(int highScore) {
    _highScoreText.text = 'BEST: $highScore';
  }

  /// 전체 업데이트
  void refresh() {
    updateScore(gameRef.scoreService.score);
    updateHighScore(gameRef.scoreService.highScore);
  }
}
