import 'package:get/get.dart';
import 'package:tripusfrontend/app/controllers/home_page_controller.dart';

import '../controllers/main_profile_controller.dart';

class MainProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainProfileController>(
      () => MainProfileController(),
    );
    Get.lazyPut<HomePageController>(
          () => HomePageController(),
    );


  }
}
