import "package:flutter/material.dart";

import "../../../../helpers/theme.dart";

class MaxPersonWidget extends StatefulWidget {
  TextEditingController maxPersonValue;
  MaxPersonWidget({super.key, required this.maxPersonValue});

  @override
  State<MaxPersonWidget> createState() => _MaxPersonWidgetState();
}

class _MaxPersonWidgetState extends State<MaxPersonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Max Person *",
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
              controller: widget.maxPersonValue,
              textAlign: TextAlign.justify,
              keyboardType: TextInputType.number,
              style:
              primaryTextStylePlusJakartaSans.copyWith(fontSize: 12),
              maxLines: 1,
              decoration: InputDecoration.collapsed(
                hintText: "0",
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
