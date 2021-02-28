import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:snake_game/cubit/timer_cubit.dart';
import '../../cubit/cell_cubit.dart';
import '../../cubit/score_cubit.dart';
import '../../model/levelData.dart';
import '../active_direction.dart';

class GameBoard extends StatefulWidget {
  final int cellWidth;
  final int selectedLevel;
  GameBoard(
    this.selectedLevel,
    this.cellWidth, {
    Key key,
  }) : super(key: key);

  @override
  GameBoardState createState() => GameBoardState();
}

class GameBoardState extends State<GameBoard> {
  List<List<int>> board;
  List<List<CellCubit>> cells;
  Map<String, int> delta;
  Map<String, int> head;
  Map<String, int> target;
  Map<String, String> portals;
  LevelData levelData;

  ActiveDirection activeDirection;
  bool gameOver;

  @override
  void initState() {
    super.initState();
    activeDirection = Provider.of<ActiveDirection>(context, listen: false);
    levelData = Provider.of<LevelData>(context, listen: false);
    restart();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        _board(),
        gameOver == true ? _gameOverWidget() : Container(),
      ],
    );
  }

  Widget _gameOverWidget() {
    return Card(
      child: Container(
        margin: EdgeInsets.all(25),
        child: Column(
          children: [
            Text(
              "Game Over",
              style: TextStyle(fontSize: 32),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () {
                setState(restart);
              },
              child: Icon(Icons.restore),
            )
          ],
        ),
      ),
    );
  }

  Widget _board() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: cells
          .map((e) => Column(
                children: e.map((e) {
                  return BlocBuilder<CellCubit, CellState>(
                    cubit: e,
                    builder: (context, state) {
                      return state;
                    },
                    buildWhen: (prev, curr) {
                      return (prev.runtimeType == curr.runtimeType)
                          ? false
                          : true;
                    },
                  );
                }).toList(),
              ))
          .toList(),
    );
  }

  void restart() {
    board = levelData.getLevelData(widget.selectedLevel);
    cells = List.generate(
        20,
        (i) => List.generate(
            20, (j) => CellCubit(widget.cellWidth, i, j, levelData, this)));

    head = levelData.head;
    _updateCells();
    portals = levelData.portals ?? {};
    gameOver = false;
    BlocProvider.of<ScoreCubit>(context, listen: false).restart();
    Provider.of<ActiveDirection>(context, listen: false).direction =
        Direction.right;
    newFood();
    startGame();
  }

  void startGame() {
    Provider.of<TimerCubit>(context, listen: false).startTimer();
    Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      _updateBoard();
      _updateCells();
      if (gameOver) {
        timer.cancel();
      }
    });
  }

  void gameover() {
    Provider.of<TimerCubit>(context, listen: false).stopTimer();
    setState(() {
      gameOver = true;
    });
  }

  void _updateCells() {
    for (var i = 0; i < 20; i++) {
      for (var j = 0; j < 20; j++) {
        cells[i][j].setCell(board[i][j], head['score']);
        activeDirection.lastDirection = activeDirection.direction;
      }
    }
  }

  void _updateBoard() {
    delta = activeDirection.getDelta();
    target = {
      'x': (head['x'] + delta['dx']) % 20,
      'y': (head['y'] + delta['dy']) % 20,
      'score': head['score'],
    };
    doTargetCellAction();
  }

  void doTargetCellAction() {
    cells[target['x']][target['y']].state.cellAction();
  }

  void newFood() {
    bool foodPlaced = false;
    int newFoodLocation =
        Random().nextInt(400 - head['score'] - portals?.length);
    board = board
        .map((e) => e.map((cell) {
              if (!foodPlaced) {
                if (cell == 0) {
                  newFoodLocation--;
                  if (newFoodLocation == -1) {
                    foodPlaced = true;
                    return -1;
                  }
                }
              }
              return cell;
            }).toList())
        .toList();
  }
}
