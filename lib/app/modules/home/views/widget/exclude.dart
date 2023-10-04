import "package:flutter/material.dart";

import "../../../../helpers/theme.dart";

class ExcludeWidget extends StatefulWidget {

  TextEditingController excludeValue;

  ExcludeWidget({super.key, required this.excludeValue});

  @override
  State<ExcludeWidget> createState() => _ExcludeWidgetState();
}

class _ExcludeWidgetState extends State<ExcludeWidget> {
  Widget excludeTrip() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Exclude *",
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
            controller: widget.excludeValue,
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
    return excludeTrip();
  }
}
