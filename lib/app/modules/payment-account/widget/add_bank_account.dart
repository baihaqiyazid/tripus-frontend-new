import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:get/get.dart";
import "package:tripusfrontend/app/modules/payment-account/widget/radio_list_widget.dart";
import "package:tripusfrontend/app/modules/payment-account/widget/selected_bank.dart";

import "../../../controllers/user_auth_controller.dart";
import "../../../helpers/theme.dart";

class AddPaymentBottomSheet extends StatefulWidget {
  const AddPaymentBottomSheet({super.key});

  @override
  State<AddPaymentBottomSheet> createState() => _AddPaymentBottomSheetState();
}

class _AddPaymentBottomSheetState extends State<AddPaymentBottomSheet> {
  String selectedBank = "";
  bool isAddedBankAccount = false;
  bool isAddedAccountNumber = false;
  TextEditingController accountNumberController = TextEditingController(text: '');

  @override
  void initState(){
    super.initState();
    Get.lazyPut(() => UserAuthController());
  }

  @override
  Widget build(BuildContext context) {
    void _handleBankSelected(String selectedBank) {
      print(selectedBank);
      print(this.isAddedBankAccount);
      setState(() {
        this.selectedBank = selectedBank;
        this.isAddedBankAccount = !this.isAddedBankAccount;
      });
    }

    handlePostPayment() async{
      print("START");

      print(selectedBank);
      print(accountNumberController.text);

      await Get.find<UserAuthController>().addPaymentAccount(selectedBank, accountNumberController.text);
      Get.back();
    }

    handleButtonAddBank(){
      Get.back();
    }

    Widget headerBottomSheet(String name, Widget icon) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: Get.size.width * 0.12),
              child: Text(
                name,
                style: primaryTextStylePlusJakartaSans.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () => Get.back(),
              iconSize: 20,
              icon: icon,
            )
          ],
        ),
      );
    }

    Widget button(String name, double opacity, void function()) {
      return Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: ElevatedButton(
          onPressed: () {
            function();
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

    Widget bankAccountBottomSheet() {
      return GestureDetector(
          onTap: () {
            Get.bottomSheet(
              Container(
                height: Get.size.height * 0.45,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
                    children: [
                      headerBottomSheet("Choose Bank Account", Icon(Icons.keyboard_arrow_up, color: textHintColor, size: 30,)),
                      SizedBox(height: 23),
                      RadioListBank(onBankSelected: _handleBankSelected, selectedValue: selectedBank),
                      SizedBox(height: 23),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: button('Continue', 1, handleButtonAddBank),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          child: SelectedBank(selectedBank: selectedBank,)
      );
    }

    Widget accountNumberBottomSheet() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Account Number",
              style: primaryTextStylePlusJakartaSans.copyWith(
                  fontWeight: semibold, fontSize: 14),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: textHintColor)),
              child: TextFormField(
                onChanged: (_){
                  print(this.isAddedAccountNumber);
                  setState(() {
                    this.isAddedAccountNumber = true;
                  });
                },
                controller: accountNumberController,
                keyboardType: TextInputType.number,
                style: primaryTextStylePlusJakartaSans.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration.collapsed(
                    hintText: "1234567890121234",
                    hintStyle: primaryTextStylePlusJakartaSans.copyWith(
                        fontSize: 14, color: textHintColor)),
                textAlign: TextAlign.start,
              ),
            )
          ],
        ),
      );
    }

    return Container(
      height: Get.size.height * 0.45,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      child: SingleChildScrollView(
        child: Column(
          children: [
            headerBottomSheet("Add new payment account", SvgPicture.asset('assets/icon_close.svg')),
            SizedBox(height: 23),
            bankAccountBottomSheet(),
            SizedBox(height: 23),
            accountNumberBottomSheet(),
            SizedBox(height: 50),
            this.isAddedAccountNumber && this.accountNumberController.text != '' ?
            button('Add', 1, handlePostPayment) : button('Add', 0.3, (){}),
          ],
        ),
      ),
    );
  }
}