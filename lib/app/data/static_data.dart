
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:tripusfrontend/app/data/models/feeds_home_model.dart';
import 'package:tripusfrontend/app/data/models/follow_model.dart';

import 'models/orders_agent_model.dart';
import 'models/orders_model.dart';
import 'models/payment_model.dart';
import 'models/user_model.dart';

class StaticData {
  static RxList<FeedsHome> feeds = RxList<FeedsHome>([]);
  static List<User> users = [];
  static List<Follow> follows = [];
  static List<Payment> payment = [];
  static List<Orders> orders = [];
  static List<OrdersAgent> ordersAgent = [];
  static final box = GetStorage();

  static List<FeedsHome>? feedsUserLogged = StaticData.feeds
      .where((element) => element.userId == int.parse(Get.parameters['id'] ?? '0')).toList();

  static List<FeedsHome>?  feedsLikeUserLogged = StaticData.feeds.where((element) =>
      element.feedsLikes!.any((elementLike) =>
      elementLike.userId == int.parse(Get.parameters['id'] ?? '0'))).toList();

  static List<FeedsHome>? feedsSaveUserLogged = StaticData.feeds.where((element) =>
      element.feedsSaves!.any((elementSave) =>
      elementSave.userId == int.parse(Get.parameters['id'] ?? '0'))).toList();

  static List<User>? usersData = StaticData.users.where((element) => element.id == int.parse(Get.parameters['id'] ?? '0')).toList();
}