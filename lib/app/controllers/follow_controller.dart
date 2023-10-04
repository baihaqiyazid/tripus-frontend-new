import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tripusfrontend/app/data/models/user_model.dart';
import 'package:tripusfrontend/app/data/providers/follow_provider.dart';

import '../data/models/follow_model.dart';
import '../data/static_data.dart';
import '../helpers/dialog_widget.dart';

class FollowController extends GetxController with StateMixin<dynamic>{
  //TODO: Implement FollowController

  var userAuth = GetStorage().read('user');

  @override
  void onInit() {
    change(null, status: RxStatus.empty());
    super.onInit();
  }

  void responseStatusError(data, message, status) {
    change(data, status: status);
    dialogError(message);
  }

  Future<dynamic> getData() async{
    change(null, status: RxStatus.loading());
    try {
      await FollowProvider()
          .getAll()
          .then((response) {
        print("response follow: ${response.body}");
        if (response.statusCode == 400) {
          String errors = response.body['data']['errors'];
          responseStatusError(null, errors, RxStatus.error());
        } else if (response.statusCode == 500) {
          change(null, status: RxStatus.error());
          dialogError('Sorry, Internal Server Error!');
        } else if (response.statusCode == 200) {
          try {
            StaticData.feeds.clear();
            for(var i = 0; i<response.body['data'][0].length; i++){
              if(StaticData.follows.any((element) => element.id == response.body['data'][0][i]['id'])){
                print('pass');

              }else {
                var data = Follow.fromJson(
                    response.body['data'][0][i]);
                StaticData.follows.add(data);
                // print(data.toJson());
              }
            }
            print(StaticData.follows.length);
            change(StaticData.follows, status: RxStatus.success());
            print("success get data");
          } catch (e) {
            print(e.toString());
            change(null, status: RxStatus.error());
          }
        }
      }, onError: (e) {
        responseStatusError(null, e.toString(), RxStatus.error());
      });
    } catch (e) {
      print(e.toString());
      change(null, status: RxStatus.error());
    }
  }

  Future<dynamic> following(int followedUserId) async{
    change(null, status: RxStatus.loading());
    try {
      await FollowProvider().create(userAuth['token'], followedUserId).then((response) {
        print("response : ${response.body}");
        print("response : ${response.statusCode}");
        if (response.statusCode == 400) {
          String errors = response.body['data']['errors'];
          responseStatusError(null, errors, RxStatus.error());
        } else if (response.statusCode == 500) {
          change(null, status: RxStatus.error());
          dialogError('Sorry, Internal Server Error!');
        } else if (response.statusCode == 200) {
          try {
            var data = Follow.fromJson(response.body['data'][0]);
            data.user = UserFollowed.fromJson(userAuth);
            data.userFollowing = UserFollowing.fromJson(StaticData.users.where((element) => element.id == followedUserId).first.toJson());
            print(data.toJson());

            StaticData.follows.add(data);

            print("static data follow length: ${StaticData.follows.length}");

            change(null, status: RxStatus.success());
            print("success follow people");
          } catch (e) {
            print(e.toString());
            change(null, status: RxStatus.error());
          } finally {
            change(null, status: RxStatus.empty());
          }
        }
      }, onError: (e) {
        responseStatusError(null, e.toString(), RxStatus.error());
      });
    } catch (e) {
      print(e.toString());
      change(null, status: RxStatus.error());
    }
  }

  Future<dynamic> handleDeleteFollow(int followedUserId) async{
    change(null, status: RxStatus.loading());
    try {
      await FollowProvider().deleteFollow(userAuth['token'], followedUserId).then((response) {
        print("response : ${response.body}");
        print("response : ${response.statusCode}");
        if (response.statusCode == 400) {
          String errors = response.body['data']['errors'];
          responseStatusError(null, errors, RxStatus.error());
        } else if (response.statusCode == 500) {
          change(null, status: RxStatus.error());
          dialogError('Sorry, Internal Server Error!');
        } else if (response.statusCode == 200) {
          try {
            var data = Follow.fromJson(response.body['data']);
            print(data.toJson());

            StaticData.follows.removeWhere((element) => element.id == data.id);

            print("static data follow length: ${StaticData.follows.length}");

            change(null, status: RxStatus.success());
            print("success delete people");
          } catch (e) {
            print(e.toString());
            change(null, status: RxStatus.error());
          } finally {
            change(null, status: RxStatus.empty());
          }
        }
      }, onError: (e) {
        responseStatusError(null, e.toString(), RxStatus.error());
      });
    } catch (e) {
      print(e.toString());
      change(null, status: RxStatus.error());
    }
  }
}
