class LevelData {
  List<List<int>> board;
  int selectedLevel;
  Map<String, int> head;
  Map<String, String> portals;
  List<List<int>> getLevelData(int level) {
    switch (level) {
      case 2:
        board = List.generate(20, (index) => List.generate(20, (index) => 0));
        board[5][5] = 1;
        head = {'x': 5, 'y': 5, 'score': 1};

        board[15][5] = -2;
        board[5][15] = -2;
        portals = {
          '15,5': '5,15',
          '5,15': '15,5',
        };
        return board;
      case 1:
      default:
        board = List.generate(20, (index) => List.generate(20, (index) => 0));
        board[5][5] = 1;
        head = {'x': 5, 'y': 5, 'score': 1};
        return board;
    }
  }
}
