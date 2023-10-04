import 'package:get/get.dart';
import 'package:tripusfrontend/app/data/static_data.dart';
import 'dart:io';

import '../../helpers/theme.dart';
import '../models/user_model.dart';

class UserProvider extends GetConnect {
  Future<Response> registerUser(
    String name,
    String password,
    String email,
  ) async {
    final response = await post(url + '/register',
        {"name": name, "email": email, "password": password, "role": "user"});
    return response;
  }

  Future<Response> updateProfile(
    String token,
    String? name,
    String? email,
    String? bio,
    String? links,
    String? phone,
    String? birthdate,
    File? profilePhotoPath,
    File? backgroundImageUrl,
  ) async {
    try {
      final formData = FormData({
        "name": name,
        "email": email,
        "bio": bio,
        "links": links,
        "phone": phone,
        "birthdate": birthdate,
        // Convert expressions to map entries here
        'profile_photo_path': profilePhotoPath != null
            ? MultipartFile(profilePhotoPath, filename: profilePhotoPath.path)
            : null,
        'background_image_url': backgroundImageUrl != null
            ? MultipartFile(backgroundImageUrl,
                filename: backgroundImageUrl.path)
            : null,
      });

      final response = await post(
        url + '/users/update',
        formData,
        headers: {"Authorization": token},
      );

      return response;
    } catch (e) {
      print(e.toString());
      return Response();
    }
  }

  Future<Response> getAllUsers() async {
    final response = await get(
      url + '/users',
    );
    return response;
  }

  Future<Response> logout() async {
    final response = await get(
      url + '/logout', headers: {
        'Authorization': StaticData.box.read('user')['token']
    }
    );
    return response;
  }

  Future<Response> registerAgent(
      String name, String password, String email, File file) async {
    final response = await post(
        url + '/register',
        FormData({
          'name': name,
          'email': email,
          'password': password,
          'role': 'open trip',
          'file': MultipartFile(file, filename: 'agent_file_' + email + '.pdf'),
        }));
    return response;
  }

  Future<Response> verifyEmail(String otpCode, String token) async {
    final response = await post(url + '/verify', {
      "otp_code": otpCode,
    }, headers: {
      'Authorization': token
    });
    return response;
  }

  Future<Response> login(String email, String password) async {
    final response =
        await post(url + '/login', {"email": email, "password": password});
    return response;
  }

  Future<Response> addPaymentAccount(
    String token,
    String paymentMethodId,
    String number,
  ) async {
    final response = await post(url + '/payment/create',
        {"payment_method_id": paymentMethodId, "number": number},
        headers: {"Authorization": token});
    return response;
  }

  Future<Response> getAllPaymentUsers() async {
    final response = await get(
      url + '/payment-account',
    );
    return response;
  }

  Future<Response> deletePaymentAccount(String token, int paymentAccountId) async {
    try{
      final response = await delete(
          url + '/payment/delete/$paymentAccountId',
          headers: {'Authorization': token}
      );
      return response;
    }catch(e){
      print(e.toString());
      return Response();
    }
  }
}
