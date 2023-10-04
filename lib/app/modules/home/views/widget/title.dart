import "package:flutter/material.dart";

import '../../../../helpers/theme.dart';

class TitleWidget extends StatefulWidget {
  TextEditingController titleValue;

  TitleWidget({super.key, required this.titleValue});

  @override
  State<TitleWidget> createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Title *",
            style: primaryTextStylePlusJakartaSans.copyWith(
              fontSize: 12,
              fontWeight: semibold,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            width: double.infinity,
            height: 40,
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: containerPostColor,
            ),
            child: TextFormField(
              controller: widget.titleValue,
              textAlign: TextAlign.justify,
              style:
              primaryTextStylePlusJakartaSans.copyWith(fontSize: 12),
              maxLines: 1,
              decoration: InputDecoration.collapsed(
                hintText: "Type Here...",
                hintStyle: primaryTextStylePlusJakartaSans.copyWith(
                  color: Color(0xffA1A1A1),
                  fontSize: 12,
                ),
              ),
            ),)
        ],
      ),
    );
  }
}
