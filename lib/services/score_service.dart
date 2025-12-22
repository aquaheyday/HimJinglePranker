import 'package:shared_preferences/shared_preferences.dart';

/// 점수 관리 서비스
///
/// 현재 점수와 최고 점수를 관리하고
/// 로컬 저장소에 최고 점수를 저장/불러오기
class ScoreService {
  static const String _highScoreKey = 'high_score';

  int _score = 0;
  int _highScore = 0;
  SharedPreferences? _prefs;

  // ============================================
  // Getters
  // ============================================

  int get score => _score;
  int get highScore => _highScore;
  bool get isNewHighScore => _score > 0 && _score >= _highScore;

  // ============================================
  // 초기화
  // ============================================

  /// 서비스 초기화 및 저장된 최고 점수 불러오기
  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _highScore = _prefs?.getInt(_highScoreKey) ?? 0;
    } catch (e) {
      print('ScoreService initialization failed: $e');
      _highScore = 0;
    }
  }

  // ============================================
  // 점수 조작
  // ============================================

  /// 점수 1점 증가
  void increment() {
    _score++;
    _updateHighScoreIfNeeded();
  }

  /// 점수를 특정 값만큼 증가
  void addScore(int amount) {
    _score += amount;
    _updateHighScoreIfNeeded();
  }

  /// 점수 초기화 (게임 재시작 시)
  void reset() {
    _score = 0;
  }

  void _updateHighScoreIfNeeded() {
    if (_score > _highScore) {
      _highScore = _score;
      _saveHighScore();
    }
  }

  // ============================================
  // 저장/불러오기
  // ============================================

  /// 최고 점수를 로컬 저장소에 저장
  Future<void> _saveHighScore() async {
    try {
      await _prefs?.setInt(_highScoreKey, _highScore);
    } catch (e) {
      print('Failed to save high score: $e');
    }
  }

  /// 최고 점수 초기화 (디버그/설정용)
  Future<void> resetHighScore() async {
    _highScore = 0;
    await _prefs?.remove(_highScoreKey);
  }
}