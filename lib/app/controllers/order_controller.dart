import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tripusfrontend/app/controllers/user_auth_controller.dart';
import 'package:tripusfrontend/app/data/providers/orders_provider.dart';
import 'package:tripusfrontend/app/routes/app_pages.dart';

import '../data/models/orders_agent_model.dart';
import '../data/models/orders_model.dart';
import '../data/static_data.dart';
import '../helpers/dialog_widget.dart';
import 'home_page_controller.dart';

class OrderController extends GetxController with StateMixin<dynamic>{
  //TODO: Implement OrderControllerController
  @override
  void onInit() {
    change(null, status: RxStatus.empty());
    super.onInit();
  }

  void responseStatusError(data, message, status) {
    change(data, status: status);
    dialogError(message);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<dynamic> getOrdersByEmail() async{
    change(null, status: RxStatus.loading());
    try {
      await OrdersProvider()
          .getOrdersByEmail()
          .then((response) {
        if (response.statusCode == 400) {
          String errors = response.body['data']['errors'];
          responseStatusError(null, errors, RxStatus.error());
        } else if (response.statusCode == 500) {
          change(null, status: RxStatus.error());
          dialogError('Sorry, Internal Server Error!');
        } else if (response.statusCode == 200) {
          try {
            StaticData.orders.clear();
            for(var i = 0; i<response.body['data'].length; i++){
              if(StaticData.orders.any((element) => element.id == response.body['data'][i]['id'])){
              }else {
                var data = Orders.fromJson(
                    response.body['data'][i]);
                StaticData.orders.add(data);
                // print(data.toJson());
              }
            }
            Get.lazyPut(() => HomePageController());
            Get.lazyPut(() => UserAuthController());
            Future.delayed(Duration.zero, () async{
              await Get.find<HomePageController>().getData();
            });

            change(StaticData.orders, status: RxStatus.success());
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

  Future<dynamic> getOrdersByAgent() async{
    change(null, status: RxStatus.loading());
    try {
      await OrdersProvider()
          .getDataOrderAgent()
          .then((response) {
        if (response.statusCode == 400) {
          String errors = response.body['data']['errors'];
          responseStatusError(null, errors, RxStatus.error());
        } else if (response.statusCode == 500) {
          change(null, status: RxStatus.error());
          dialogError('Sorry, Internal Server Error!');
        } else if (response.statusCode == 200) {
          try {
            StaticData.ordersAgent.clear();

            for(var i = 0; i<response.body['data'].length; i++){
                var data = OrdersAgent.fromJson(
                    response.body['data'][i]);
                StaticData.ordersAgent.add(data);
                // print(data.toJson());
            }

            change(null, status: RxStatus.success());
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

  Future<dynamic> cancelPayment(String orderId) async{
    change(null, status: RxStatus.loading());
    try {
      await OrdersProvider()
          .cancelPayment(orderId)
          .then((response) {
        if (response.statusCode == 400) {
          String errors = response.body['data']['errors'];
          responseStatusError(null, errors, RxStatus.error());
        } else if (response.statusCode == 500) {
          change(null, status: RxStatus.error());
          dialogError('Sorry, Internal Server Error!');
        } else if (response.statusCode == 200) {
          try {
            change(StaticData.orders, status: RxStatus.success());
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

  Future<dynamic> createOrder(
      String orderId,
      double totalPrice,
      dynamic fee,
      double adminPrice,
      String bank,
      int qty,
      String name,
      String email,
      dynamic address,
      dynamic phone,
      int feedId,
      ) async {
      change(null, status: RxStatus.loading());
      try {
        await OrdersProvider()
            .createOrders(
          GetStorage().read('user')['token'],
           orderId,
           totalPrice,
           fee,
           adminPrice,
           bank,
           qty,
           name,
           email,
           address,
           phone,
          feedId
        )
            .then((response) {
          if (response.statusCode == 400) {
            String errors = response.body['data']['errors'];
            responseStatusError(null, errors, RxStatus.error());
          } else if (response.statusCode == 500) {
            change(null, status: RxStatus.error());
            dialogError('Sorry, Internal Server Error!');
          } else if (response.statusCode == 200) {
            try {
              var data = Orders.fromJson(response.body['data']['order']);
              getOrdersByEmail();
              change(null, status: RxStatus.success());
              Get.offNamed(Routes.HISTORY_TRANSACTION);

            } catch (e) {
              change(null, status: RxStatus.error());
            } finally {
              change(null, status: RxStatus.empty());
            }
          } else {
            dialogError("Oops! Please try again!");
            change(null, status: RxStatus.empty());
          }
        }, onError: (e) {
          responseStatusError(null, e.toString(), RxStatus.error());
        });
      } catch (e) {
        change(null, status: RxStatus.error());
      } finally {
        change(null, status: RxStatus.empty());
      }
  }
}
