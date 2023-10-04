import "package:flutter/material.dart";
import "package:get/get.dart";

import "../../../../helpers/theme.dart";
import "bank_account_list.dart";
import "category_list.dart";

class PaymentAccount extends StatefulWidget {
  final void Function(String selectedCategory) onHandleChange;
  final void Function(String selectedCategory) onBankCode;

  String paymentAccountValue;
  String bankCodeValue;
  PaymentAccount({super.key, required this.paymentAccountValue, required this.bankCodeValue, required this.onHandleChange, required this.onBankCode});

  @override
  State<PaymentAccount> createState() => _PaymentAccountState();
}

class _PaymentAccountState extends State<PaymentAccount> {

  void handleSelectedCategory(String value) {
    // Do something with the selected category in this class
    setState(() {
      widget.paymentAccountValue = value;
    });

    widget.onHandleChange(value);
    print("Selected Category: ${widget.paymentAccountValue}");
  }

  void handleSelectedBankCode(String value) {
    // Do something with the selected category in this class
    setState(() {
      widget.bankCodeValue = value;
    });

    widget.onBankCode(value);
    print("Selected Category: ${widget.bankCodeValue}");
  }

  Widget button(String name, double opacity) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      child: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(
                vertical: 12), // Set the desired padding values
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(5), // Set the desired border radius
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
              textButtonSecondaryColor.withOpacity(opacity)),
          minimumSize:
          MaterialStateProperty.all<Size>(Size(double.infinity, 0)),
        ),
        child: Text(
          name,
          style: buttonPrimaryTextStyle.copyWith(
              fontSize: 22, fontWeight: semibold),
        ),
      ),
    );
  }

  Widget bottomSheetWidget(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text("Choose Bank Account", style: primaryTextStylePlusJakartaSans.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 18
              ),),
              Spacer(),
              IconButton(
                  onPressed: () => Get.back(),
                  splashRadius: 25,
                  icon: Icon(Icons.keyboard_arrow_up, size: 25, color: textHintColor,))
            ],
          ),
          BankAccountList(onCategorySelected: handleSelectedCategory, selectedValue: widget.paymentAccountValue, onBankCode: handleSelectedBankCode,),
          Spacer(),
          button("Continue", 1)
        ],
      ),
    );
  }

  Widget tripCategory(){
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
            bottomSheetWidget()
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Payment Account *",
              style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 12,
                fontWeight: semibold,
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 5),
                width: Get.size.width * 0.4,
                height: 40,
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: containerPostColor,
                ),
                child: Row(
                  children: [
                    widget.bankCodeValue != '' ?
                    Image.asset(
                      widget.bankCodeValue == "BCA"? 'assets/payment/logo_bca.png' :
                      widget.bankCodeValue == "BNI"? 'assets/payment/logo_bni.png' :
                      'assets/payment/logo_mandiri.png',
                      width: 30,
                      height: 30,
                    ) : Container(),
                    SizedBox(width: 5),
                    Text(widget.paymentAccountValue != "" ? widget.paymentAccountValue : "Choose",
                      style: primaryTextStylePlusJakartaSans.copyWith(
                        fontSize: 12,
                      ),),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_down, size: 25, color: textHintColor,)
                  ],
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return tripCategory();
  }
}
