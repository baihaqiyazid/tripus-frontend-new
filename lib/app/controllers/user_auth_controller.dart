import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tripusfrontend/app/controllers/order_controller.dart';
import 'package:tripusfrontend/app/routes/app_pages.dart';

import '../data/models/payment_model.dart';
import '../data/models/user_model.dart';
import '../data/providers/user_provider.dart';
import '../data/static_data.dart';
import '../helpers/dialog_widget.dart';
import '../modules/main-profile/controllers/main_profile_controller.dart';
import 'home_page_controller.dart';

class UserAuthController extends GetxController with StateMixin<dynamic> {
  //TODO: Implement UserAuthController

  static var userAuth = GetStorage();
  List<Map<String, dynamic>> paymentAccountList = [];

  @override
  void onInit() {
    change(null, status: RxStatus.empty());
    Get.lazyPut(() => MainProfileController());
    Get.lazyPut(() => OrderController());
    super.onInit();
  }

  void responseStatusError(data, message, status) {
    change(data, status: status);
    dialogError(message);
  }

  void registerUser(String name, String email, String password) {
    if (name == '') {
      dialogError("name field required");
    } else if (email == '') {
      dialogError("email field required");
    } else if (password == '') {
      dialogError("password field required");
    } else {
      change(null, status: RxStatus.loading());
      UserProvider().registerUser(name, password, email).then((response) {
        print(response.body);
        if (response.statusCode == 400) {
          Map<String, dynamic> errors = response.body['data']['errors'];
          errors.forEach((field, messages) {
            String errorMessage = messages[0];
            responseStatusError(null, errorMessage, RxStatus.error());
          });
        } else if (response.statusCode == 500) {
          change(null, status: RxStatus.error());
          dialogError('Sorry, Internal Server Error!');
        } else if (response.statusCode == 200) {
          try {
            var data = User.fromJson(response.body['data']['user']);
            data.token = response.body['data']['token_type'] +
                ' ' +
                response.body['data']['access_token'];
            print(data.toJson());
            change(data, status: RxStatus.success());
            Get.toNamed('/verify', arguments: data.token);
          } catch (e) {
            responseStatusError(null, e.toString(), RxStatus.error());
          } finally {
            change(null, status: RxStatus.empty());
          }
        } else {
          change(null, status: RxStatus.error());
        }
      }, onError: (e) {
        responseStatusError(null, e.toString(), RxStatus.error());
      });
    }
  }

  void registerAgent(String name, String email, String password, String file) {
    if (name == '') {
      dialogError("name field required");
    } else if (email == '') {
      dialogError("email field required");
    } else if (password == '') {
      dialogError("password field required");
    } else if (file == '') {
      dialogError("File field required");
    } else {
      change(null, status: RxStatus.loading());
      try {
        UserProvider().registerAgent(name, password, email, File(file)).then(
            (response) {
          print(response.body);
          if (response.statusCode == 400) {
            Map<String, dynamic> errors = response.body['data']['errors'];
            errors.forEach((field, messages) {
              String errorMessage = messages[0];
              responseStatusError(null, errorMessage, RxStatus.error());
            });
          } else if (response.statusCode == 500) {
            change(null, status: RxStatus.error());
            dialogError('Sorry, Internal Server Error!');
          } else if (response.statusCode == 200) {
            try {
              var data = User.fromJson(response.body['data']['user']);
              data.token = response.body['data']['token_type'] +
                  ' ' +
                  response.body['data']['access_token'];
              print(data.toJson());
              change(data, status: RxStatus.success());
              Get.toNamed('/verify', arguments: data.token);
            } catch (e) {
              change(null, status: RxStatus.error());
            }
          }
        }, onError: (e) {
          responseStatusError(null, e.toString(), RxStatus.error());
        });
      } catch (e) {
        print(e.toString());
        change(null, status: RxStatus.error());
      }
    }
  }

  void verify(String otp, String token) {
    if (otp == '') {
      dialogError("otp wrong");
    } else {
      print("status: $status");
      change(null, status: RxStatus.loading());
      UserProvider().verifyEmail(otp, token).then((response) {
        print(response.body);
        if (response.statusCode == 400) {
          String errors = response.body['data']['errors'];
          responseStatusError(null, errors, RxStatus.error());
        } else if (response.statusCode == 500) {
          change(null, status: RxStatus.error());
          dialogError('Sorry, Internal Server Error!');
        } else if (response.statusCode == 200) {
          try {
            var data = User.fromJson(response.body['data']['user']);
            data.token = token;
            userAuth.write('user', data.toJson());
            print(data.toJson());
            change(data, status: RxStatus.success());
            Get.offAllNamed('/home');
          } catch (e) {
            responseStatusError(null, e.toString(), RxStatus.error());
          } finally {
            change(null, status: RxStatus.empty());
          }
        }
      }, onError: (e) {
        responseStatusError(null, e.toString(), RxStatus.error());
      });
    }
  }

