import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../helpers/theme.dart';

class LandingSignupView extends GetView {
  const LandingSignupView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 30),
        child: Stack(
            children: [
              Image.asset(
                'assets/background_landing.png', fit: BoxFit.cover, width:  double.infinity,
              ),
              Container(
                margin: EdgeInsets.only(left:35, top: 520, bottom: 17),
                child: Text("Sign Up as", style: buttonPrimaryTextStyle.copyWith(
                    fontSize: 32, fontWeight: FontWeight.w800, decoration: TextDecoration.none,
                ),),
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 590, bottom: 17),
                      child: ElevatedButton(
                        onPressed: () => Get.toNamed('/register-agent'),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(
                                vertical: 12, horizontal: 90), // Set the desired padding values
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(17), // Set the desired border radius
                            ),
                          ),
                          backgroundColor:
                          MaterialStateProperty.all<Color>(backgroundColor),
                        ),
                        child: Text("Agent Open Trip", style: buttonSecondaryTextStyle.copyWith(
                            fontSize: 22, fontWeight: FontWeight.w600
                        ),),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              vertical: 12, horizontal: 135), // Set the desired padding values
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(17), // Set the desired border radius
                          ),
                        ),
                        backgroundColor:
                        MaterialStateProperty.all<Color>(backgroundColor),
                      ),
                      child: Text("Traveler", style: buttonSecondaryTextStyle.copyWith(
                          fontSize: 22, fontWeight: FontWeight.w600
                      ),),
                    ),
                  ],
                ),
              )
            ]
        ),
      ),
    );
  }
}
