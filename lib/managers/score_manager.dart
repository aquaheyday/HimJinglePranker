class ScoreManager {
  int _score = 0;
  int _highScore = 0;

  int get score => _score;
  int get highScore => _highScore;

  void increase() {
    _score++;
    if (_score > _highScore) {
      _highScore = _score;
    }
  }

  void reset() {
    _score = 0;
  }

  // 나중에 저장 기능 추가 가능
  Future<void> saveHighScore() async {
    // SharedPreferences 등으로 저장
  }

  Future<void> loadHighScore() async {
    // 저장된 최고 점수 불러오기
  }
}