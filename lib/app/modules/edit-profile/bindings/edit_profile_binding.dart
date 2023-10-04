import 'package:get/get.dart';
import 'package:tripusfrontend/app/controllers/user_auth_controller.dart';

import '../../main-profile/controllers/main_profile_controller.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditProfileController>(
      () => EditProfileController(),
    );
    Get.lazyPut<UserAuthController>(
          () => UserAuthController(),
    );
    Get.lazyPut<MainProfileController>(
          () => MainProfileController(),
    );
  }
}
