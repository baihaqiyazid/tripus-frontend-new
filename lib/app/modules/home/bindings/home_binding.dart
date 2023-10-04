import 'package:get/get.dart';
import 'package:tripusfrontend/app/controllers/feeds_controller.dart';
import 'package:tripusfrontend/app/controllers/home_page_controller.dart';

import '../../../controllers/user_auth_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<FeedsController>(
          () => FeedsController(),
    );
    Get.lazyPut<HomePageController>(
          () => HomePageController(),
    );
    Get.lazyPut<UserAuthController>(
          () => UserAuthController(),
    );
  }
}
