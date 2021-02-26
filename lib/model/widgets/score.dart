import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/cubit/score_cubit.dart';

class Score extends StatefulWidget {
  @override
  _ScoreState createState() => _ScoreState();
}

class _ScoreState extends State<Score> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
      lowerBound: 0,
      upperBound: 20,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      child: ListTile(
        leading: Image.asset("assets/icons/crown.png"),
        title: Text(
          "Score:",
          style: TextStyle(fontSize: 32),
        ),
        trailing: BlocBuilder<ScoreCubit, int>(
          builder: (context, state) {
            _controller.reset();
            _controller.forward();
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Text(
                  state.toString(),
                  style: TextStyle(fontSize: 52 - _controller.value),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
