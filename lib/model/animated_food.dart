import 'package:flutter/material.dart';

class AnimatedFood extends StatefulWidget {
  const AnimatedFood({
    Key key,
    @required this.width,
  }) : super(key: key);

  final int width;

  @override
  _AnimatedFoodState createState() => _AnimatedFoodState();
}

class _AnimatedFoodState extends State<AnimatedFood>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      padding: EdgeInsets.all((widget.width / 2) * (1 - _controller.value)),
      margin: EdgeInsets.all((widget.width / 2) * _controller.value),
    );
  }
}
