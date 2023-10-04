import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../controllers/user_auth_controller.dart';
import '../../../helpers/loading_widget.dart';
import '../../../helpers/theme.dart';
import '../controllers/verify_controller.dart';

class VerifyView extends GetView<VerifyController> {
  VerifyView({Key? key}) : super(key: key);

  final FocusNode otp1Focus = FocusNode();
  final FocusNode otp2Focus = FocusNode();
  final FocusNode otp3Focus = FocusNode();
  final FocusNode otp4Focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Container(
        margin: const EdgeInsets.only(bottom: 166, left: 10),
        child: Row(children: [
          IconButton(
              onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
          Text(
            "OTP Verification",
            style: primaryTextStyle.copyWith(
                fontSize: 18, fontWeight: FontWeight.bold),
          )
        ]),
      );
    }

    Widget headerInput() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "OTP",
              style: buttonSecondaryTextStyle.copyWith(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "We have send OTP to your email, check your email message",
              style: secondaryTextStyle,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 25),
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      color: Color(0xffE7E7E7),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: TextFormField(
                      controller: controller.otp1,
                      style: primaryTextStyle,
                      decoration: InputDecoration.collapsed(
                          hintText: "",
                          hintStyle: hintTextStyle.copyWith(
                            fontSize: 20,
                          )),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      focusNode: otp1Focus,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          otp1Focus.unfocus();
                          otp1Focus.previousFocus();
                        } else if (value.length == 1) {
                          otp1Focus.unfocus();
                          otp2Focus.requestFocus();
                        }
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 25),
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      color: Color(0xffE7E7E7),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: TextFormField(
                      controller: controller.otp2,
                      style: primaryTextStyle,
                      decoration: InputDecoration.collapsed(
                          hintText: "",
                          hintStyle: hintTextStyle.copyWith(
                            fontSize: 20,
                          )),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      focusNode: otp2Focus,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          otp1Focus.previousFocus();
                        } else if (value.length == 1) {
                          otp2Focus.unfocus();
                          otp3Focus.requestFocus();
                        }
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 25),
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      color: Color(0xffE7E7E7),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: TextFormField(
                      controller: controller.otp3,
                      style: primaryTextStyle,
                      decoration: InputDecoration.collapsed(
                          hintText: "",
                          hintStyle: hintTextStyle.copyWith(
                            fontSize: 20,
                          )),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      focusNode: otp3Focus,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          otp2Focus.previousFocus();
                        } else if (value.length == 1) {
                          otp3Focus.unfocus();
                          otp4Focus.requestFocus();
                        }
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      color: Color(0xffE7E7E7),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: TextFormField(
                      controller: controller.otp4,
                      style: primaryTextStyle,
                      decoration: InputDecoration.collapsed(
                          hintText: "",
                          hintStyle: hintTextStyle.copyWith(
                            fontSize: 20,
                          )),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      focusNode: otp4Focus,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          otp3Focus.previousFocus();
                        } else if (value.length == 1) {
                          otp4Focus.unfocus();
                        }
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    Widget footer() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Didn’t receive a OTP?",
              style: secondaryTextStyle.copyWith(fontSize: 14)),
          TextButton(
            onPressed: () {},
            child: Text("Resend OTP",
                style: buttonSecondaryTextStyle.copyWith(fontSize: 14)),
          )
        ],
      );
    }

    Widget buttonSend() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
        child: ElevatedButton(
          onPressed: () {
            String otp = controller.otp1.text +
                controller.otp2.text +
                controller.otp3.text +
                controller.otp4.text;
            Get.find<UserAuthController>().verify(otp, Get.arguments);

          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(
                  vertical: 12), // Set the desired padding values
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(17), // Set the desired border radius
              ),
            ),
            backgroundColor:
                MaterialStateProperty.all<Color>(textButtonSecondaryColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                      "Send Verification",
                      style: buttonPrimaryTextStyle.copyWith(
                          fontSize: 22, fontWeight: semibold),
              ),
              const SizedBox(
                width: 12,
              ),
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
          child: Container(
        child: Column(children: [
          header(),
          headerInput(),
          footer(),
          GetBuilder<UserAuthController>(
              builder: (UserAuthController){
                if(UserAuthController.status.isLoading){
                  return Center(child: LoadingWidget());
                }else{
                  return buttonSend();
                }
              }
          ),
        ]),
      )),
    );
  }
}

// return controller.obx((state) {
// return body();
// },
// onLoading: Center(
// child: LoadingWidget(),
// ),
// onError: (error) => body(),
// onEmpty: body());
