import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedPortal extends StatefulWidget {
  const AnimatedPortal({
    Key key,
    @required this.width,
  }) : super(key: key);

  final int width;

  @override
  _AnimatedPortalState createState() => _AnimatedPortalState();
}

class _AnimatedPortalState extends State<AnimatedPortal>
    with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController _controller2;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _controller2 =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _controller.addListener(() {
      setState(() {});
    });

    _controller.repeat();
    _controller2.forward();
    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller2.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller2.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: math.pi * _controller.value,
      child: Stack(alignment: AlignmentDirectional.center, children: [
        Container(
          color: Colors.blue.shade900,
            padding: EdgeInsets.all(2 * widget.width / 5 -
                _controller2.value * (1 * widget.width / 10)),
        ),
        Transform.rotate(
          angle: math.pi / 4,
          child: Container(
            color: Colors.purple.shade700,
            padding: EdgeInsets.all(2 * widget.width / 5 -
                _controller2.value * (1 * widget.width / 5)),
          ),
        ),
      ]),
    );
  }
}
