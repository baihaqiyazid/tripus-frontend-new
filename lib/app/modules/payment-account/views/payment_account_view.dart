import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../controllers/user_auth_controller.dart';
import '../../../data/static_data.dart';
import '../../../helpers/loading_widget.dart';
import '../../../helpers/theme.dart';
import '../controllers/payment_account_controller.dart';
import '../widget/add_bank_account.dart';
import '../widget/radio_list_widget.dart';

class PaymentAccountView extends StatefulWidget {
  const PaymentAccountView({Key? key}) : super(key: key);

  @override
  State<PaymentAccountView> createState() => _PaymentAccountViewState();
}

class _PaymentAccountViewState extends State<PaymentAccountView> {
  bool isEdit = false;



  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => UserAuthController());
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    List<Map<String, dynamic>> paymentAccount = GetStorage().read('payment_account');

    print(paymentAccount.runtimeType);
    Widget content(String payment_method_id, String number, int id) {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          margin: EdgeInsets.only(bottom: 26),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.white70),
          child: Row(
            children: [
              Image.asset(
                payment_method_id == "BCA"
                    ? 'assets/payment/logo_bca.png'
                    : payment_method_id == "BNI"
                        ? 'assets/payment/logo_bni.png'
                        : 'assets/payment/logo_mandiri.png',
                width: 50,
                height: 50,
              ),
              SizedBox(
                width: 15,
              ),
              Text(number,
                  style: primaryTextStylePlusJakartaSans.copyWith(
                      fontWeight: semibold, fontSize: 16)),
              Spacer(),
              isEdit
                  ? IconButton(
                      onPressed: () async{
                        await Get.find<UserAuthController>().deletePaymentAccount(id);
                        print("start set");
                        setState(() {
                          paymentAccount = StaticData.box.read('payment_account');
                        });
                        print("start set end");
                      },
                      splashRadius: 25,
                      iconSize: 20,
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ))
                  : Container(),
            ],
          ));
    }

    Widget addPayment() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.blue)),
        child: Row(
          children: [
            Text(
              "Add new payment account",
              style: primaryTextStylePlusJakartaSans.copyWith(
                  fontSize: 16, fontWeight: semibold, color: Colors.blue),
            ),
            Spacer(),
            IconButton(
                onPressed: () {
                  Get.bottomSheet(
                    AddPaymentBottomSheet(),
                  );
                },
                splashRadius: 25,
                icon: Icon(
                  Icons.add,
                  color: Colors.blue,
                ))
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Payment Accounts',
                  style: primaryTextStylePlusJakartaSans.copyWith(
                    fontSize: 15,
                    fontWeight: semibold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isEdit = !isEdit;
                    });
                  },
                  child: isEdit
                      ? Icon(
                          Icons.cancel,
                          color: Colors.black,
                        )
                      : Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                )
              ],
            ),
          ),
          centerTitle: false,
        ),
        body: Container(
          margin: EdgeInsets.all(30),
          child: Get.find<UserAuthController>().obx((state) {
            print("len state: ${state.length}" );
            return Column(
              children: [
                state != null
                    ? Column(
                        children: state.map<Widget>((e) {
                          return content(e['payment_method_id'],
                              e['number'].toString(), e['id']);
                        }).toList(),
                      )
                    : Container(),
                addPayment()
              ],
            );
          },
              onLoading: Column(
                children: [
                  paymentAccount != null
                      ? Column(
                    children: paymentAccount.map<Widget>((e) {
                      return content(e['payment_method_id'],
                          e['number'].toString(), e['id']);
                    }).toList(),
                  )
                      : Container(),
                  addPayment()
                ],
              ),
              onEmpty: Column(
                children: [
                  paymentAccount != null
                      ? Column(
                          children: paymentAccount.map<Widget>((e) {
                            return content(e['payment_method_id'],
                                e['number'].toString(), e['id']);
                          }).toList(),
                        )
                      : Container(),
                  addPayment()
                ],
              )),
        ));
  }
}
