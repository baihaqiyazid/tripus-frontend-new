import 'package:get/get.dart';

import '../controllers/agent_detail_transaction_controller.dart';

class AgentDetailTransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgentDetailTransactionController>(
      () => AgentDetailTransactionController(),
    );
  }
}
