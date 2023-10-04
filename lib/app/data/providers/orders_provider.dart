import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tripusfrontend/app/data/static_data.dart';

import '../../helpers/theme.dart';
import '../models/orders_model.dart';

class OrdersProvider extends GetConnect {
  Future<Response> getOrdersByEmail() async {
    final response = await get(
      url + '/orders/${GetStorage().read('user')['email']}',
    );
    return response;
  }

  Future<Response> cancelPayment(String orderId) async {
    final response = await get(url + '/order/${orderId}/cancel', headers: {
      "Authorization": StaticData.box.read('user')['token'],
    });
    return response;
  }

  Future<Response> getDataOrderAgent() async {
    final response = await get(
        url + '/orders', headers: {"Authorization" : StaticData.box.read('user')['token']}
    );
    return response;
  }

  Future<Response> createOrders(
    String token,
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
    int feed_id,
  ) async {
    try {
      var formData = FormData({
        'order_id': orderId,
        'total_price': totalPrice,
        "fee": fee,
        "admin_price": adminPrice,
        "bank": bank,
        "qty": qty,
        "name": name,
        "email": email,
        "address": address,
        "phone": phone,
        "feed_id": feed_id
      });

      final response = await post(url + '/order/charge', formData,
          headers: {'Authorization': token});
      return response;
    } catch (e) {
      print(e.toString());
      return Response();
    }
  }
}
