import 'dart:typed_data';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../game/my_game.dart';

/// 모든 장애물의 기본 클래스
/// 
/// 공통 기능:
/// - 왼쪽으로 이동
/// - 플레이어 통과 시 점수 증가
/// - 화면 밖으로 나가면 제거
/// - 타일링 렌더링
abstract class BaseObstacle extends PositionComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  
  /// 스프라이트 이미지
  late Sprite sprite;
  
  /// 이미지 에셋 경로
  final String imagePath;
  
  /// 점수 트리거 여부 (하나의 장애물 그룹당 하나만 true)
  final bool isScoreTrigger;
  
  /// 플레이어가 이미 통과했는지 여부
  bool _hasPassed = false;
  
  /// 이동 속도 (외부에서 설정 가능)
  double speed;

  BaseObstacle({
    required Vector2 position,
    required Vector2 size,
    required this.imagePath,
    required this.speed,
    this.isScoreTrigger = false,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(imagePath);
    
    // 화면 오른쪽에서 시작
    position.x = gameRef.size.x;
    
    // 충돌 박스 추가
    add(RectangleHitbox());
    
    // 하위 클래스에서 Y 위치 설정
    onPositionReady();
  }

  /// 하위 클래스에서 Y 위치를 설정하기 위해 override
  void onPositionReady() {}

  @override
  void update(double dt) {
    super.update(dt);
    
    // 왼쪽으로 이동
    position.x -= speed * dt;
    
    // 점수 체크 (대표 장애물만)
    if (isScoreTrigger && !_hasPassed) {
      _checkScoring();
    }
    
    // 화면 밖으로 나가면 제거
    if (position.x + width < 0) {
      removeFromParent();
    }
  }

  void _checkScoring() {
    final santaRight = gameRef.santa.position.x + gameRef.santa.width;
    final obstacleRight = position.x + width;
    
    if (obstacleRight < santaRight) {
      _hasPassed = true;
      gameRef.onObstaclePassed();
    }
  }

  @override
  void render(Canvas canvas) {
    // 타일링 렌더링 (이미지가 세로로 반복됨)
    final obstacleImg = sprite.image;
    final double scale = width / obstacleImg.width;

    final matrix = Float64List.fromList([
      scale, 0,     0, 0,
      0,     scale, 0, 0,
      0,     0,     1, 0,
      0,     0,     0, 1,
    ]);

    final paint = Paint()
      ..shader = ImageShader(
        obstacleImg,
        TileMode.repeated,
        TileMode.repeated,
        matrix,
      );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, width, height),
      paint,
    );
  }

  /// 속도 업데이트 (난이도 변경 시)
  void updateSpeed(double newSpeed) {
    speed = newSpeed;
  }
}
