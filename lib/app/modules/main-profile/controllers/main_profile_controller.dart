import 'package:get/get.dart';

import '../../../data/models/feeds_home_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/static_data.dart';

class MainProfileController extends GetxController with StateMixin<dynamic> {
  //TODO: Implement MainProfileController
  RxList<FeedsHome> feedsUserLogged = RxList<FeedsHome>([]);
  RxList<FeedsHome> feedsLikeUserLogged = RxList<FeedsHome>([]);
  RxList<FeedsHome> feedsSaveUserLogged = RxList<FeedsHome>([]);
  RxList<User> usersData = RxList<User>([]);

  void updateData(int newIndexValue) {
    change(null, status: RxStatus.loading());

    feedsUserLogged.assignAll(StaticData.feeds
        .where((element) => element.userId == newIndexValue)
        .toList());

    feedsLikeUserLogged.assignAll(StaticData.feeds.where((element) =>
        element.feedsLikes != null && element.feedsLikes!.any((elementLike) => elementLike.userId == newIndexValue)).toList());

    feedsSaveUserLogged.assignAll(StaticData.feeds.where((element) =>
        element.feedsSaves  != null && element.feedsSaves!.any((elementSave) => elementSave.userId == newIndexValue)).toList());

    usersData.assignAll(StaticData.users.where((element) => element.id == newIndexValue).toList());
    // print('data user: ${usersData.first.name}');
    change(null, status: RxStatus.success());
  }

  final count = 0.obs;
  @override
  void onInit() {
    change(null, status: RxStatus.empty());
    super.onInit();
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
