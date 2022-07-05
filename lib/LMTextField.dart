import 'package:flutter/material.dart';
import 'util.dart';

class LMTextField extends StatelessWidget {
  BuildContext context;
  String? label;
  String? hint;
  double height;
  double width;
  double posX;
  double posY;
  void Function(String) onTextChange;
  bool obscure;

  LMTextField(this.context, this.height, this.width, this.posX, this.posY,
      this.onTextChange,
      {this.label, this.hint, this.obscure = false});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: scaleHeight(context, posY),
      left: scaleWidth(context, posX),
      height: scaleHeight(context, height),
      width: scaleWidth(context, width),
      child: TextField(
        obscureText: obscure,
        onChanged: onTextChange,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(1))),
          labelText: label != null ? (label as String) : "",
          hintText: hint != null ? (hint as String) : "",
        ),
      ),
    );
  }
}
