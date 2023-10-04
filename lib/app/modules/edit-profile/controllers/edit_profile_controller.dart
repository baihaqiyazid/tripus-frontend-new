import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  //TODO: Implement EditProfileController

  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController bio;
  late TextEditingController links;
  late TextEditingController phone;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    name = TextEditingController();
    email = TextEditingController();
    bio = TextEditingController();
    links = TextEditingController();
    phone = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    name.dispose();
    email.dispose();
    bio.dispose();
    links.dispose();
    phone.dispose();
  }


}
