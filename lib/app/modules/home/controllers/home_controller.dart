import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tripusfrontend/app/data/static_data.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final storage = GetStorage();
  var user;

  @override
  void onInit() {
    super.onInit();
    user = storage.read('user');
  }

  @override
  void onClose() {
    super.onClose();
  }

}
