import 'package:get/get_connect/connect.dart';

import '../../helpers/theme.dart';

class HomePageProvider extends GetConnect {

  Future<Response> getData() async {
    final response = await get(
        url + '/home',
    );
    return response;
  }

}
