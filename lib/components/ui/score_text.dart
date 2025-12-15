import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ScoreText extends TextComponent {
  ScoreText() : super(
    text: '0',
    anchor: Anchor.topCenter,
    textRenderer: TextPaint(
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );

  void updateScore(int score) {
    text = score.toString();
  }
}