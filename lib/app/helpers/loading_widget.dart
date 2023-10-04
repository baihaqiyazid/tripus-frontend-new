import "package:flutter/material.dart";

class LoadingWidget extends StatelessWidget {
  Color color;
  LoadingWidget({this.color = Colors.blueAccent, super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(color: Colors.blueAccent, backgroundColor: Colors.transparent,);
  }
}
