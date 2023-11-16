import 'package:get/get.dart';

import '../controllers/review_summary_share_cost_controller.dart';

class ReviewSummaryShareCostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReviewSummaryShareCostController>(
      () => ReviewSummaryShareCostController(),
    );
  }
}
