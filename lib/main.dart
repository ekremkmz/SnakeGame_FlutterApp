import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:snake_game/cubit/score_cubit.dart';

import 'cubit/screen_cubit.dart';
import 'model/active_direction.dart';
import 'model/widgets/game.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ScreenCubit>(create: (context) => ScreenCubit()),
        BlocProvider<ScoreCubit>(create: (context) => ScoreCubit()),
      ],
      child: MultiProvider(
        providers: [
          Provider<ActiveDirection>(create: (context) => ActiveDirection())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SafeArea(
            child: Scaffold(
              body: Game(),
            ),
          ),
        ),
      ),
    );
  }
}
