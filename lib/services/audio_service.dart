import 'package:flame_audio/flame_audio.dart';

import '../core/assets.dart';
import '../core/game_config.dart';

/// 게임 오디오를 관리하는 서비스
///
/// 싱글톤 패턴을 사용하여 앱 전체에서 하나의 인스턴스만 사용
class AudioService {
  // ============================================
  // Singleton 구현
  // ============================================
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  // ============================================
  // 상태
  // ============================================
  bool _isInitialized = false;
  bool _musicEnabled = true;
  bool _soundEnabled = true;
  double _musicVolume = GameConfig.defaultMusicVolume;
  double _soundVolume = GameConfig.defaultSoundVolume;

  // ============================================
  // 초기화
  // ============================================

  /// 오디오 시스템 초기화 (게임 시작 시 한 번만 호출)
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 효과음 프리로드
      await FlameAudio.audioCache.loadAll(Assets.allSounds);

      // BGM 초기화
      await FlameAudio.bgm.initialize();

      _isInitialized = true;
    } catch (e) {
      // 오디오 로드 실패해도 게임은 계속 진행
      print('AudioService initialization failed: $e');
    }
  }

  /// 리소스 해제 (앱 종료 시)
  void dispose() {
    FlameAudio.bgm.dispose();
    FlameAudio.audioCache.clearAll();
    _isInitialized = false;
  }

  // ============================================
  // 배경음악 제어
  // ============================================

  /// 배경음악 재생
  void playBackgroundMusic() {
    if (!_musicEnabled || !_isInitialized) return;

    try {
      FlameAudio.bgm.play(Assets.backgroundMusic, volume: _musicVolume);
    } catch (e) {
      print('Failed to play background music: $e');
    }
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

  // ============================================
  // 효과음 재생
  // ============================================

  void _playSound(String asset, {double volumeMultiplier = 1.0}) {
    if (!_soundEnabled || !_isInitialized) return;

    try {
      FlameAudio.play(asset, volume: _soundVolume * volumeMultiplier);
    } catch (e) {
      print('Failed to play sound $asset: $e');
    }
  }

  /// 점프 효과음
  void playJump() => _playSound(Assets.jumpSound);

  /// 게임오버 효과음
  void playGameOver() => _playSound(Assets.gameOverSound, volumeMultiplier: 0.8);

  /// 점수 획득 효과음
  void playScore() => _playSound(Assets.scoreSound, volumeMultiplier: 0.6);

  /// 충돌 효과음
  void playHit() => _playSound(Assets.hitSound, volumeMultiplier: 0.7);

  /// 착지 효과음
  void playLand() => _playSound(Assets.landSound, volumeMultiplier: 0.4);

  // ============================================
  // 설정 제어
  // ============================================

  /// 음악 켜기/끄기 토글
  void toggleMusic() {
    _musicEnabled = !_musicEnabled;

    if (_musicEnabled) {
      resumeBackgroundMusic();
    } else {
      pauseBackgroundMusic();
    }
  }

  /// 효과음 켜기/끄기 토글
  void toggleSound() {
    _soundEnabled = !_soundEnabled;
  }

  /// 음악 볼륨 설정 (0.0 ~ 1.0)
  void setMusicVolume(double volume) {
    _musicVolume = volume.clamp(0.0, 1.0);
    if (_isInitialized) {
      FlameAudio.bgm.audioPlayer.setVolume(_musicVolume);
    }
  }

  /// 효과음 볼륨 설정 (0.0 ~ 1.0)
  void setSoundVolume(double volume) {
    _soundVolume = volume.clamp(0.0, 1.0);
  }

  // ============================================
  // Getters
  // ============================================

  bool get isInitialized => _isInitialized;
  bool get isMusicEnabled => _musicEnabled;
  bool get isSoundEnabled => _soundEnabled;
  double get musicVolume => _musicVolume;
  double get soundVolume => _soundVolume;
}