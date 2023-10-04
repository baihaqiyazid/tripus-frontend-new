import 'package:get/get.dart';

import '../../helpers/theme.dart';
import '../models/follow_model.dart';

class FollowProvider extends GetConnect {
  Future<Response> getAll() async {
    final response = await get(
      url + '/follow/get',
    );
    return response;
  }

  Future<Response> create(String token, int followedUserId) async {
    try{
      final response = await post(
          url + '/following/create',
          {
            "followed_user_id" : followedUserId
          },
          headers: {'Authorization': token}
      );
      return response;
    }catch(e){
      print(e.toString());
      return Response();
    }
  }

  Future<Response> deleteFollow(String token, int followedUserId) async {
    try{
      final response = await delete(
          url + '/following/$followedUserId/delete',
          headers: {'Authorization': token}
      );
      return response;
    }catch(e){
      print(e.toString());
      return Response();
    }
  }
}
