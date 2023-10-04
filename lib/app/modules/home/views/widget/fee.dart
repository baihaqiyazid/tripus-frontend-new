import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import "../../../../helpers/theme.dart";

class FeeWidget extends StatefulWidget {
  TextEditingController feeValue;

  FeeWidget({super.key, required this.feeValue});

  @override
  State<FeeWidget> createState() => _FeeWidgetState();
}

class _FeeWidgetState extends State<FeeWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Fee one person *",
              style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 12,
                fontWeight: semibold,
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 5),
                height: 40,
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: containerPostColor,
                ),
                child: TextFormField(
                  controller: widget.feeValue,
                  inputFormatters: [
                    CurrencyTextInputFormatter(
                      locale: 'id',
                      decimalDigits: 0,
                      symbol: 'Rp ',
                    ),
                  ],
                  textAlign: TextAlign.justify,
                  style: primaryTextStylePlusJakartaSans.copyWith(fontSize: 12),
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  decoration: InputDecoration.collapsed(
                    hintText: "Rp. 0",
                    hintStyle: primaryTextStylePlusJakartaSans.copyWith(
                      color: Color(0xffA1A1A1),
                      fontSize: 12,
                    ),
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }
}
