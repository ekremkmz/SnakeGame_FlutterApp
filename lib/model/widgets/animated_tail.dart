import 'package:flutter/material.dart';

class AnimatedTail extends StatefulWidget {
  const AnimatedTail({
    Key key,
    @required this.width,
  }) : super(key: key);

  final int width;

  @override
  _AnimatedTailState createState() => _AnimatedTailState();
}

class _AnimatedTailState extends State<AnimatedTail>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);
    _controller.addListener(() {
      setState(() {});
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
    return Stack(
      children: [
        Container(
          color: Colors.grey.shade900,
          padding: EdgeInsets.all(widget.width / 2 - 1),
          margin: EdgeInsets.all(1),
        ),
        Container(
          color: Colors.redAccent.withOpacity(1 - _controller.value),
          padding: EdgeInsets.all(widget.width / 2 - 1),
          margin: EdgeInsets.all(1),
        ),
      ],
    );
  }
}
