part of 'cell_cubit.dart';

@immutable
abstract class CellState extends StatelessWidget {
  final int width;

  const CellState( this.width,{Key key,}) : super(key: key);
}

class EmptyCell extends CellState {
  EmptyCell(width) : super(width);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade900,
      padding: EdgeInsets.all(width / 2 - 2),
      margin: EdgeInsets.all(2),
    );
  }
}

class HeadCell extends CellState {
  HeadCell(width) : super(width);

  @override
  Widget build(BuildContext context) {
    return AnimatedHead(width: width);
  }
}

class TailCell extends CellState {
  TailCell(width) : super(width);

  @override
  Widget build(BuildContext context) {
    return AnimatedTail(width: width);
  }
}

class PortalCell extends CellState {
  PortalCell(width) : super(width);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          color: Colors.black,
          padding: EdgeInsets.all(width / 2 - 2),
          margin: EdgeInsets.all(2),
        ),
        AnimatedPortal(width: width)
      ],
    );
  }
}

class SnakeCell extends CellState {
  SnakeCell(width) : super(width);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      padding: EdgeInsets.all(width / 2 - 1),
      margin: EdgeInsets.all(1),
    );
  }
}

class FoodCell extends CellState{
  FoodCell(width) : super(width);

  @override
  Widget build(BuildContext context) {
    return AnimatedFood(width: width);
  }
  
}