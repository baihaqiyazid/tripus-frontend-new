import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';

import '../../helpers/theme.dart';
import '../models/withdraw_model.dart';

class WithdrawProvider extends GetConnect {
  Future<Response> create(
      String token, int feedId, File file) async {
    final response = await post(
        '$url/trips/request-withdraw',
        FormData({
          'feed_id': feedId,
          'status': 'pending',
          'file': MultipartFile(file, filename: 'request-withdraw_file.${file.path.split('.').last}')
        }), headers: {'Authorization': token});
    return response;
  }

  Future<Response> getAllWithdraw() async {
    final response = await get(
      '$url/trips/withdraws',
    );

    return response;
  }
}
