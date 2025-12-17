import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  static bool _enabled = true;

  static Future<void> init() async {
    await FlameAudio.audioCache.loadAll([
      'jump.wav',
      // 'hit.wav',
      // 'land.wav',
      // 'bgm.mp3',
    ]);
  }

  static void playJump() {
    if (!_enabled) return;
    FlameAudio.play('jump.wav', volume: 0.5);
  }

  static void playHit() {
    if (!_enabled) return;
    FlameAudio.play('hit.wav', volume: 0.7);
  }

  static void playBgm() {
    if (!_enabled) return;
    FlameAudio.bgm.play('bgm.mp3', volume: 0.25);
  }

  static void stopBgm() {
    FlameAudio.bgm.stop();
  }

  static void toggle(bool enabled) {
    _enabled = enabled;
    if (!enabled) {
      FlameAudio.bgm.stop();
    }
  }
}
