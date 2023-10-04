import 'dart:io';

import 'package:get/get.dart';

import '../../helpers/theme.dart';
import '../models/feeds_model.dart';

class FeedsProvider extends GetConnect {

  Future<Response> create(String token, String description, String location, List<File> images) async {
    print("images0: ${images[0]}");
    print("images0: ${images[0].path}");
    print("images0: ${images[0].runtimeType}");
    // print("images1: ${images[1]}");
    // print("images1: ${images[1].path}");
    // print("images1: ${images[1].runtimeType}");
    try{
      var formData = FormData({
        'description': description,
        'location': location,
      });

      try{
        images.forEach((image) {
          formData.files.add(MapEntry('images[]', MultipartFile(image, filename: 'file.${image.path.split('.').last}')));
        });
      }catch(e){
        print(e.toString());
      }

      final response = await post(
          url + '/feeds/create',
          formData,
          headers: {'Authorization': token}
      );
      return response;
    }catch(e){
      print(e.toString());
      return Response();
    }
  }

  Future<Response> createTrips(
      String token,
      String title,
      String description,
      String location,
      List<File> images,
      String meetingPoint,
      String include,
      String exclude,
      String others,
      String categoryId,
      String dateStart,
      String dateEnd,
      String paymentAccount,
      double fee,
      int maxPerson,
      ) async {
    print("images0: ${images[0]}");
    print("images0: ${images[0].path}");
    print("images0: ${images[0].runtimeType}");
    // print("images1: ${images[1]}");
    // print("images1: ${images[1].path}");
    // print("images1: ${images[1].runtimeType}");
    try{
      var formData = FormData({
        'title': title,
        'description': description,
        'location': location,
        'meeting_point': meetingPoint,
        'include': include,
        'exclude': exclude,
        'others': others,
        'category_id': categoryId,
        'date_start': dateStart,
        'date_end': dateEnd,
        'payment_account': paymentAccount,
        'fee': fee,
        'max_person': maxPerson
      });

      try{
        images.forEach((image) {
          formData.files.add(MapEntry('images[]', MultipartFile(image, filename: 'file.${image.path.split('.').last}')));
        });
      }catch(e){
        print(e.toString());
      }

      final response = await post(
          url + '/trips/create',
          formData,
          headers: {'Authorization': token}
      );
      return response;
    }catch(e){
      print(e.toString());
      return Response();
    }
  }

  Future<Response> like(String token, int feedId) async {
    try{
      final response = await post(
          url + '/feeds/likes',
          {
            'feed_id': feedId,
          },
          headers: {'Authorization': token}
      );
      return response;
    }catch(e){
      print(e.toString());
      return Response();
    }
  }

  Future<Response> deleteLike(String token, int feedId) async {
    try{
      final response = await delete(
          url + '/feeds/likes/delete/$feedId',
          headers: {'Authorization': token}
      );
      return response;
    }catch(e){
      print(e.toString());
      return Response();
    }
  }

  Future<Response> save(String token, int feedId) async {
    try{
      final response = await post(
          url + '/feeds/saves',
          {
            'feed_id': feedId,
          },
          headers: {'Authorization': token}
      );
      return response;
    }catch(e){
      print(e.toString());
      return Response();
    }
  }

  Future<Response> deleteSave(String token, int feedId) async {
    try{
      final response = await delete(
          url + '/feeds/saves/delete/$feedId',
          headers: {'Authorization': token}
      );
      return response;
    }catch(e){
      print(e.toString());
      return Response();
    }
  }
}
