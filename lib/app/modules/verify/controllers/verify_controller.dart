import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tripusfrontend/app/data/models/user_model.dart';

import '../../../data/providers/user_provider.dart';
import '../../../helpers/dialog_widget.dart';

class VerifyController extends GetxController with StateMixin<User>{

  late TextEditingController otp1;
  late TextEditingController otp2;
  late TextEditingController otp3;
  late TextEditingController otp4;

  @override
  void onInit() {
    change(null, status: RxStatus.empty());
    super.onInit();
    otp1 = TextEditingController();
    otp2 = TextEditingController();
    otp3 = TextEditingController();
    otp4 = TextEditingController();
  }

  @override
  void onClose() {
    otp1.dispose();
    otp2.dispose();
    otp3.dispose();
    otp4.dispose();
  }
}
