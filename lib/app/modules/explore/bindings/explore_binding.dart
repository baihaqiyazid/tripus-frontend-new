import 'package:get/get.dart';

import '../../../controllers/home_page_controller.dart';
import '../controllers/explore_controller.dart';

class ExploreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExploreController>(
      () => ExploreController(),
    );
    Get.lazyPut<HomePageController>(() => HomePageController()
    );
  }
}
