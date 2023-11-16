import 'package:get/get.dart';

import '../controllers/explore_share_cost_controller.dart';

class ExploreShareCostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExploreShareCostController>(
      () => ExploreShareCostController(),
    );
  }
}