  void login(String email, String password) {
    if (email == '') {
      dialogError('email must be filled!');
    } else if (password == '') {
      dialogError('password must be filled!');
    } else {
      change(null, status: RxStatus.loading());
      try {
        UserProvider().login(email, password).then((response) {
          print(response.body);
          if (response.statusCode == 400 ||
              response.statusCode == 401 ||
              response.statusCode == 404) {
            String errors = response.body['data']['errors'];
            responseStatusError(null, errors, RxStatus.error());
          } else if (response.statusCode == 500) {
            change(null, status: RxStatus.error());
            dialogError('Sorry, Internal Server Error!');
          } else if (response.statusCode == 200) {
            try {
              var data = User.fromJson(response.body['data']['user']);
              data.token = response.body['data']['token_type'] +
                  ' ' +
                  response.body['data']['access_token'];
              userAuth.write('user', data.toJson());
              print("read storage ${userAuth.read('user')}");
              print(data.toJson());
              Future.delayed(Duration.zero, () async{
                await getAllPaymentAccountUsers();
                await Get.find<OrderController>().getOrdersByEmail();
              });
              change(data, status: RxStatus.success());
              Get.offAllNamed('/home');
            } catch (e) {
              print(e.toString());
              responseStatusError(null, e.toString(), RxStatus.error());
            } finally {
              change(null, status: RxStatus.empty());
            }
          } else {}
        });
      } catch (e) {
        responseStatusError(null, e.toString(), RxStatus.error());
      }
    }
  }

  Future<dynamic> getAllUsers() async {
    print('start');
    change(null, status: RxStatus.loading());
    try {
      await UserProvider().getAllUsers().then((response) {
        print(response.body);
        if (response.statusCode == 400 ||
            response.statusCode == 401 ||
            response.statusCode == 404) {
          String errors = response.body['data']['errors'];
          responseStatusError(null, errors, RxStatus.error());
        } else if (response.statusCode == 500) {
          change(null, status: RxStatus.error());
          dialogError('Sorry, Internal Server Error!');
        } else if (response.statusCode == 200) {
          try {
            // var data = User.fromJson(response.body['data']['user']);
            // data.token = response.body['data']['token_type']+ ' ' + response.body['data']['access_token'];

            StaticData.users.clear();
            for (var i = 0; i < response.body['data']['user'].length; i++) {
              if (StaticData.users.any((element) =>
                  element.id == response.body['data']['user'][i]['id'])) {
                print('pass');
              } else {
                var data = User.fromJson(response.body['data']['user'][i]);
                print(data.toJson());
                StaticData.users.add(data);
                // print(data.toJson());
              }
            }
            print(StaticData.users.length);
            change(null, status: RxStatus.success());
          } catch (e) {
            print(e.toString());
            responseStatusError(null, e.toString(), RxStatus.error());
          } finally {
            change(null, status: RxStatus.empty());
          }
        } else {}
      });
    } catch (e) {
      responseStatusError(null, e.toString(), RxStatus.error());
    }
  }

  Future<dynamic> logout() async {
    print('start');
    change(null, status: RxStatus.loading());
    try {
      await UserProvider().logout().then((response) {
        print(response.body);
        if (response.statusCode == 400 ||
            response.statusCode == 401 ||
            response.statusCode == 404) {
          String errors = response.body['data']['errors'];
          responseStatusError(null, errors, RxStatus.error());
        } else if (response.statusCode == 500) {
          change(null, status: RxStatus.error());
          dialogError('Sorry, Internal Server Error!');
        } else if (response.statusCode == 200) {
          try {
            GetStorage().erase();
            Get.offAllNamed(Routes.LOGIN);
            change(null, status: RxStatus.success());
          } catch (e) {
            print(e.toString());
            responseStatusError(null, e.toString(), RxStatus.error());
          } finally {
            change(null, status: RxStatus.empty());
          }
        } else {}
      });
    } catch (e) {
      responseStatusError(null, e.toString(), RxStatus.error());
    }
  }

  void updateProfile(
      {required dynamic name,
      required dynamic email,
      required String bio,
      required dynamic links,
      required dynamic phone,
      required dynamic birthdate,
      required dynamic profilePhotoPath,
      required dynamic backgroundImageUrl}) {
    change(null, status: RxStatus.loading());
    print("token: ${userAuth.read('user')['token']}");
    UserProvider()
        .updateProfile(userAuth.read('user')['token'], name, email, bio, links,
            phone, birthdate, profilePhotoPath, backgroundImageUrl)
        .then((response) {
      print(response.body);
      if (response.statusCode == 400) {
        Map<String, dynamic> errors = response.body['data']['errors'];
        errors.forEach((field, messages) {
          String errorMessage = messages[0];
          responseStatusError(null, errorMessage, RxStatus.error());
        });
      } else if (response.statusCode == 500) {
        change(null, status: RxStatus.error());
        dialogError('Sorry, Internal Server Error!');
      } else if (response.statusCode == 200) {
        try {
          var data = User.fromJson(response.body['data']['user']);
          data.token = userAuth.read('user')['token'];
          print(data.toJson());

          GetStorage().remove('user');
          GetStorage().write('user', data.toJson());

          Get.lazyPut(() => HomePageController());

          Future.delayed(Duration.zero, () async {
            Get.find<HomePageController>().getData();
            getAllUsers();
          }).then((_) => Get.toNamed(Routes.HOME));

          change(data, status: RxStatus.success());
        } catch (e) {
          print(e.toString());
          responseStatusError(null, e.toString(), RxStatus.error());
        } finally {
          change(null, status: RxStatus.empty());
        }
      } else {
        change(null, status: RxStatus.error());
      }
    }, onError: (e) {
      responseStatusError(null, e.toString(), RxStatus.error());
    });
  }

