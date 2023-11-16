import 'package:get/get.dart';

import '../controllers/search_friends_controller.dart';

class SearchFriendsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchFriendsController>(
      () => SearchFriendsController(),
    );
  }
}
