import '../core/game_config.dart';

/// 게임 난이도를 관리하는 서비스
///
/// 점수에 따라 게임 속도와 스폰 간격을 조절
class DifficultyService {
  int _currentLevel = 1;

  // ============================================
  // Getters
  // ============================================

  int get currentLevel => _currentLevel;

  /// 현재 속도 배율 (1.0 ~ maxSpeedMultiplier)
  double get speedMultiplier {
    final multiplier = 1.0 +
        (_currentLevel - 1) * GameConfig.speedIncreasePerLevel;
    return multiplier.clamp(1.0, GameConfig.maxSpeedMultiplier);
  }

  /// 현재 스폰 간격
  double get spawnInterval {
    final interval = GameConfig.initialSpawnInterval -
        (_currentLevel - 1) * GameConfig.spawnIntervalDecrement;
    return interval.clamp(
      GameConfig.minSpawnInterval,
      GameConfig.initialSpawnInterval,
    );
  }

  /// 현재 장애물 속도
  double get obstacleSpeed => GameConfig.obstacleSpeed * speedMultiplier;

  /// 현재 바닥 스크롤 속도
  double get groundSpeed => GameConfig.groundScrollSpeed * speedMultiplier;

  /// 현재 배경 스크롤 속도
  double get backgroundSpeed => GameConfig.backgroundScrollSpeed * speedMultiplier;

  // ============================================
  // 난이도 업데이트
  // ============================================

  /// 점수에 따라 난이도 레벨 업데이트
  void updateForScore(int score) {
    _currentLevel = (score ~/ GameConfig.scorePerDifficultyIncrease) + 1;
  }

  /// 난이도 초기화
  void reset() {
    _currentLevel = 1;
  }
}