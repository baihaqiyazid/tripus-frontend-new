import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tripusfrontend/app/data/providers/feeds_provider.dart';
import 'package:tripusfrontend/app/modules/explore-share-cost/controllers/explore_share_cost_controller.dart';
import 'package:tripusfrontend/app/routes/app_pages.dart';

import '../data/models/feeds_home_model.dart';
import '../data/models/feeds_model.dart';
import '../data/static_data.dart';
import '../helpers/dialog_widget.dart';

import 'home_page_controller.dart';

class FeedsController extends GetxController with StateMixin<Feed> {
  //TODO: Implement UserAuthController

  var userAuth = GetStorage().read('user');

  @override
  void onInit() {
    change(null, status: RxStatus.empty());
    super.onInit();
    Get.lazyPut(() => ExploreShareCostController());
  }

  void responseStatusError(data, message, status) {
    change(data, status: status);
    dialogError(message);
  }

  void create(String description, String location, List<File> images) {
    if (images.isEmpty) {
      dialogError("images required");
    } else {
      change(null, status: RxStatus.loading());
      try {
        FeedsProvider()
            .create(userAuth['token'], description, location, images)
            .then((response) {
              print("response: ${response.body}");
          if (response.statusCode == 400) {
            dynamic errors = response.body['data']['errors'];
            // print(errors[0]);
            responseStatusError(null, 'Sorry, the Image format doesn\'t support', RxStatus.empty());
          } else if(response.body == null){
            dialogError('Sorry, the Image format doesn\'t support');
          } else if (response.statusCode == 500) {
            change(null, status: RxStatus.error());
            dialogError('Sorry, Internal Server Error!');
          } else if (response.statusCode == 200) {
            try {
              var data = FeedsHome.fromJson(response.body['data'][0]);
              data.user = UserHome(
                id: userAuth['id'],
                name: userAuth['name'],
                profilePhotoPath: userAuth['profilePhotoPath'],
              );

              StaticData.feeds.add(data);
              change(null, status: RxStatus.success());
              Get.lazyPut(() => HomePageController());
              Future.delayed(Duration.zero, () async{
                await Get.find<HomePageController>().getData();
              }).then((value) => Get.offNamed('/home'));
            } catch (e) {
              change(null, status: RxStatus.error());
            } finally {
              change(null, status: RxStatus.empty());
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

  Future<dynamic> createTrips(
    String title,
    String description,
    String location,
    List<File> images,
    String meetingPoint,
    String include,
    String exclude,
    String others,
    String categoryId,
    String dateStart,
    String dateEnd,
    String paymentAccount,
    double fee,
    int maxPerson,
  ) async {
    if (images.isEmpty) {
      dialogError("images required");
    } else if (title == ''){
      dialogError("title field required");
    } else if (description == ''){
      dialogError("description field required");
    } else if (location == ''){
      dialogError("location field required");
    } else if (meetingPoint == ''){
      dialogError("meetingPoint field required");
    } else if (include == ''){
      dialogError("include field required");
    } else if (exclude == ''){
      dialogError("exclude field required");
    } else if (categoryId == ''){
      dialogError("category field required");
    } else if (dateStart == '' || dateEnd == ''){
      dialogError("date field required");
    } else if (paymentAccount == ''){
      dialogError("payment account field required");
    } else if (fee == 0.0){
      dialogError("fee field required");
    } else if (maxPerson == 0){
      dialogError("max person field required");
    } else {
      change(null, status: RxStatus.loading());
      try {
        FeedsProvider()
            .createTrips(
          userAuth['token'],
          title,
          description,
          location,
          images,
          meetingPoint,
          include,
          exclude,
          others,
          categoryId,
          dateStart,
          dateEnd,
          paymentAccount,
          fee,
          maxPerson,
        )
            .then((response) {
              print("response: ${response.body}");
          if (response.statusCode == 400) {
            dynamic errors = response.body['data']['errors'];
            responseStatusError(null, 'Sorry, the Image format doesn\'t support', RxStatus.empty());
          } else if (response.statusCode == 500) {
            change(null, status: RxStatus.error());
            dialogError('Sorry, Internal Server Error!');
          } else if (response.statusCode == 200) {
            try {
              var data = FeedsHome.fromJson(response.body['data'][0]);
              data.user = UserHome(
                id: userAuth['id'],
                name: userAuth['name'],
                profilePhotoPath: userAuth['profilePhotoPath'],
              );

              StaticData.feeds.add(data);
              change(null, status: RxStatus.success());
              Get.lazyPut(() => HomePageController());
              Future.delayed(Duration.zero, () async{
                await Get.find<HomePageController>().getData();
              }).then((value) => Get.offNamed('/home'));

            } catch (e) {
              change(null, status: RxStatus.error());
            } finally {
              change(null, status: RxStatus.empty());
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

  Future<dynamic> createShareCost(
      String title,
      String description,
      String location,
      List<File> images,
      String others,
      String dateStart,
      String dateEnd,
      double fee,
      List<int> join
      ) async {
    if (images.isEmpty) {
      dialogError("images required");
    } else if (title == ''){
      dialogError("title field required");
    } else if (location == ''){
      dialogError("location field required");
    } else if (dateStart == '' || dateEnd == ''){
      dialogError("date field required");
    } else if (fee == 0.0){
      dialogError("fee field required");
    } else {
      change(null, status: RxStatus.loading());
      try {
        FeedsProvider()
            .createShareCost(
          userAuth['token'],
          title,
          description,
          location,
          images,
          others,
          dateStart,
          dateEnd,
          fee,
          join
        )
            .then((response) {
          print("response: ${response.body}");
          if (response.statusCode == 400) {
            dynamic errors = response.body['data']['errors'];
            responseStatusError(null, 'Sorry, the Image format doesn\'t support', RxStatus.empty());
          } else if (response.statusCode == 500) {
            change(null, status: RxStatus.error());
            dialogError('Sorry, Internal Server Error!');
          } else if (response.statusCode == 200) {
            try {
              var data = FeedsHome.fromJson(response.body['data'][0]);
              data.user = UserHome(
                id: userAuth['id'],
                name: userAuth['name'],
                profilePhotoPath: userAuth['profilePhotoPath'],
              );

              Get.find<ExploreShareCostController>().shareCostFeeds.add(data);
              change(null, status: RxStatus.success());
              Get.lazyPut(() => HomePageController());
              Future.delayed(Duration.zero, () async{
                await Get.find<HomePageController>().getData();
              }).then((value) => Get.offNamed(Routes.EXPLORE_SHARE_COST));

            } catch (e) {
              change(null, status: RxStatus.error());
            } finally {
              change(null, status: RxStatus.empty());
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

  void like(int feedId) {
    change(null, status: RxStatus.loading());
    try {
      FeedsProvider().like(userAuth['token'], feedId).then((response) {
        if (response.statusCode == 400) {
          String errors = response.body['data']['errors'];
          responseStatusError(null, errors, RxStatus.error());
        } else if (response.statusCode == 500) {
          change(null, status: RxStatus.error());
          dialogError('Sorry, Internal Server Error!');
        } else if (response.statusCode == 200) {
          try {
            var data = FeedsHomeLikes.fromJson(response.body['data']['feed']);
            var feedToModify = StaticData.feeds.firstWhere(
              (element) => element.id == feedId,
            );
            feedToModify.feedsLikes?.add(data);
                      change(null, status: RxStatus.success());
          } catch (e) {
            change(null, status: RxStatus.error());
          } finally {
            change(null, status: RxStatus.empty());
          }
        }
      }, onError: (e) {
        responseStatusError(null, e.toString(), RxStatus.error());
      });
    } catch (e) {
      change(null, status: RxStatus.error());
    }
  }

  void deleteLike(int feedId) {
    change(null, status: RxStatus.loading());
    try {
      FeedsProvider().deleteLike(userAuth['token'], feedId).then((response) {
        if (response.statusCode == 404) {
          String errors = response.body['data']['errors'];
          responseStatusError(null, errors, RxStatus.error());
        } else if (response.statusCode == 500) {
          change(null, status: RxStatus.error());
          dialogError('Sorry, Internal Server Error!');
        } else if (response.statusCode == 200) {
          try {
            var feedToModify = StaticData.feeds.firstWhere(
              (element) => element.id == feedId,
            );

            feedToModify.feedsLikes!
                .removeWhere((element) => element.feedId == feedId);

            change(null, status: RxStatus.success());
          } catch (e) {
            change(null, status: RxStatus.error());
          } finally {
            change(null, status: RxStatus.empty());
          }
        }
      }, onError: (e) {
        responseStatusError(null, e.toString(), RxStatus.error());
      });
    } catch (e) {
      change(null, status: RxStatus.error());
    }
  }

  void save(int feedId) {
    change(null, status: RxStatus.loading());
    try {
      FeedsProvider().save(userAuth['token'], feedId).then((response) {
        if (response.statusCode == 400) {
          String errors = response.body['data']['errors'];
          responseStatusError(null, errors, RxStatus.error());
        } else if (response.statusCode == 500) {
          change(null, status: RxStatus.error());
          dialogError('Sorry, Internal Server Error!');
        } else if (response.statusCode == 200) {
          try {
            var data = FeedsHomeLikes.fromJson(response.body['data']['feed']);
            // Find the feed with the specified feedId
            var feedToModify = StaticData.feeds.firstWhere(
              (element) => element.id == feedId,
            );
            feedToModify.feedsSaves?.add(data);
                      change(null, status: RxStatus.success());
          } catch (e) {
            change(null, status: RxStatus.error());
          } finally {
            change(null, status: RxStatus.empty());
          }
        }
      }, onError: (e) {
        responseStatusError(null, e.toString(), RxStatus.error());
      });
    } catch (e) {
      change(null, status: RxStatus.error());
    }
  }

  void deleteSave(int feedId) {
    change(null, status: RxStatus.loading());
    try {
      FeedsProvider().deleteSave(userAuth['token'], feedId).then((response) {
        if (response.statusCode == 404) {
          String errors = response.body['data']['errors'];
          responseStatusError(null, errors, RxStatus.error());
        } else if (response.statusCode == 500) {
          change(null, status: RxStatus.error());
          dialogError('Sorry, Internal Server Error!');
        } else if (response.statusCode == 200) {
          try {
            var feedToModify = StaticData.feeds.firstWhere(
              (element) => element.id == feedId,
            );

            feedToModify.feedsSaves!
                .removeWhere((element) => element.userId == userAuth['id']);

            change(null, status: RxStatus.success());
          } catch (e) {
            change(null, status: RxStatus.error());
          } finally {
            change(null, status: RxStatus.empty());
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
