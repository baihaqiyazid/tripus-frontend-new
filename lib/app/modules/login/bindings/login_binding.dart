import 'package:get/get.dart';

import '../../../controllers/user_auth_controller.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
    Get.lazyPut<UserAuthController>(
          () => UserAuthController(),
    );
  }
}
