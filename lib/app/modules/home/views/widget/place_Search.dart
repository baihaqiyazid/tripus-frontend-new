import 'package:flutter/material.dart';
import 'package:mapbox_search/mapbox_search.dart';

import '../../../../helpers/theme.dart';

class LocationItem extends StatefulWidget {
  final MapBoxPlace place;
  final TextEditingController locationController;
  final Function() onClearPlaces;

  LocationItem({
    required this.place,
    required this.locationController,
    required this.onClearPlaces
  });

  @override
  State<LocationItem> createState() => _LocationItemState();
}

class _LocationItemState extends State<LocationItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.locationController.text = widget.place.placeName!;
        widget.onClearPlaces();
        FocusScope.of(context).unfocus();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.place.text!),
          Text(
            widget.place.placeName!,
            style: primaryTextStylePlusJakartaSans.copyWith(
              color: Color(0xffA1A1A1),
              fontSize: 12,
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}