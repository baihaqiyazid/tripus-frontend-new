import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:get_storage/get_storage.dart";

import "../../../../helpers/theme.dart";

class BankAccountList extends StatefulWidget {
  final void Function(String selectedCategory) onCategorySelected;
  final void Function(String bankCode) onBankCode;
  String selectedValue;

  BankAccountList({required this.onCategorySelected, required this.selectedValue, required this.onBankCode});

  @override
  State<BankAccountList> createState() => _BankAccountListState();
}

class _BankAccountListState extends State<BankAccountList> {

  _handleCategoryValueChanged(List<String> value) {
    setState(() {
      widget.selectedValue = value[1];
    });
    widget.onCategorySelected(value[1]);
    widget.onBankCode(value[0]);
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> payment = GetStorage().read('payment_account');
    print(payment);
    return Column(
      children: payment.map((e) {
        return RadioListTile(
          title: Row(
            children: [
              Image.asset(
                e['payment_method_id'] == "BCA"? 'assets/payment/logo_bca.png' :
                e['payment_method_id'] == "BNI"? 'assets/payment/logo_bni.png' :
                'assets/payment/logo_mandiri.png',
                width: 50,
                height: 50,
              ),
              SizedBox(width: 15),
              Text(
                e['number'].toString(),
                style: primaryTextStylePlusJakartaSans.copyWith(
                  fontWeight: semibold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          value: e['number'].toString(),
          groupValue: widget.selectedValue,
          controlAffinity: ListTileControlAffinity.trailing,
          onChanged: (value) {
            _handleCategoryValueChanged([e["payment_method_id"],value!]);
          },
        );
      }).toList(),
    );
  }
}
