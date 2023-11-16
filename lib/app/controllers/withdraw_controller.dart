import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:tripusfrontend/app/data/models/withdraw_model.dart';
import 'package:tripusfrontend/app/data/providers/withdraw_provider.dart';
import 'package:tripusfrontend/app/data/static_data.dart';

import '../helpers/dialog_widget.dart';

class WithdrawController extends GetxController with StateMixin<dynamic> {
  @override
  void onInit() {
    change(null, status: RxStatus.empty());
    super.onInit();
  }

  void responseStatusError(data, message, status) {
    change(data, status: status);
    dialogError(message);
  }

  void create(int feedId, String file) {
    if (file == '') {
      dialogError("File field required");
    } else {
      change(null, status: RxStatus.loading());
      try {
        WithdrawProvider().create(StaticData.box.read('user')['token'], feedId, File(file)).then(
                (response) {
                  log("response withdraw request ${response.body}");
              if (response.statusCode == 400) {
                Map<String, dynamic> errors = response.body['data']['errors'];
                errors.forEach((field, messages) {
                  String errorMessage = messages[0];
                  responseStatusError(null, errorMessage, RxStatus.error());
                });
              } else if (response.statusCode == 500) {
                change(null, status: RxStatus.error());
                dialogError('Sorry, Internal Server Error!');
              } else if (response.statusCode == 200) {
                try {
                  var data = Withdraw.fromJson(response.body['data'][0]);
                  if(StaticData.withdraws.where((element) => element.feedId == data.feedId).isEmpty){
                    StaticData.withdraws.add(data);
                  }
                  log("response withdraw request ${StaticData.withdraws.length}");
                  change(data, status: RxStatus.success());
                } catch (e) {
                  change(null, status: RxStatus.error());
                } finally{
                  change(null, status: RxStatus.empty());
                }
              }
              change(null, status: RxStatus.empty());
            }, onError: (e) {
          responseStatusError(null, e.toString(), RxStatus.error());
        });
      } catch (e) {
      } finally {
        change(null, status: RxStatus.empty());
      }
    }
  }

  Future<dynamic> getAllWithdraw() async {
    change(null, status: RxStatus.loading());
    try {
      await WithdrawProvider().getAllWithdraw().then((response) {
        if (response.statusCode == 400 ||
            response.statusCode == 401 ||
            response.statusCode == 404) {

          String errors = response.body['data']['errors'];
          responseStatusError(null, errors, RxStatus.error());
        } else if (response.statusCode == 500) {
          change(null, status: RxStatus.error());
          dialogError('Sorry, Internal Server Error!');
        } else if (response.statusCode == 200) {
          try {
            // var data = User.fromJson(response.body['data']['user']);
            // data.token = response.body['data']['token_type']+ ' ' + response.body['data']['access_token'];

            StaticData.withdraws.clear();
            for (var i = 0; i < response.body['data'][0].length; i++) {
              if (StaticData.withdraws.any((element) =>
              element.id == response.body['data'][0][i]['id'])) {
              } else {
                var data = Withdraw.fromJson(response.body['data'][0][i]);
                StaticData.withdraws.add(data);
                // print(data.toJson());
              }
            }
            change(null, status: RxStatus.success());
          } catch (e) {
            responseStatusError(null, e.toString(), RxStatus.error());
          } finally {
            change(null, status: RxStatus.empty());
          }
        } else {}
      });
    } catch (e) {
      log(e.toString());
      responseStatusError(null, e.toString(), RxStatus.error());
    }
    finally {
      change(null, status: RxStatus.empty());
    }
  }
}