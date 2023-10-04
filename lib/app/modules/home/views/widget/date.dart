import "package:calendar_date_picker2/calendar_date_picker2.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

import "../../../../helpers/theme.dart";

class DateWidget extends StatefulWidget {
  TextEditingController dateStart;
  TextEditingController dateEnd;
  DateWidget({super.key, required this.dateStart, required this.dateEnd});

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  List<DateTime?> _dates = [];
  List<DateTime?> _datesEnd = [];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date *',
                style: primaryTextStylePlusJakartaSans.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.defaultDialog(
                      title: 'Select Date',
                      content: Container(
                        width: Get.size.width,
                        child: CalendarDatePicker2WithActionButtons(
                          onCancelTapped: () {
                            Get.back();
                          },
                          onOkTapped: () {
                            if (_dates.length > 0) {
                              print("date ${_dates.first}");
                            }
                            Get.back();
                          },
                          config: CalendarDatePicker2WithActionButtonsConfig(
                            firstDate: DateTime.now()
                          ),
                          value: _dates,
                          onValueChanged: (dates) {
                            setState(() {
                              _dates = dates;
                              widget.dateStart.text = _dates.first.toString();
                            });
                          },
                        ),
                      ));
                },
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  height: 40,
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: containerPostColor,
                  ),
                  child: TextFormField(
                    enabled: false,
                    style: primaryTextStylePlusJakartaSans.copyWith(
                      fontSize: 12,
                    ),
                    decoration: InputDecoration.collapsed(
                        hintText: _dates.length > 0
                            ? _dates.first.toString().substring(0, 10)
                            : "Choose Date",
                        hintStyle: _dates.length > 0
                            ? primaryTextStylePlusJakartaSans.copyWith(
                            fontSize: 12)
                            : primaryTextStylePlusJakartaSans.copyWith(
                            fontSize: 12, color: textHintColor)),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Center(child: Text('to')),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  if(_dates.length > 0){
                    Get.defaultDialog(
                        title: 'Select Date',
                        content: Container(
                          width: Get.size.width,
                          child: CalendarDatePicker2WithActionButtons(
                            onCancelTapped: () {
                              Get.back();
                            },
                            onOkTapped: () {
                              if (_datesEnd.length > 0) {
                                print("date ${_datesEnd.first}");
                              }
                              Get.back();
                            },
                            config: CalendarDatePicker2WithActionButtonsConfig(
                              firstDate: _dates.first
                            ),
                            value: _datesEnd,
                            onValueChanged: (dates) {
                              setState(() {
                                _datesEnd = dates;
                                widget.dateEnd.text = _datesEnd.first.toString();
                              });
                            },
                          ),
                        ));
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  height: 40,
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: _dates.length > 0 ? containerPostColor : textSecondaryColor,
                  ),
                  child: TextFormField(
                    enabled: false,
                    style: primaryTextStylePlusJakartaSans.copyWith(
                      fontSize: 12,
                    ),
                    decoration: InputDecoration.collapsed(
                        hintText: _datesEnd.length > 0
                            ? _datesEnd.first.toString().substring(0, 10)
                            : "Choose Date",
                        hintStyle: _datesEnd.length > 0
                            ? primaryTextStylePlusJakartaSans.copyWith(
                            fontSize: 12,)
                            : primaryTextStylePlusJakartaSans.copyWith(
                            fontSize: 12, color: textHintColor)),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ],
          ),

      ),
    );
  }
}
