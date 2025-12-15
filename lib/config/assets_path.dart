class AssetsPath {
  // 이미지
  static const String santa = 'santa.png';
  static const String chimney = 'pipe.png';
  static const String roofEdge = 'pipe2.png';
  static const String ground = 'ground.png';
  static const String background = 'nightbackground2.png';

  // 사운드 (나중에 추가)
  static const String jumpSound = 'sounds/jump.mp3';
  static const String gameOverSound = 'sounds/gameover.mp3';

  // 모든 에셋 로드
  static List<String> get allImages => [
    santa,
    chimney,
    roofEdge,
    ground,
    background,
  ];
}