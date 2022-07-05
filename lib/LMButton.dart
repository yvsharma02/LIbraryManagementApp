import 'package:flutter/material.dart';
import 'util.dart';

int _nextHeroTag = 0;

/*
Widget LMButton(BuildContext context, double height, double width, double x,
    double y, void Function() onPress,
    {String? label = null, Icon? icon = null}) {
  return Positioned(
      top: getHeight(context, x),t
      left: getWidth(context, y),
      child: SizedBox(
          height: getHeight(context, getHeight(context, height)),
          width: getWidth(context, getWidth(context, width)),
          child: FloatingActionButton.extended(
              onPressed: onPress,
              label: label != null ? Text(label as String) : Text(""),
              icon: icon)));
}
*/

class LMButton extends StatelessWidget {
  final BuildContext context;
  final double x;
  final double y;
  final double height;
  final double width;
  final String? tag;
  final String? label;
  final void Function() onPress;
  final Icon? icon;

  LMButton(this.context, this.height, this.width, this.x, this.y, this.onPress,
      {this.label = null, this.icon = null, this.tag = null});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: scaleWidth(context, x),
      top: scaleHeight(context, y),
      child: Column(children: [
        SizedBox(
            height: scaleHeight(context, height),
            width: scaleWidth(context, width),
            child: FloatingActionButton.extended(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              heroTag: tag != null
                  ? tag
                  : ("LMButtonHT" + (_nextHeroTag++).toString()),
              onPressed: onPress,
              icon: icon,
              label: Text(label == null ? "" : (label as String)),
            )),
        /*
        if (label != null)
          Padding(
              child: Text(label as String),
              padding: EdgeInsets.fromLTRB(0, scaleHeight(context, 1), 0, 0)),*/
      ]),
    );
  }
}
