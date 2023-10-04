import 'package:get/get.dart';

import '../models/feeds_home_model.dart';

class FeedsHomeProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return FeedsHome.fromJson(map);
      if (map is List)
        return map.map((item) => FeedsHome.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<FeedsHome?> getFeedsHome(int id) async {
    final response = await get('feedshome/$id');
    return response.body;
  }

  Future<Response<FeedsHome>> postFeedsHome(FeedsHome feedshome) async =>
      await post('feedshome', feedshome);
  Future<Response> deleteFeedsHome(int id) async =>
      await delete('feedshome/$id');
}
