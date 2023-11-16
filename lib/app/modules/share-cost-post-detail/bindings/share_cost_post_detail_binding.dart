import 'package:get/get.dart';

import '../controllers/share_cost_post_detail_controller.dart';

class ShareCostPostDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShareCostPostDetailController>(
      () => ShareCostPostDetailController(),
    );
  }
}
