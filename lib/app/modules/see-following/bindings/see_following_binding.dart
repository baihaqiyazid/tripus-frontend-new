import 'package:get/get.dart';

import '../controllers/see_following_controller.dart';

class SeeFollowingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SeeFollowingController>(
      () => SeeFollowingController(),
    );
  }
}
