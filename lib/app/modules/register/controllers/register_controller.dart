import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tripusfrontend/app/data/models/user_model.dart';
import 'package:tripusfrontend/app/data/providers/user_provider.dart';

import '../../../helpers/dialog_widget.dart';

class RegisterController extends GetxController with StateMixin<User> {
  var users = List<User>.empty().obs;

  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController password;

  @override
  void onInit() {
    change(null, status: RxStatus.empty());
    super.onInit();
    name = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
  }

  @override
  void onClose() {
    name.dispose();
    email.dispose();
    password.dispose();
  }
}
