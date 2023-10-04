import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../landing/views/landing_view.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController
  final userStorage = GetStorage();


  void isLogged(){
    print("storage: ${userStorage.read('user')}");
    if(userStorage.read('user') != null){
      Get.offAllNamed('/home');
    }else{
      Get.to(() => LandingView());
    }
  }
}
