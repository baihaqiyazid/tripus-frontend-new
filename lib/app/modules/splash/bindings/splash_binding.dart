import 'package:get/get.dart';
import 'package:tripusfrontend/app/controllers/user_auth_controller.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(),
    );
    Get.lazyPut<UserAuthController>(
          () => UserAuthController(),
    );
  }
}
