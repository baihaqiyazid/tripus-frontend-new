import "package:flutter/material.dart";

import "../../../../helpers/theme.dart";

class IncludeWidget extends StatefulWidget {

  TextEditingController includeValue;

  IncludeWidget({super.key, required this.includeValue});

  @override
  State<IncludeWidget> createState() => _IncludeWidgetState();
}

class _IncludeWidgetState extends State<IncludeWidget> {

  Widget includeTrip() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Include *",
          style: primaryTextStylePlusJakartaSans.copyWith(
              fontSize: 12, fontWeight: semibold),
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
          width: double.infinity,
          height: 100,
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: containerPostColor,
          ),
          child: TextFormField(
            textAlign: TextAlign.justify,
            style: primaryTextStylePlusJakartaSans.copyWith(fontSize: 12),
            maxLines: 6,
            controller: widget.includeValue,
            decoration: InputDecoration.collapsed(
              hintText: "Type Here...",
              hintStyle: primaryTextStylePlusJakartaSans.copyWith(
                  color: Color(0xffA1A1A1), fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return includeTrip();
  }
}
