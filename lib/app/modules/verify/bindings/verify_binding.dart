import 'package:get/get.dart';

import '../../../controllers/user_auth_controller.dart';
import '../controllers/verify_controller.dart';

class VerifyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserAuthController>(
          () => UserAuthController(),
    );
    Get.lazyPut<VerifyController>(
      () => VerifyController(),
    );
  }
}
