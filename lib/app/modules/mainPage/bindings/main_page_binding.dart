import 'package:get/get.dart';
import 'package:tripusfrontend/app/controllers/follow_controller.dart';
import 'package:tripusfrontend/app/controllers/user_auth_controller.dart';

import '../../explore-share-cost/controllers/explore_share_cost_controller.dart';
import '../controllers/main_page_controller.dart';

class MainPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainPageController>(
      () => MainPageController(),
    );
    Get.lazyPut<UserAuthController>(
          () => UserAuthController(),
    );
    Get.lazyPut<FollowController>(
          () => FollowController(),
    );
    Get.lazyPut<ExploreShareCostController>(
          () => ExploreShareCostController(),
    );
  }
}
