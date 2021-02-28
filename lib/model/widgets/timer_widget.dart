import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/cubit/timer_cubit.dart';

class TimerWidget extends StatefulWidget {
  final int width;
  const TimerWidget(this.width, {Key key}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          ' ',
          style: TextStyle(
              fontFamily: 'SevenSegment',
              color: Colors.white,
              fontSize: widget.width.toDouble()),
        ),
        Expanded(
          child: Row(
            children: [
              BlocBuilder<TimerCubit, Time>(
                  buildWhen: (prev, cur) => prev.minute != cur.minute,
                  builder: (context, state) {
                    return Expanded(
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          (state.minute ~/ 10).toString(),
                          style: TextStyle(
                              fontFamily: 'SevenSegment',
                              color: Colors.white,
                              fontSize: widget.width.toDouble()),
                        ),
                      ),
                    );
                  }),
              BlocBuilder<TimerCubit, Time>(
                  buildWhen: (prev, cur) => prev.minute != cur.minute,
                  builder: (context, state) {
                    return Expanded(
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          (state.minute % 10).toString(),
                          style: TextStyle(
                              fontFamily: 'SevenSegment',
                              color: Colors.white,
                              fontSize: widget.width.toDouble()),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
        Text(
          ':',
          style: TextStyle(
              fontFamily: 'SevenSegment',
              color: Colors.white,
              fontSize: widget.width.toDouble()),
        ),
        Expanded(
          child: Row(
            children: [
              BlocBuilder<TimerCubit, Time>(
                  buildWhen: (prev, cur) => prev.second != cur.second,
                  builder: (context, state) {
                    return Expanded(
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          (state.second ~/ 10).toString(),
                          style: TextStyle(
                              fontFamily: 'SevenSegment',
                              color: Colors.white,
                              fontSize: widget.width.toDouble()),
                        ),
                      ),
                    );
                  }),
              BlocBuilder<TimerCubit, Time>(
                  buildWhen: (prev, cur) => prev.second != cur.second,
                  builder: (context, state) {
                    return Expanded(
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          (state.second % 10).toString(),
                          style: TextStyle(
                              fontFamily: 'SevenSegment',
                              color: Colors.white,
                              fontSize: widget.width.toDouble()),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
        Text(
          ':',
          style: TextStyle(
              fontFamily: 'SevenSegment',
              color: Colors.white,
              fontSize: widget.width.toDouble()),
        ),
        Expanded(
          child: Row(
            children: [
              BlocBuilder<TimerCubit, Time>(builder: (context, state) {
                return Expanded(
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      (state.millisecond ~/ 10).toString(),
                      style: TextStyle(
                          fontFamily: 'SevenSegment',
                          color: Colors.white,
                          fontSize: widget.width.toDouble()),
                    ),
                  ),
                );
              }),
              BlocBuilder<TimerCubit, Time>(builder: (context, state) {
                return Expanded(
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      (state.millisecond % 10).toString(),
                      style: TextStyle(
                          fontFamily: 'SevenSegment',
                          color: Colors.white,
                          fontSize: widget.width.toDouble()),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        Text(
          ' ',
          style: TextStyle(
              fontFamily: 'SevenSegment',
              color: Colors.white,
              fontSize: widget.width.toDouble()),
        ),
      ],
    );
  }
}
