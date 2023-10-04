import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tripusfrontend/app/data/models/user_model.dart';
import 'package:tripusfrontend/app/data/providers/user_provider.dart';
import 'package:tripusfrontend/app/helpers/dialog_widget.dart';

class LoginController extends GetxController with StateMixin<User> {
  late TextEditingController email;
  late TextEditingController password;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    email = TextEditingController();
    password = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    email.dispose();
    password.dispose();
  }
}
