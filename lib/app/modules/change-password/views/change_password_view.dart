import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../helpers/theme.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    Widget oldPassword(){
      return Padding(
        padding: const EdgeInsets.only(top: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Old Password',
              style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 15,
                color: textSecondaryColor
              ),
            ),
            SizedBox(width: 40,),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: textSecondaryColor,
                        width: 1)
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: primaryTextStylePlusJakartaSans,
                        obscureText: true,
                        decoration: InputDecoration.collapsed(
                            hintText: "********",
                            hintStyle: primaryTextStylePlusJakartaSans.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: textHintColor
                            )),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Icon(Icons.remove_red_eye_rounded, color: textHintColor,)
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget newPassword(){
      return Padding(
        padding: const EdgeInsets.only(top: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'New Password',
              style: primaryTextStylePlusJakartaSans.copyWith(
                  fontSize: 15,
                  color: textSecondaryColor
              ),
            ),
            SizedBox(width: 36,),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: textSecondaryColor,
                        width: 1)
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: primaryTextStylePlusJakartaSans,
                        obscureText: true,
                        decoration: InputDecoration.collapsed(
                            hintText: "********",
                            hintStyle: primaryTextStylePlusJakartaSans.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textHintColor
                            )),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Icon(Icons.remove_red_eye_rounded, color: textHintColor,)
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget confirmPassword(){
      return Padding(
        padding: const EdgeInsets.only(top: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Confirm Password',
              style: primaryTextStylePlusJakartaSans.copyWith(
                  fontSize: 15,
                  color: textSecondaryColor
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: textSecondaryColor,
                        width: 1)
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: primaryTextStylePlusJakartaSans,
                        obscureText: true,
                        decoration: InputDecoration.collapsed(
                            hintText: "********",
                            hintStyle: primaryTextStylePlusJakartaSans.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textHintColor
                            )),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Icon(Icons.remove_red_eye_rounded, color: textHintColor,)
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget button() {
      return Container(
        margin: EdgeInsets.only(top: 18),
        child: Row( // Use Row to allow the button to expand
          children: [
            Expanded( // Wrap the button with Expanded
              child: ElevatedButton(
                onPressed: () {
                  // Add your button's onPressed logic here
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: 12),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      textButtonSecondaryColor),
                ),
                child: Text(
                  "Set Password",
                  style: buttonPrimaryTextStyle.copyWith(
                    fontSize: 22,
                    fontWeight: semibold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Text('Change Password'),
        titleTextStyle: TextStyle(
            fontWeight: semibold,
            color: textPrimaryColor,
            fontSize: 16),
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimaryColor),
        leading: Container(
          margin: EdgeInsets.only(left: 30),
          child: IconButton(
            highlightColor: Colors.transparent,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back(); // Navigasi kembali ke halaman sebelumnya
            },
          ),
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Change your password',  style: primaryTextStylePlusJakartaSans.copyWith(
                fontWeight: FontWeight.bold, fontSize: 14 )
              ),
              SizedBox(height: 18,),
              Divider(height: 1, thickness: 2,),
              oldPassword(),
              newPassword(),
              confirmPassword(),
              button()
            ],
          ),
        )
      ),
    );
  }
}
