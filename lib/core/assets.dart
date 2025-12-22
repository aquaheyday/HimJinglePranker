/// 모든 에셋 경로를 중앙에서 관리
/// 
/// 에셋 경로 오타 방지 및 자동완성 지원
class Assets {
  Assets._(); // 인스턴스화 방지

  // ============================================
  // 이미지 에셋
  // ============================================
  static const String santa = 'santa3.png';
  static const String chimney = 'pipe.png';
  static const String roofEdge = 'pipe2.png';
  static const String ground = 'pipe3.png';
  static const String background = 'nightbackground2.png';

  /// 프리로드할 모든 이미지 목록
  static List<String> get allImages => [
    santa,
    chimney,
    roofEdge,
    ground,
    background,
  ];

  // ============================================
  // 오디오 에셋 - 효과음
  // ============================================
  static const String jumpSound = 'sounds/jump.wav';
  static const String gameOverSound = 'sounds/game_over.wav';
  static const String hitSound = 'sounds/hit.wav';
  static const String landSound = 'sounds/land.wav';
  static const String scoreSound = 'sounds/score.wav';

  /// 프리로드할 모든 효과음 목록
  static List<String> get allSounds => [
    jumpSound,
    gameOverSound,
    // 아래는 파일이 있을 때 추가
    // hitSound,
    // landSound,
    // scoreSound,
  ];

  // ============================================
  // 오디오 에셋 - 배경음악
  // ============================================
  static const String backgroundMusic = 'music/background.wav';

  /// 프리로드할 모든 배경음악 목록
  static List<String> get allMusic => [
    backgroundMusic,
  ];
}
