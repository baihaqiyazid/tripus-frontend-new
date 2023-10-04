import 'package:flutter/material.dart';

class AvatarCustom extends StatefulWidget {
  String name;
  double width;
  double height;
  Color color;
  double fontSize;
  double radius;
  Color? backgroundColor;
  AvatarCustom ({super.key, required this.name, required this.width, required this.height, required this.color, required this.fontSize, required this.radius, this.backgroundColor = Colors.blueAccent});

  @override
  State<AvatarCustom> createState() => AvatarCustom_State();
}

class AvatarCustom_State extends State<AvatarCustom> {
  @override
  Widget build(BuildContext context) {

    String getInitials(String fullName) {
      List<String> words = fullName.split(" ");
      String initials = "";

      for (int i = 0; i < words.length && i < 2; i++) {
        String word = words[i];
        if (word.isNotEmpty) {
          initials += word[0].toUpperCase();
        }
      }

      return initials.toUpperCase();
    }

    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: widget.backgroundColor,
      child: Center(
        child: Text(getInitials(widget.name), style: TextStyle(color: widget.color, fontSize: widget.fontSize),
    )));
  }
}
