import "package:flutter/material.dart";

import "../../../helpers/theme.dart";

class SelectedBank extends StatefulWidget {
  String selectedBank;
  SelectedBank({required this.selectedBank, super.key});

  @override
  State<SelectedBank> createState() => _SelectedBankState();
}

class _SelectedBankState extends State<SelectedBank> {

  @override
  Widget build(BuildContext context) {
    print(widget.selectedBank);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Bank Account",
            style: primaryTextStylePlusJakartaSans.copyWith(
                fontWeight: semibold, fontSize: 14),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: textHintColor)),
            child: Row(
              children: [
                widget.selectedBank != ""?
                Row(
                  children: [
                    Image.asset(
                      widget.selectedBank == 'BCA'? 'assets/payment/logo_bca.png' :
                      widget.selectedBank == 'BNI'? 'assets/payment/logo_bni.png' :
                      'assets/payment/logo_mandiri.png',
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(width: 15),
                    Text(
                      widget.selectedBank,
                      style: primaryTextStylePlusJakartaSans.copyWith(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ):
                Text(
                  "Choose Bank Account",
                  style: primaryTextStylePlusJakartaSans.copyWith(
                      fontSize: 14, color: textHintColor),
                ),
                Spacer(),
                Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: textHintColor,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}