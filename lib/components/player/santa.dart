import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../core/assets.dart';
import '../../core/game_config.dart';
import '../../game/my_game.dart';
import '../obstacles/base_obstacle.dart';
import '../../game/game_state.dart';

/// 플레이어 캐릭터 (산타)
/// 
/// 기능:
/// - 중력 적용
/// - 점프
/// - 바닥 충돌 감지
/// - 장애물 충돌 감지
class Santa extends SpriteComponent with HasGameRef<MyGame>, CollisionCallbacks {
  /// 수직 속도
  double velocityY = 0;
  
  /// 바닥에 닿아있는지 여부
  bool isOnGround = true;
  
  /// 점프 가능 여부
  bool get canJump => isOnGround;

  Santa() : super(
    size: Vector2(GameConfig.santaWidth, GameConfig.santaHeight),
  );

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(Assets.santa);
    
    // 초기 위치 설정
    _resetPosition();
    
    // 원형 충돌 박스 (캐릭터에 더 적합)
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // 게임이 플레이 중이 아니면 물리 적용 안 함
    if (!gameRef.gameState.isActive) return;
    
    _applyGravity(dt);
    _updatePosition(dt);
    _checkGroundCollision();
  }

  void _applyGravity(double dt) {
    velocityY += GameConfig.santaGravity * dt;
  }

  void _updatePosition(double dt) {
    position.y += velocityY * dt;
  }

  void _checkGroundCollision() {
    final groundY = gameRef.size.y - GameConfig.groundHeight;
    
    if (position.y + height >= groundY) {
      // 바닥에 착지
      position.y = groundY - height;
      velocityY = 0;
      isOnGround = true;
      
      // 홀딩 중이면 자동 점프
      if (gameRef.isHolding) {
        jump();
      }
    } else {
      isOnGround = false;
    }
  }

  /// 점프 실행
  void jump() {
    if (!canJump) return;
    
    velocityY = GameConfig.santaJumpForce;
    isOnGround = false;
    
    // 점프 사운드 재생
    gameRef.audioService.playJump();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    
    // 장애물과 충돌하면 게임오버
    if (other is BaseObstacle) {
      gameRef.onPlayerHit();
    }
  }

  /// 위치 및 상태 초기화 (게임 시작/재시작 시)
  void reset() {
    _resetPosition();
    velocityY = 0;
    isOnGround = true;
  }

  void _resetPosition() {
    final groundY = gameRef.size.y - GameConfig.groundHeight;
    position = Vector2(
      gameRef.size.x * GameConfig.santaStartXRatio,
      groundY - height,
    );
  }
}
