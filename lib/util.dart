import 'package:flutter/material.dart';
import 'package:library_management_app/constants.dart';

double getHeight(BuildContext context) {
  return MediaQuery.of(context).size.height -
      kToolbarHeight -
      MediaQuery.of(context).viewPadding.top -
      kToolbarHeight;
}

double getWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double scaleWidth(BuildContext c, double percentage,
    {bool scaleWithHeight = false}) {
  return (scaleWithHeight ? getHeight(c) : getWidth(c)) * percentage / 100.0;
}

double scaleHeight(BuildContext c, double percentage,
    {bool scaleWithWidth = false}) {
  return (scaleWithWidth ? getWidth(c) : getHeight(c)) * percentage / 100;
}

void showAlertScreen(BuildContext context, String errorMsg) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
            height: scaleHeight(context, alertBoxHeight),
            width: scaleWidth(context, alertBoxWidth),
            child: AlertDialog(
              title: Text(errorMsg),
              actions: <Widget>[
                FloatingActionButton(
                  child: Text("Okay"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
      });
}

void showLoadingScreen(BuildContext context, {msg = "Loading"}) {
  showDialog(
      context: context,
      builder: (ctx) {
        return SizedBox(
            height: scaleHeight(context, alertBoxHeight),
            width: scaleWidth(context, alertBoxWidth),
            child: AlertDialog(
                title: Center(child: Text(msg)),
                content: 
                    SizedBox(
                        height:
                            scaleHeight(context, circularLoadingIndictorRadius),
                        width:
                            scaleHeight(context, circularLoadingIndictorRadius),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ))));
      });
}

void hideLoadingScreen(BuildContext context) {
  Navigator.of(context).pop();
}
