import 'package:get/get.dart';
import 'package:tripusfrontend/app/data/models/feeds_home_model.dart';
import 'package:tripusfrontend/app/data/static_data.dart';

import '../data/models/feeds_model.dart';
import '../data/models/user_model.dart';
import '../data/providers/home_page_provider.dart';
import '../helpers/dialog_widget.dart';

class HomePageController extends GetxController with StateMixin<List<FeedsHome>>{
  //TODO: Implement HomePageController

  @override
  void onInit() {
    change(null, status: RxStatus.empty());
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void responseStatusError(data, message, status) {
    change(data, status: status);
    dialogError(message);
  }

  Future<dynamic> getData() async{
      change(null, status: RxStatus.loading());
      try {
        await HomePageProvider()
            .getData()
            .then((response) {
          print("response : ${response.body}");
          if (response.statusCode == 400) {
            String errors = response.body['data']['errors'];
            responseStatusError(null, errors, RxStatus.error());
          } else if (response.statusCode == 500) {
            change(null, status: RxStatus.error());
            dialogError('Sorry, Internal Server Error!');
          } else if (response.statusCode == 200) {
            try {
              StaticData.feeds.clear();
              for(var i = 0; i<response.body['data']['feeds'].length; i++){
                if(StaticData.feeds.any((element) => element.id == response.body['data']['feeds'][i]['id'])){
                  print('pass');

                }else {
                  var data = FeedsHome.fromJson(
                      response.body['data']['feeds'][i]);
                  StaticData.feeds.add(data);
                  // print(data.toJson());
                }
              }
              print(StaticData.feeds.length);
              change(StaticData.feeds, status: RxStatus.success());
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

}
