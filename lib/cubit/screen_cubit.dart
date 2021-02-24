import 'package:bloc/bloc.dart';

class ScreenCubit extends Cubit<ScreenState> {
  ScreenCubit() : super(ScreenState.startGame);
  void start() {
    emit(ScreenState.gameBoard);
  }
}

enum ScreenState { startGame, gameBoard }
