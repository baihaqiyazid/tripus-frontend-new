import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tripusfrontend/app/data/static_data.dart';
import 'package:tripusfrontend/app/routes/app_pages.dart';

import '../../../data/models/feeds_home_model.dart';
import '../../../data/providers/home_page_provider.dart';
import '../../../helpers/dialog_widget.dart';

class ExploreShareCostController extends GetxController with StateMixin<List<FeedsHome>>{
  //TODO: Implement ExploreShareCostController

  RxList<FeedsHome> shareCostFeeds = RxList<FeedsHome>([]);
  RxList<FeedsHome> historyShareCostFeeds = RxList<FeedsHome>([]);

  var formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );

  @override
  void onInit() {
    change(null, status: RxStatus.empty());
    super.onInit();
    historyShareCostFeeds.assignAll(shareCostFeeds.where((p0) =>
        p0.feedsJoin!.any((element) => element.userId == StaticData.box.read('user')['id'])));
  }

  @override
  void onClose() {
    super.onClose();
  }

  void responseStatusError(data, message, status) {
    change(data, status: status);
    dialogError(message);
  }

  Future<dynamic> getDataShareCost() async {
    change(null, status: RxStatus.loading());
    try {
      await HomePageProvider().getDataShareCost().then((response) {
        print(response.body);
        if (response.statusCode == 400) {
          String errors = response.body['data']['errors'];
          responseStatusError(null, errors, RxStatus.error());
        } else if (response.statusCode == 500) {
          change(null, status: RxStatus.error());
          dialogError('Sorry, Internal Server Error!');
        } else if (response.statusCode == 200) {
          try {
            for (var i = 0; i < response.body['data']['feeds'].length; i++) {
              var feedData = response.body['data']['feeds'][i];
              if (!shareCostFeeds.any((element) => element.id == feedData['id'])) {
                var data = FeedsHome.fromJson(feedData);
                shareCostFeeds.add(data);
              }
            }
            log("shareCostFeeds controller: ${shareCostFeeds.length}");
            Get.toNamed(Routes.EXPLORE_SHARE_COST);
            change(shareCostFeeds, status: RxStatus.success());
          } catch (e) {
            change(null, status: RxStatus.error());
          }
        }
      }, onError: (e) {
        responseStatusError(null, e.toString(), RxStatus.error());
      });
    } catch (e) {
      change(null, status: RxStatus.error());
    }
  }
}
