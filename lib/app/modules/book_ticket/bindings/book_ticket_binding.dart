import 'package:get/get.dart';

import '../controllers/book_ticket_controller.dart';

class BookTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookTicketController>(
      () => BookTicketController(),
    );
  }
}
