import "package:flutter/material.dart";

import "../../../helpers/theme.dart";


class RadioListBank extends StatefulWidget {
  final void Function(String selectedBank) onBankSelected;
  String selectedValue;

  RadioListBank({required this.onBankSelected, required this.selectedValue});

  @override
  State<RadioListBank> createState() => _RadioListBankState();
}

class _RadioListBankState extends State<RadioListBank> {

  _handleRadioValueChanged(String value) {
    setState(() {
      widget.selectedValue = value;
    });
    widget.onBankSelected(value);
  }

  List<Map<String, String>> banks = [
    {"image": "logo_bca.png", "name": "Bank BCA", "code": "BCA"},
    {"image": "logo_bni.png", "name": "Bank BNI", "code": "BNI"},
    {"image": "logo_mandiri.png", "name": "Bank Mandiri", "code": "Mandiri"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: banks.map((e) {
        return RadioListTile(
          title: Row(
            children: [
              Image.asset(
                'assets/payment/${e['image']}',
                width: 50,
                height: 50,
              ),
              SizedBox(width: 15),
              Text(
                e['name']!,
                style: primaryTextStylePlusJakartaSans.copyWith(
                  fontWeight: semibold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          value: e['code'],
          groupValue: widget.selectedValue,
          controlAffinity: ListTileControlAffinity.trailing,
          onChanged: (value) {
            _handleRadioValueChanged(value!);
          },
        );
      }).toList(),
    );
  }
}
