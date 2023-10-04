import 'package:get/get.dart';

import '../controllers/see_follow_controller.dart';

class SeeFollowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SeeFollowController>(
      () => SeeFollowController(),
    );
  }
}
