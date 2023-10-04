import 'package:get/get.dart';

import '../controllers/payment_account_controller.dart';

class PaymentAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentAccountController>(
      () => PaymentAccountController(),
    );
  }
}
