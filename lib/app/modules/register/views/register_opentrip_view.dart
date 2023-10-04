import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controllers/user_auth_controller.dart';
import '../../../helpers/loading_widget.dart';
import '../../../helpers/theme.dart';
import '../controllers/register_controller.dart';

class RegisterOpenTripView extends StatefulWidget {
  RegisterOpenTripView({Key? key}) : super(key: key);

  @override
  State<RegisterOpenTripView> createState() => _RegisterOpenTripViewState();
}

class _RegisterOpenTripViewState extends State<RegisterOpenTripView> {
  final controller = Get.find<RegisterController>();
  String message = "null";

  bool hasNavigatedToVerify = false;
  String filePath = '';

  String fileName = '';

  @override
  Widget build(BuildContext context) {
    handleRegister(String message) {
      FocusScope.of(context).unfocus();

      print(message);
    }

    Widget header() {
      return Container(
        margin: EdgeInsets.only(top: 50),
        child: Image.asset('assets/image_standing.png'),
      );
    }

    Widget headerText() {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sign Up",
                style: primaryTextStyle.copyWith(
                    fontSize: 32, fontWeight: extraBold)),
            Text(
              "Please fill in using your email address and input password",
              style: secondaryTextStyle.copyWith(fontSize: 12),
            )
          ],
        ),
      );
    }

    Widget nameInput() {
      return Container(
        margin: const EdgeInsets.only(top: 18, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name*",
              style: secondaryTextStyle.copyWith(fontSize: 14),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border.all(color: textSecondaryColor),
                  borderRadius: BorderRadius.circular(9)),
              child: TextFormField(
                controller: controller.name,
                style: primaryTextStyle,
                decoration: InputDecoration.collapsed(
                    hintText: "your name",
                    hintStyle: hintTextStyle.copyWith(
                      fontSize: 14,
                    )),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      );
    }

    Widget emailInput() {
      return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Email*",
              style: secondaryTextStyle.copyWith(fontSize: 14),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border.all(color: textSecondaryColor),
                  borderRadius: BorderRadius.circular(9)),
              child: TextFormField(
                controller: controller.email,
                style: primaryTextStyle,
                decoration: InputDecoration.collapsed(
                    hintText: "name@gmail.com",
                    hintStyle: hintTextStyle.copyWith(
                      fontSize: 14,
                    )),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      );
    }

    Widget passwordInput() {
      return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Password*",
              style: secondaryTextStyle.copyWith(fontSize: 14),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border.all(color: textSecondaryColor),
                  borderRadius: BorderRadius.circular(9)),
              child: TextFormField(
                controller: controller.password,
                obscureText: true,
                style: primaryTextStyle,
                decoration: InputDecoration.collapsed(
                    hintText: "password",
                    hintStyle: hintTextStyle.copyWith(
                      fontSize: 14,
                    )),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      );
    }

    Widget fileInput() {
      return GestureDetector(
        onTap: () async {
          print("ditap");
          FilePickerResult? result = await FilePicker.platform
              .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

          if (result != null) {
            final file = result.files.first;

            setState(() {
              fileName = file.name;
              filePath = result.files.single.path.toString();
            });

            print("name: ${file.name}");
            print("ext: ${file.extension}");
            print("type: ${file.runtimeType}");
            print("byte: ${File(result.files.single.path.toString())}");

          } else {
            return;
          }
        },
        child: Container(
          margin: const EdgeInsets.only(top: 10, bottom: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Surat Izin Usaha Pariwisata*",
                style: secondaryTextStyle.copyWith(fontSize: 14),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: textSecondaryColor),
                      borderRadius: BorderRadius.circular(9)),
                  child: fileName == ''
                      ? Text(
                          'choose file',
                          style: hintTextStyle.copyWith(fontSize: 14),
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          fileName,
                          style: primaryTextStyle.copyWith(fontSize: 14),
                          textAlign: TextAlign.center,
                        )),
            ],
          ),
        ),
      );
    }

    Widget footer() {
      return Container(
        margin: EdgeInsets.only(bottom: 20, top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("You have an account?",
                style: secondaryTextStyle.copyWith(fontSize: 14)),
            const SizedBox(
              width: 2,
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/login'),
              child: Text("Login",
                  style: buttonSecondaryTextStyle.copyWith(fontSize: 14)),
            )
          ],
        ),
      );
    }

    Widget buttonContinue(String message) {
      return ElevatedButton(
        onPressed: () {
          print('filepath: ${File(filePath)}');
          Get.find<UserAuthController>().registerAgent(
              controller.name.text,
              controller.email.text,
              controller.password.text,
              filePath
          );
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
              "Continue",
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
      );
    }

    Widget body() {
      return SingleChildScrollView(
          reverse: true,
          child: SizedBox(
            height: Get.size.height,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      header(),
                      headerText(),
                      nameInput(),
                      emailInput(),
                      passwordInput(),
                      fileInput(),
                      GetBuilder<UserAuthController>(
                        builder: (UserAuthController) {
                          final isLoading = UserAuthController.status.isLoading;
                          print(isLoading);
                          if(isLoading == true){
                            return Center(child: LoadingWidget());
                          }else{
                            return buttonContinue(message);
                          }
                        },
                      ),
                      footer()
                    ],
                  ),
                )),
          ));
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: controller.obx((state) {
          return body();
        },
            onEmpty: body(),
            onLoading: Center(child: LoadingWidget()),
            onError: (error) => body()),
      ),
    );
  }
}
