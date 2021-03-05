import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/cubit/score_cubit.dart';
import 'package:snake_game/model/levelData.dart';
import 'package:snake_game/model/widgets/game_board.dart';
import '../model/widgets/animated_food.dart';
import '../model/widgets/animated_head.dart';
import '../model/widgets/animated_portal.dart';
import '../model/widgets/animated_tail.dart';

part 'cell_state.dart';

class CellCubit extends Cubit<CellState> {
  final int width;
  final int coordX;
  final int coordY;
  LevelData levelData;
  GameBoardState gameBoardState;
  CellCubit(
    this.width,
    this.coordX,
    this.coordY,
    this.levelData,
    this.gameBoardState,
  ) : super(EmptyCell(width, coordX, coordY, gameBoardState));
  void setCell(int i, int head) {
    if (i == head) {
      emit(HeadCell(width, coordX, coordY,gameBoardState));
      return;
    } else if (i == 1) {
      emit(TailCell(width, coordX, coordY,gameBoardState));
      return;
    } else if (i > 0) {
      emit(SnakeCell(width, coordX, coordY,gameBoardState));
      return;
    } else if (i == -1) {
      emit(FoodCell(width, coordX, coordY,gameBoardState));
      return;
    } else if (i == -2) {
      List<int> targetCoord = levelData
          .portals[coordX.toString() + ',' + coordY.toString()]
          .split(',')
          .map((e) => int.parse(e))
          .toList();

      emit(PortalCell(width, coordX, coordY, targetCoord[0], targetCoord[1],
          gameBoardState));
      return;
    } else {
      emit(EmptyCell(width, coordX, coordY, this.gameBoardState));
      return;
    }
  }
}
