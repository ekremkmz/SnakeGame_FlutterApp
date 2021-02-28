import 'dart:async';

import 'package:bloc/bloc.dart';

class Time {
  Time(this.minute,this.second,  this.millisecond);
  int millisecond;
  int second;
  int minute;
}

class TimerCubit extends Cubit<Time> {
  Timer _timer;
  int time = 0;

  TimerCubit() : super(Time(0, 0, 0));

  void resetTimer() {
    time = 0;
    emit(Time(0, 0, 0));
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      time++;
      emit(Time(time ~/ 3600, (time ~/ 60) % 60, time % 60));
    });
  }

  void stopTimer() {
    if (_timer.isActive) _timer.cancel();
  }
}
