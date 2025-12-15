class GameConfig {
  // Santa 설정
  static const double santaWidth = 50.0;
  static const double santaHeight = 50.0;
  static const double santaGravity = 600.0;
  static const double santaJumpForce = -300.0;

  // Ground 설정
  static const double groundHeight = 100.0;
  static const double groundScrollSpeed = 200.0;

  // Obstacle 설정
  static const double obstacleSpeed = 200.0;
  static const double obstacleWidth = 60.0;
  static const double chimneyHeight = 50.0;
  static const double spawnInterval = 2.0;
  static const double gapSize = 150.0;
  static const double minObstacleHeight = 20.0;

  // Background 설정
  static const double backgroundScrollSpeed = 20.0;

  // UI 설정
  static const double scoreFontSize = 32.0;
  static const double gameOverFontSize = 40.0;
}

class Assets {
  static const String santa = 'santa.png';
  static const String chimney = 'pipe.png';
  static const String roofEdge = 'pipe2.png';
  static const String ground = 'ground.png';
  static const String background = 'nightbackground2.png';
}