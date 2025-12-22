/// 게임의 현재 상태를 나타내는 열거형
enum GameState {
  /// 게임 시작 전 준비 상태
  ready,

  /// 게임 플레이 중
  playing,

  /// 일시정지 상태
  paused,

  /// 게임오버 상태
  gameOver,
}

/// GameState 확장 메서드
extension GameStateExtension on GameState {
  /// 게임이 활성 상태인지 (스크롤 등이 동작해야 하는지)
  bool get isActive => this == GameState.playing;

  /// 입력을 받을 수 있는 상태인지
  bool get canReceiveInput => this != GameState.paused;

  /// 게임이 종료된 상태인지
  bool get isEnded => this == GameState.gameOver;

  /// 재시작 가능한 상태인지
  bool get canRestart => this == GameState.gameOver;

  /// 일시정지 가능한 상태인지
  bool get canPause => this == GameState.playing;
}