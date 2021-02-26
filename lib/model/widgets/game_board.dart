import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:snake_game/cubit/score_cubit.dart';
import 'package:snake_game/model/levelData.dart';
import 'package:snake_game/model/widgets/animated_head.dart';

import '../active_direction.dart';
import 'animated_food.dart';
import 'animated_portal.dart';
import 'animated_tail.dart';

class GameBoard extends StatefulWidget {
  final int selectedLevel;
  GameBoard(this.selectedLevel, {Key key}) : super(key: key);

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  int width;
  List<List<int>> board;
  Map<String, int> head;
  Map<String, String> portals;
  bool gameOver;

  @override
  void initState() {
    super.initState();
    restart();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width ~/ 20;
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
      children: board
          .map((e) => Column(
                children: e.map((e) {
                  if (e == head['score']) {
                    return AnimatedHead(width: width);
                  } else if (e == 1) {
                    return AnimatedTail(width: width);
                  } else if (e > 0) {
                    return Container(
                      color: Colors.redAccent,
                      padding: EdgeInsets.all(width / 2 - 1),
                      margin: EdgeInsets.all(1),
                    );
                  } else if (e == -1) {
                    return AnimatedFood(width: width);
                  } else if (e == -2) {
                    return Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Container(
                          color: Colors.black,
                          padding: EdgeInsets.all(width / 2 - 2),
                          margin: EdgeInsets.all(2),
                        ),
                        AnimatedPortal(width: width)
                      ],
                    );
                  } else {
                    return Container(
                      color: Colors.grey.shade900,
                      padding: EdgeInsets.all(width / 2 - 2),
                      margin: EdgeInsets.all(2),
                    );
                  }
                }).toList(),
              ))
          .toList(),
    );
  }

  void restart() {
    LevelData levelData = Provider.of<LevelData>(context, listen: false);
    board = levelData.getLevelData(widget.selectedLevel);
    head = levelData.head;
    portals = levelData.portals ?? {};
    gameOver = false;
    BlocProvider.of<ScoreCubit>(context).restart();
    _newFood();

    startGame();
  }

  void startGame() {
    Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      setState(_updateBoard);
      if (gameOver) {
        timer.cancel();
      }
    });
  }

  void _updateBoard() {
    ActiveDirection activeDirection =
        Provider.of<ActiveDirection>(context, listen: false);
    Map<String, int> delta = activeDirection.getDelta();
    Map<String, int> target = {
      'x': (head['x'] + delta['dx']) % 20,
      'y': (head['y'] + delta['dy']) % 20,
      'score': head['score'],
    };
    int targetCell = board[target['x']][target['y']];
    if (targetCell == 0) {
      _moveHead(target);
      activeDirection.lastDirection = activeDirection.direction;
    } else if (targetCell == -1) {
      head = target;
      head['score']++;
      board[head['x']][head['y']] = head['score'];
      BlocProvider.of<ScoreCubit>(context).increment();
      activeDirection.lastDirection = activeDirection.direction;
      _newFood();
    } else if (targetCell > 0) {
      activeDirection.lastDirection = activeDirection.direction;
      gameOver = true;
      return;
    } else if (targetCell == -2) {
      String portalLoc = target['x'].toString() + ',' + target['y'].toString();
      String portalExit = portals[portalLoc];
      List<int> portalExitCoord =
          portalExit.split(',').map((e) => int.parse(e)).toList();
      target = {
        'x': portalExitCoord[0] + delta['dx'],
        'y': portalExitCoord[1] + delta['dy'],
        'score': head['score']
      };
      _moveHead(target);
      activeDirection.lastDirection = activeDirection.direction;
    }
  }

  void _moveHead(Map<String, int> target) {
    head = target;
    board[target['x']][target['y']] = target['score'] + 1;
    board = board.map((e) => e.map((e) => e > 0 ? e - 1 : e).toList()).toList();
  }

  void _newFood() {
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
