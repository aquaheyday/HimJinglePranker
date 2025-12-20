import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  // ⭐ Singleton 패턴
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  // 설정
  bool _musicEnabled = true;
  bool _soundEnabled = true;
  double _musicVolume = 0.5;
  double _soundVolume = 1.0;

  bool _unlocked = false;

  void unlock() {
    if (_unlocked) return;

    // 무음으로 한 번 재생해서 AudioContext 열기
    FlameAudio.play('audio/sounds/jump.wav', volume: 0);
    _unlocked = true;
  }

  /// 초기화 (게임 시작 시 한 번만)
  Future<void> init() async {
    await FlameAudio.audioCache.loadAll([
      'sounds/jump.wav',
      'sounds/game_over.wav',
      // 'audio/sounds/hit.wav',
      // 'audio/sounds/land.wav',
    ]);

    await FlameAudio.bgm.initialize();
  }

  // ===== 배경음악 =====

  /// 배경음악 재생
  void playBackgroundMusic() {
    if (!_musicEnabled) return;
    FlameAudio.bgm.play('music/background.wav', volume: _musicVolume);
  }

  /// 배경음악 정지
  void stopBackgroundMusic() {
    FlameAudio.bgm.stop();
  }

  /// 배경음악 일시정지
  void pauseBackgroundMusic() {
    FlameAudio.bgm.pause();
  }

  /// 배경음악 재개
  void resumeBackgroundMusic() {
    if (!_musicEnabled) return;
    FlameAudio.bgm.resume();
  }

  // ===== 효과음 =====

  /// 점프 소리
  void playJump() {
    if (!_soundEnabled) return;
    FlameAudio.play('sounds/jump.wav');
  }

  /// 충돌 소리
  void playHit() {
    if (!_soundEnabled) return;
    FlameAudio.play('sounds/hit.wav', volume: _soundVolume * 0.7);
  }

  /// 착지 소리
  void playLand() {
    if (!_soundEnabled) return;
    FlameAudio.play('sounds/land.wav', volume: _soundVolume * 0.4);
  }

  /// 점수 소리
  void playScore() {
    if (!_soundEnabled) return;
    FlameAudio.play('sounds/score.wav', volume: _soundVolume * 0.6);
  }

  /// 게임오버 소리
  void playGameOver() {
    if (!_soundEnabled) return;
    FlameAudio.play('sounds/game_over.wav', volume: _soundVolume * 0.8);
  }

  // ===== 설정 =====

  /// 음악 켜기/끄기
  void toggleMusic() {
    _musicEnabled = !_musicEnabled;

    if (_musicEnabled) {
      resumeBackgroundMusic();
    } else {
      pauseBackgroundMusic();
    }
  }

  /// 효과음 켜기/끄기
  void toggleSound() {
    _soundEnabled = !_soundEnabled;
  }

  /// 모든 오디오 켜기/끄기
  void toggleAll(bool enabled) {
    _musicEnabled = enabled;
    _soundEnabled = enabled;

    if (!enabled) {
      stopBackgroundMusic();
    } else {
      playBackgroundMusic();
    }
  }

  /// 음악 볼륨 설정 (0.0 ~ 1.0)
  void setMusicVolume(double volume) {
    _musicVolume = volume.clamp(0.0, 1.0);
    FlameAudio.bgm.audioPlayer.setVolume(_musicVolume);
  }

  /// 효과음 볼륨 설정 (0.0 ~ 1.0)
  void setSoundVolume(double volume) {
    _soundVolume = volume.clamp(0.0, 1.0);
  }

  // ===== Getters =====

  bool get isMusicEnabled => _musicEnabled;
  bool get isSoundEnabled => _soundEnabled;
  double get musicVolume => _musicVolume;
  double get soundVolume => _soundVolume;

  /// 정리 (앱 종료 시)
  void dispose() {
    FlameAudio.bgm.dispose();
    FlameAudio.audioCache.clearAll();
  }
}