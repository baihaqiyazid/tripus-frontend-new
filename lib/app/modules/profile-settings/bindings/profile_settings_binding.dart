import 'package:get/get.dart';
import 'package:tripusfrontend/app/controllers/user_auth_controller.dart';

import '../controllers/profile_settings_controller.dart';

class ProfileSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileSettingsController>(
      () => ProfileSettingsController(),
    );
    Get.lazyPut<UserAuthController>(
          () => UserAuthController(),
    );
  }
}