  Future<dynamic> addPaymentAccount(String paymentMethodId, String number) async {
    print(userAuth.read('user')['token']);
    change(null, status: RxStatus.loading());
    await UserProvider()
        .addPaymentAccount(
            userAuth.read('user')['token'], paymentMethodId, number)
        .then((response) {
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 400) {
        Map<String, dynamic> errors = response.body['data']['errors'];
        errors.forEach((field, messages) {
          String errorMessage = messages[0];
          responseStatusError(null, errorMessage, RxStatus.error());
        });
      } else if (response.statusCode == 500) {
        change(null, status: RxStatus.error());
        dialogError('Sorry, Internal Server Error!');
      } else if (response.statusCode == 200) {
        try {
          var data = Payment.fromJson(response.body['data']['payment']);

          StaticData.payment.add(data);

          var paymentAccountListNew = StaticData.payment.map((payment) => payment.toJson()).toList();
          print("len payemnt ctrl: ${paymentAccountListNew.length}");
          StaticData.box.write('payment_account', paymentAccountListNew);

          print("success");
          change(paymentAccountListNew, status: RxStatus.success());
        } catch (e) {
          responseStatusError(null, e.toString(), RxStatus.error());
        }
      } else {
        change(null, status: RxStatus.error());
      }
    }, onError: (e) {
      responseStatusError(null, e.toString(), RxStatus.error());
    });
  }

  Future<dynamic> getAllPaymentAccountUsers() async {
    change(null, status: RxStatus.loading());
    try {
      await UserProvider().getAllPaymentUsers().then((response) {
        print(response.body);
        if (response.statusCode == 400 ||
            response.statusCode == 401 ||
            response.statusCode == 404) {
          String errors = response.body['data']['errors'];
          responseStatusError(null, errors, RxStatus.error());
        } else if (response.statusCode == 500) {
          change(null, status: RxStatus.error());
          dialogError('Sorry, Internal Server Error!');
        } else if (response.statusCode == 200) {
          try {
            StaticData.payment.clear();
            for (var i = 0; i < response.body['data']['payment'].length; i++) {
              if (StaticData.payment.any((element) =>
                  element.id == response.body['data']['payment'][i]['id'])) {
                print('pass');
              } else {
                print("START");
                var data =
                    Payment.fromJson(response.body['data']['payment'][i]);
                print("DATA: ${data.toJson()}");
                StaticData.payment.add(data);
                // print(data.toJson());
              }
            }

            List<Map<String, dynamic>> paymentData = StaticData.payment
                .where((element) => element.userId == GetStorage().read('user')['id'])
                .map((payment) => payment.toJson()) // Mengonversi Payment menjadi Map
                .toList();

            GetStorage().write('payment_account', paymentData);


            print(StaticData.payment.length);
            change(paymentData, status: RxStatus.success());
          } catch (e) {
            print(e.toString());
            responseStatusError(null, e.toString(), RxStatus.error());
          }
        } else {}
      });
    } catch (e) {
      responseStatusError(null, e.toString(), RxStatus.error());
    }
  }

  Future<dynamic> deletePaymentAccount(int paymentAccountId) async{
    change(null, status: RxStatus.loading());
    try {
      await UserProvider()
          .deletePaymentAccount(userAuth.read('user')['token'], paymentAccountId)
          .then((response) {
        print("resposne : ${response.body}");
        print("resposne : ${response.statusCode}");
        if (response.statusCode == 404) {
          String errors = response.body['data']['errors'];
          responseStatusError(null, errors, RxStatus.error());
        } else if (response.statusCode == 500) {
          change(null, status: RxStatus.error());
          dialogError('Sorry, Internal Server Error!');
        } else if (response.statusCode == 200) {
          try {
            StaticData.payment.removeWhere(
                    (element) => element.id == paymentAccountId
            );

            var paymentAccountList = StaticData.payment.map((payment) => payment.toJson()).toList();
            StaticData.box.write('payment_account', paymentAccountList);

            change(paymentAccountList, status: RxStatus.success());
            print("success delete payment account");
          } catch (e) {
            print(e.toString());
            change(null, status: RxStatus.error());
          }
        }
      }, onError: (e) {
        responseStatusError(null, e.toString(), RxStatus.error());
      });
    } catch (e) {
      print(e.toString());
      change(null, status: RxStatus.error());
    }
  }
}
