import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_game/model/active_direction.dart';

class AnimatedHead extends StatefulWidget {
  const AnimatedHead({
    Key key,
    @required this.width,
  }) : super(key: key);

  final int width;

  @override
  _AnimatedHeadState createState() => _AnimatedHeadState();
}

class _AnimatedHeadState extends State<AnimatedHead>
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
    return Stack(alignment: AlignmentDirectional.center, children: [
      Container(
        color: Colors.grey.shade900,
        padding: EdgeInsets.all(widget.width / 2 - 1),
        margin: EdgeInsets.all(1),
      ),
      _drawWithDirection(Provider.of<ActiveDirection>(context).direction)
    ]);
  }

  Widget _drawWithDirection(Direction direction) {
    double padding = (widget.width / 2 - 1) * _controller.value;
    double margin = widget.width / 2 - padding;
    switch (direction) {
      case Direction.up:
        return Container(
          color: Colors.red.shade800,
          padding: EdgeInsets.fromLTRB(
            widget.width / 2 - 1,
            padding,
            widget.width / 2 - 1,
            widget.width / 2 - 1,
          ),
          margin: EdgeInsets.fromLTRB(
            1,
            margin,
            1,
            1,
          ),
        );
      case Direction.down:
        return Container(
          color: Colors.red.shade800,
          padding: EdgeInsets.fromLTRB(
            widget.width / 2 - 1,
            widget.width / 2 - 1,
            widget.width / 2 - 1,
            padding,
          ),
          margin: EdgeInsets.fromLTRB(
            1,
            1,
            1,
            margin,
          ),
        );
      case Direction.right:
        return Container(
          color: Colors.red.shade800,
          padding: EdgeInsets.fromLTRB(
            widget.width / 2 - 1,
            widget.width / 2 - 1,
            padding,
            widget.width / 2 - 1,
          ),
          margin: EdgeInsets.fromLTRB(
            1,
            1,
            margin,
            1,
          ),
        );
      case Direction.left:
      default:
        return Container(
          color: Colors.red.shade800,
          padding: EdgeInsets.fromLTRB(
            padding,
            widget.width / 2 - 1,
            widget.width / 2 - 1,
            widget.width / 2 - 1,
          ),
          margin: EdgeInsets.fromLTRB(
            margin,
            1,
            1,
            1,
          ),
        );
    }
  }
}
