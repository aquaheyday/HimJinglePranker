/// 게임 전체 설정을 중앙에서 관리하는 클래스
///
/// 모든 게임 관련 상수값을 여기서 관리하여
/// 밸런싱 조정이 용이하도록 함
class GameConfig {
  GameConfig._(); // 인스턴스화 방지

  // ============================================
  // 플레이어 (Santa) 설정
  // ============================================
  static const double santaWidth = 100.0;
  static const double santaHeight = 100.0;
  static const double santaGravity = 600.0;
  static const double santaJumpForce = -600.0;
  static const double santaStartXRatio = 0.2; // 화면 왼쪽에서 20% 위치

  // ============================================
  // 바닥 (Ground) 설정
  // ============================================
  static const double groundHeight = 100.0;
  static const double groundScrollSpeed = 200.0;

  // ============================================
  // 장애물 (Obstacle) 설정
  // ============================================
  static const double obstacleSpeed = 200.0;
  static const double obstacleWidth = 60.0;

  // 바닥 장애물 높이 범위
  static const double groundObstacleMinHeight = 50.0;
  static const double groundObstacleMaxHeight = 90.0;

  // 천장 장애물 높이 범위
  static const double ceilingObstacleMinHeight = 100.0;
  static const double ceilingObstacleMaxHeight = 220.0;

  // 스폰 설정
  static const double initialSpawnInterval = 2.0;
  static const double minSpawnInterval = 1.0;
  static const double spawnIntervalDecrement = 0.05; // 점수당 감소량

  // 장애물 타입 확률 (0~100)
  static const int groundObstacleChance = 60; // 60% 바닥, 40% 천장

  // ============================================
  // 배경 (Background) 설정
  // ============================================
  static const double backgroundScrollSpeed = 20.0;

  // ============================================
  // UI 설정
  // ============================================
  static const double scoreFontSize = 32.0;
  static const double gameOverFontSize = 40.0;
  static const double startTextFontSize = 36.0;
  static const double highScoreFontSize = 24.0;

  // ============================================
  // 오디오 설정
  // ============================================
  static const double defaultMusicVolume = 0.5;
  static const double defaultSoundVolume = 1.0;

  // ============================================
  // 난이도 설정
  // ============================================
  static const int scorePerDifficultyIncrease = 5; // 5점마다 난이도 상승
  static const double maxSpeedMultiplier = 2.0;
  static const double speedIncreasePerLevel = 0.1;
}
