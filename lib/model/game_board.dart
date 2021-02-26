import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:snake_game/cubit/score_cubit.dart';

import 'active_direction.dart';
import 'animated_food.dart';

class GameBoard extends StatefulWidget {
  GameBoard({Key key}) : super(key: key);

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  int width;
  List<List<int>> board;
  var head;
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
                    return Container(
                      color: Colors.red,
                      padding: EdgeInsets.all(width / 2 - 1),
                      margin: EdgeInsets.all(1),
                    );
                  } else if (e > 0) {
                    return Container(
                      color: Colors.redAccent,
                      padding: EdgeInsets.all(width / 2 - 1),
                      margin: EdgeInsets.all(1),
                    );
                  } else if (e == -1) {
                    return AnimatedFood(width: width);
                  } else {
                    return Container(
                      color: Colors.grey.shade800,
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
    board = List.empty(growable: true);
    for (var i = 0; i < 20; i++) {
      board.add(List.filled(20, 0));
    }
    board[5][5] = 1;
    head = {'x': 5, 'y': 5, 'score': 1};
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

    if (targetCell == -1) {
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
    } else {
      head = target;
      board[target['x']][target['y']] = target['score'] + 1;
      board =
          board.map((e) => e.map((e) => e > 0 ? e - 1 : e).toList()).toList();

      activeDirection.lastDirection = activeDirection.direction;
    }
  }

  void _newFood() {
    bool foodPlaced = false;
    int newFoodLocation = Random().nextInt(400 - head['score']);
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
