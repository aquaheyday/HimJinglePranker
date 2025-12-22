import 'package:flame/components.dart';

import '../../core/assets.dart';
import '../../core/game_config.dart';
import '../../game/my_game.dart';

/// 무한 스크롤 바닥 컴포넌트
///
/// 2배 너비의 이미지를 사용하여 끊김 없이 스크롤
class ScrollingGround extends SpriteComponent with HasGameRef<MyGame> {
  /// 스크롤 활성화 여부
  bool isScrolling = false;

  /// 현재 스크롤 속도
  double _scrollSpeed;

  ScrollingGround({
    double? scrollSpeed,
  }) : _scrollSpeed = scrollSpeed ?? GameConfig.groundScrollSpeed;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(Assets.ground);

    // 화면 너비의 2배로 설정 (끊김 없는 스크롤을 위해)
    size = Vector2(gameRef.size.x * 2, GameConfig.groundHeight);

    // 화면 하단에 위치
    position = Vector2(0, gameRef.size.y - GameConfig.groundHeight);

    // 장애물보다 앞에 렌더링
    priority = 10;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isScrolling) return;

    // 왼쪽으로 스크롤
    position.x -= _scrollSpeed * dt;

    // 절반이 지나가면 원위치로 리셋 (무한 스크롤)
    if (position.x <= -gameRef.size.x) {
      position.x = 0;
    }
  }

  /// 스크롤 속도 업데이트 (난이도 조절용)
  void updateSpeed(double speed) {
    _scrollSpeed = speed;
  }

  /// 상태 초기화
  void reset() {
    position.x = 0;
    isScrolling = false;
    _scrollSpeed = GameConfig.groundScrollSpeed;
  }

  /// 스크롤 시작
  void startScrolling() {
    isScrolling = true;
  }

  /// 스크롤 정지
  void stopScrolling() {
    isScrolling = false;
  }
}
