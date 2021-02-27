import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../model/widgets/animated_food.dart';
import '../model/widgets/animated_head.dart';
import '../model/widgets/animated_portal.dart';
import '../model/widgets/animated_tail.dart';

part 'cell_state.dart';

class CellCubit extends Cubit<CellState> {
  final int width;
  CellCubit(this.width) : super(EmptyCell(width));
  void setCell(int i, int head) {
    if (i == head) {
      emit(HeadCell(width));
      return;
    } else if (i == 1) {
      emit(TailCell(width));
      return;
    } else if (i > 0) {
      emit(SnakeCell(width));
      return;
    } else if (i == -1) {
      emit(FoodCell(width));
      return;
    } else if (i == -2) {
      emit(PortalCell(width));
      return;
    } else {
      emit(EmptyCell(width));
      return;
    }
  }
}
