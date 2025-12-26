import 'dart:math';

import 'package:flame/components.dart';

import '../../core/game_config.dart';
import '../../game/my_game.dart';
import 'base_obstacle.dart';
import 'ground_obstacle.dart';
import 'ceiling_obstacle.dart';
import '../../game/game_state.dart';

/// 장애물 생성 및 스폰 타이밍을 관리하는 컴포넌트
/// 
/// FlameGame에 컴포넌트로 추가되어 자동으로 update 호출됨
class ObstacleSpawner extends Component with HasGameRef<MyGame> {
  final Random _random = Random();
  
  double _spawnTimer = 0;
  double _spawnInterval;
  double _currentSpeed;

  ObstacleSpawner({
    double? spawnInterval,
    double? speed,
  }) : _spawnInterval = spawnInterval ?? GameConfig.initialSpawnInterval,
       _currentSpeed = speed ?? GameConfig.obstacleSpeed;

  @override
  void update(double dt) {
    super.update(dt);
    
    // 게임이 플레이 중일 때만 스폰
    if (!gameRef.gameState.isActive) return;
    
    _spawnTimer += dt;
    
    if (_spawnTimer >= _spawnInterval) {
      _spawnTimer = 0;
      _spawnObstacle();
    }
  }

  void _spawnObstacle() {
    final obstacle = _createRandomObstacle();
    gameRef.add(obstacle);
  }

  BaseObstacle _createRandomObstacle() {
    final roll = _random.nextInt(100);
    
    if (roll < GameConfig.groundObstacleChance) {
      return _createGroundObstacle();
    } else {
      return _createCeilingObstacle();
    }
  }

  GroundObstacle _createGroundObstacle() {
    final height = GameConfig.groundObstacleMinHeight +
        _random.nextDouble() * 
        (GameConfig.groundObstacleMaxHeight - GameConfig.groundObstacleMinHeight);
    
    return GroundObstacle(
      height: height,
      speed: _currentSpeed,
      isScoreTrigger: true,
    );
  }

  CeilingObstacle _createCeilingObstacle() {
    /*final height = GameConfig.ceilingObstacleMinHeight +
        _random.nextDouble() *
        (GameConfig.ceilingObstacleMaxHeight - GameConfig.ceilingObstacleMinHeight);*/
    final santaHeight = game.santa.height;

    const double clearance = 10.0;

    final gap = santaHeight + clearance;

    final height =
        game.size.y - GameConfig.groundHeight - gap;

    return CeilingObstacle(
      height: height,
      speed: _currentSpeed,
      isScoreTrigger: true,
    );
  }

  // ============================================
  // 외부 제어
  // ============================================
  
  /// 스폰 간격 업데이트 (난이도 조절용)
  void updateSpawnInterval(double interval) {
    _spawnInterval = interval;
  }

  /// 장애물 속도 업데이트 (난이도 조절용)
  void updateSpeed(double speed) {
    _currentSpeed = speed;
  }

  /// 타이머 리셋 (게임 재시작용)
  void reset() {
    _spawnTimer = 0;
    _spawnInterval = GameConfig.initialSpawnInterval;
    _currentSpeed = GameConfig.obstacleSpeed;
  }
}
