import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tripusfrontend/app/controllers/user_auth_controller.dart';
import 'package:tripusfrontend/app/modules/landing/views/landing_signup_view.dart';

import '../../../helpers/loading_widget.dart';
import '../../../helpers/theme.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget emailInput() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            border: Border.all(color: textSecondaryColor),
            borderRadius: BorderRadius.circular(9)),
        child: TextFormField(
          controller: controller.email,
          style: primaryTextStyle,
          decoration: InputDecoration.collapsed(
              hintText: "Email",
              hintStyle: hintTextStyle.copyWith(
                fontSize: 14,
              )),
          textAlign: TextAlign.start,
        ),
      );
    }

    Widget passwordInput() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            border: Border.all(color: textSecondaryColor),
            borderRadius: BorderRadius.circular(9)),
        child: TextFormField(
          controller: controller.password,
          style: primaryTextStyle,
          obscureText: true,
          decoration: InputDecoration.collapsed(
              hintText: "password",
              hintStyle: hintTextStyle.copyWith(
                fontSize: 14,
              )),
          textAlign: TextAlign.start,
        ),
      );
    }

    Widget buttonLogin() {
      return Container(
        margin: EdgeInsets.only(top: 16, left: 30, right: 30),
        child: ElevatedButton(
          onPressed: () {
            Get.find<UserAuthController>().login(controller.email.text, controller.password.text);
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
                "Login",
                style: buttonPrimaryTextStyle.copyWith(
                    fontSize: 22, fontWeight: semibold),
              ),
              SizedBox(
                width: 12,
              ),
              Icon(
                Icons.arrow_forward_sharp,
                color: Colors.white,
              )
            ],
          ),
        ),
      );
    }

    Widget footer() {
      return Container(
          margin: EdgeInsets.only(left: 30, top: 16, right: 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Forgot Password",
                      style: secondaryTextStyle.copyWith(fontSize: 14)),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      print("di tap");
                    },
                    child: Text(
                      "Get New",
                      style: buttonSecondaryTextStyle.copyWith(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("You don't have an account?",
                      style: secondaryTextStyle.copyWith(fontSize: 14)),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Get.to(LandingSignupView());
                    },
                    child: Text(
                      "Sign Up",
                      style: buttonSecondaryTextStyle.copyWith(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ));
    }

    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            child: SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: Container(
                margin: EdgeInsets.only(top: 53),
                child: SingleChildScrollView(
                  child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: Image.asset('assets/walking.png')),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                "Login",
                                style: primaryTextStylePlusJakartaSans.copyWith(
                                    fontWeight: FontWeight.w800, fontSize: 32),
                              )),
                          emailInput(),
                          passwordInput(),
                          GetBuilder<UserAuthController>(
                              builder: (UserAuthController){
                                if(UserAuthController.status.isLoading){
                                  return Column(
                                    children: [
                                      SizedBox(height: 20,),
                                      Center(child: LoadingWidget()),
                                    ],
                                  );
                                }else{
                                  return buttonLogin();
                                }
                              }
                          ),
                          footer(),
                        ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
