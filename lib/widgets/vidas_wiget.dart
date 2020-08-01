import 'package:flutter/material.dart';

class VidasWidget extends StatefulWidget {
  final int vidas;

  VidasWidget(this.vidas);

  @override
  _VidasWidgetState createState() => _VidasWidgetState();
}

class _VidasWidgetState extends State<VidasWidget> {
  Color color = Colors.red;

  @override
  Widget build(BuildContext context) {
    if (widget.vidas == 1) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.favorite_border,
            color: color,
            size: 30.0,
          ),
          Icon(Icons.favorite_border, color: color, size: 30.0),
          Icon(Icons.favorite, color: color, size: 30.0),
        ],
      );
    } else if (widget.vidas == 2) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.favorite_border, color: color, size: 30.0),
          Icon(Icons.favorite, color: color, size: 30.0),
          Icon(Icons.favorite, color: color, size: 30.0),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.favorite,
            color: color,
            size: 30.0,
          ),
          Icon(Icons.favorite, color: color, size: 30.0),
          Icon(Icons.favorite, color: color, size: 30.0),
        ],
      );
    }
  }
}
