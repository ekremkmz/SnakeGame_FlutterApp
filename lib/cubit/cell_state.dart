part of 'cell_cubit.dart';

abstract class CellState extends StatefulWidget {
  final int width;
  final int coordX;
  final int coordY;
  final GameBoardState gameBoardState;
  const CellState(
    this.width,
    this.coordX,
    this.coordY,
    this.gameBoardState, {
    Key key,
  }) : super(key: key);
  void cellAction() {
    gameBoardState.gameover();
  }
}

class EmptyCell extends CellState {
  EmptyCell(int width, int coordX, int coordY, GameBoardState gameBoardState)
      : super(width, coordX, coordY, gameBoardState);

  @override
  createState() => _EmptyCellState();
  @override
  void cellAction() {
    gameBoardState.head = gameBoardState.target;
    gameBoardState.board[gameBoardState.target['x']]
        [gameBoardState.target['y']] = gameBoardState.target['score'] + 1;
    gameBoardState.board = gameBoardState.board
        .map((e) => e.map((e) => e > 0 ? e - 1 : e).toList())
        .toList();
  }
}

class _EmptyCellState extends State<EmptyCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade900,
      padding: EdgeInsets.all(widget.width / 2 - 2),
      margin: EdgeInsets.all(2),
    );
  }
}

class HeadCell extends CellState {
  HeadCell(int width, int coordX, int coordY, GameBoardState gameBoardState)
      : super(width, coordX, coordY, gameBoardState);

  @override
  _HeadCellState createState() => _HeadCellState();
}

class _HeadCellState extends State<HeadCell> {
  @override
  Widget build(BuildContext context) {
    return AnimatedHead(width: widget.width);
  }
}

class TailCell extends EmptyCell {
  TailCell(int width, int coordX, int coordY, GameBoardState gameBoardState)
      : super(width, coordX, coordY, gameBoardState);

  @override
  _TailCellState createState() => _TailCellState();
}

class _TailCellState extends State<TailCell> {
  @override
  Widget build(BuildContext context) {
    return AnimatedTail(width: widget.width);
  }
}

class PortalCell extends CellState {
  final int targetX;
  final int targetY;
  PortalCell(int width, int coordX, int coordY, this.targetX, this.targetY,
      GameBoardState gameBoardState)
      : super(width, coordX, coordY, gameBoardState);

  @override
  _PortalCellState createState() => _PortalCellState();

  @override
  void cellAction() {
    gameBoardState.target = {
      'x': targetX + gameBoardState.delta['dx'],
      'y': targetY + gameBoardState.delta['dy'],
      'score': gameBoardState.head['score']
    };
    gameBoardState.doTargetCellAction();
  }
}

class _PortalCellState extends State<PortalCell> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          color: Colors.black,
          padding: EdgeInsets.all(widget.width / 2 - 2),
          margin: EdgeInsets.all(2),
        ),
        AnimatedPortal(width: widget.width)
      ],
    );
  }
}

class SnakeCell extends CellState {
  SnakeCell(int width, int coordX, int coordY, GameBoardState gameBoardState)
      : super(width, coordX, coordY, gameBoardState);

  @override
  _SnakeCellState createState() => _SnakeCellState();
}

class _SnakeCellState extends State<SnakeCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      padding: EdgeInsets.all(widget.width / 2 - 1),
      margin: EdgeInsets.all(1),
    );
  }
}

class FoodCell extends CellState {
  FoodCell(int width, int coordX, int coordY, GameBoardState gameBoardState)
      : super(width, coordX, coordY, gameBoardState);

  @override
  _FoodCellState createState() => _FoodCellState();

  void cellAction() {
    gameBoardState.head = gameBoardState.target;
    gameBoardState.head['score']++;
    gameBoardState.board[gameBoardState.head['x']][gameBoardState.head['y']] =
        gameBoardState.head['score'];
    BlocProvider.of<ScoreCubit>(gameBoardState.context, listen: false)
        .increment();
    gameBoardState.newFood();
  }
}

class _FoodCellState extends State<FoodCell> {
  @override
  Widget build(BuildContext context) {
    return AnimatedFood(width: widget.width);
  }
}
