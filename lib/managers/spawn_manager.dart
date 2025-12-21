import '../game/my_game.dart';
import '../config/game_config.dart';
import '../components/obstacles/obstacle_factory.dart';

class SpawnManager {
  final MyGame game;
  final ObstacleFactory factory = ObstacleFactory();

  double spawnTimer = 0;
  final double spawnInterval;

  SpawnManager(
      this.game, {
        this.spawnInterval = GameConfig.spawnInterval,
      });

  void update(double dt) {
    spawnTimer += dt;

    if (spawnTimer >= spawnInterval) {
      spawnTimer = 0;

      // ⭐ 그냥 생성만
      game.add(factory.createRandom());
    }
  }

  void reset() {
    spawnTimer = 0;
  }
}
