import 'package:get/get.dart';
import 'package:tripusfrontend/app/controllers/follow_controller.dart';

import '../controllers/split_bill_controller.dart';

class SplitBillBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplitBillController>(
      () => SplitBillController(),
    );
    Get.lazyPut<FollowController>(
          () => FollowController(),
    );
  }
}
