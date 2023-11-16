import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tripusfrontend/app/modules/explore-share-cost/controllers/explore_share_cost_controller.dart';

import '../../../data/models/feeds_home_model.dart';
import '../../../helpers/theme.dart';

class ShareCostPostDetailController extends GetxController {
  //TODO: Implement ShareCostPostDetailController

  final count = 0.obs;
  late ExploreShareCostController exploreShareCostController;
  final details = true.obs;
  final review = false.obs;

  void onClickDetail(){
    details.value = true;
    review.value = false;
  }

  void onClickReview(){
    details.value = false;
    review.value = true;
  }

  @override
  void onInit() {
    super.onInit();
    Get.lazyPut(() => ExploreShareCostController());
    exploreShareCostController = Get.find<ExploreShareCostController>();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
