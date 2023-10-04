import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tripusfrontend/app/controllers/user_auth_controller.dart';
import 'package:tripusfrontend/app/routes/app_pages.dart';

import '../../../helpers/theme.dart';
import '../controllers/profile_settings_controller.dart';

class ProfileSettingsView extends GetView<ProfileSettingsController> {
  const ProfileSettingsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Text('Settings'),
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
      body: Container(
        margin: EdgeInsets.only(left: 40, right: 40, top: 37, bottom: 20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(Routes.CHANGE_PASSWORD),
              child: Row(
                children: [
                  Icon(Icons.key_rounded, size: 25,),
                  SizedBox(width: 10,),
                  Text('Change Password', style: primaryTextStylePlusJakartaSans.copyWith(
                    fontWeight: semibold, fontSize: 14
                  ),)
                ],
              ),
            ),
            SizedBox(height: 28,),
            GestureDetector(
              onTap: () => Get.toNamed(Routes.PAYMENT_ACCOUNT),
              child: Row(
                children: [
                  Icon(Icons.payments_rounded, size: 25,),
                  SizedBox(width: 10,),
                  Text('Payment Accounts', style: primaryTextStylePlusJakartaSans.copyWith(
                      fontWeight: semibold, fontSize: 14
                  ),)
                ],
              ),
            ),
            SizedBox(height: 28,),
            GestureDetector(
              onTap: () => Get.toNamed(Routes.HISTORY_TRANSACTION),
              child: Row(
                children: [
                  Icon(Icons.money, size: 25,),
                  SizedBox(width: 10,),
                  Text('History Transaction', style: primaryTextStylePlusJakartaSans.copyWith(
                      fontWeight: semibold, fontSize: 14
                  ),)
                ],
              ),
            ),
            Spacer(),
            Text('Delete Account', style: primaryTextStylePlusJakartaSans.copyWith(
              fontWeight: semibold, fontSize: 14, color: Colors.red,
            ),),
            SizedBox(height: 12,),
            InkWell(
              onTap: () {
                Get.find<UserAuthController>().logout();
              },
              child: Text('Log Out', style: primaryTextStylePlusJakartaSans.copyWith(
                fontWeight: semibold, fontSize: 14, color: Colors.blue,
              ),),
            )
          ],
        ),
      )
    );
  }
}
