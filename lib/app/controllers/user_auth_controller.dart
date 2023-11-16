import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var user = User().obs;

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
              change(data, status: RxStatus.success());
              Get.toNamed('/verify', arguments: data.token);
            } catch (e) {
              change(null, status: RxStatus.error());
            } finally{
              change(null, status: RxStatus.empty());
            }
          }
          change(null, status: RxStatus.empty());
        }, onError: (e) {
          responseStatusError(null, e.toString(), RxStatus.error());
        });
      } catch (e) {
      } finally {
        change(null, status: RxStatus.empty());
      }

    }
  }

  Future verify(String otp, String token) async{
    if (otp == '') {
      dialogError("otp wrong");
    } else {
      change(null, status: RxStatus.loading());
      await UserProvider().verifyEmail(otp, token).then((response) async {
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
            StaticData.users.add(data);
            userAuth.write('user', data.toJson());

            CollectionReference users = firestore.collection('users');

            try{
              await users.doc(data.email).set({
                "id" : data.id,
                "name" : data.name,
                "email": data.email,
                "token": data.token,
                "role": data.role,
                "profile_photo_path": data.profilePhotoPath,
                "status": "",
                "created_at": data.createdAt,
              });


              final currUser = await users.doc(data.email).get();
              final currUserData = currUser.data() as Map<String, dynamic>;

              user(User.fromJson(currUserData));

              user.refresh();

              final listChats =
                  await users.doc(data.email).collection("chats").get();

              if (listChats.docs.length != 0) {
                List<ChatUser> dataListChats = [];
                listChats.docs.forEach((element) {
                  var dataDocChat = element.data();
                  var dataDocChatId = element.id;
                  dataListChats.add(ChatUser(
                    chatId: dataDocChatId,
                    connection: dataDocChat["connection"],
                    lastTime: dataDocChat["lastTime"],
                    total_unread: dataDocChat["total_unread"],
                  ));
                });

                user.update((user) {
                  user!.chats = dataListChats;
                });
              } else {
                user.update((user) {
                  user!.chats = [];
                });
              }

              user.refresh();
            }catch (e){
              print("ERROR");
              print(e.toString());
            }


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
      change(null, status: RxStatus.empty());
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
              Future.delayed(Duration.zero, () async{
                await getAllPaymentAccountUsers();
                await Get.find<OrderController>().getOrdersByEmail();
              });
              change(data, status: RxStatus.success());
              Get.offAllNamed('/home');
            } catch (e) {
              responseStatusError(null, e.toString(), RxStatus.error());
            }
          }
        });
      } catch (e) {
        responseStatusError(null, e.toString(), RxStatus.error());
      }
      change(null, status: RxStatus.empty());
    }
  }

  Future<dynamic> getAllUsers() async {
    change(null, status: RxStatus.loading());
    try {
      await UserProvider().getAllUsers().then((response) {
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
              } else {
                var data = User.fromJson(response.body['data']['user'][i]);
                StaticData.users.add(data);
                // print(data.toJson());
              }
            }
            if(userAuth.read('user') != null){
              User userLogged = StaticData.users.where((element) => element.id == userAuth.read('user')['id']).first;
              if (userLogged.id == userAuth.read('user')['id']){
                userLogged.token = userAuth.read('user')['token'];
                userAuth.write('user', userLogged.toJson());
              }
            }

            change(null, status: RxStatus.success());
          } catch (e) {
            responseStatusError(null, e.toString(), RxStatus.error());
          } finally {
            change(null, status: RxStatus.empty());
          }
        } else {}
      });
    } catch (e) {
      responseStatusError(null, e.toString(), RxStatus.error());
    }
    finally {
      change(null, status: RxStatus.empty());
    }
  }

  Future<dynamic> logout() async {
    change(null, status: RxStatus.loading());
    try {
      await UserProvider().logout().then((response) {
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
    UserProvider()
        .updateProfile(userAuth.read('user')['token'], name, email, bio, links,
            phone, birthdate, profilePhotoPath, backgroundImageUrl)
        .then((response) {
          print("update response: ${response.body}");
      if (response.statusCode == 400) {
        Map<String, dynamic> errors = response.body['data']['errors'];
        errors.forEach((field, messages) {
          String errorMessage = messages[0];
          print(errorMessage);
          if (errorMessage == 'The background image url field must be an image.' || errorMessage == 'The profile photo path field must be an image.'){
            responseStatusError(null, 'Sorry, the Image format doesn\'t support', RxStatus.empty());
          }else{
            responseStatusError(null, errorMessage, RxStatus.empty());
          }
        });
      } else if (response.statusCode == 500) {
        change(null, status: RxStatus.empty());
        dialogError('Sorry, Internal Server Error!');
      } else if (response.statusCode == 200) {
        try {
          var data = User.fromJson(response.body['data']['user']);
          data.token = userAuth.read('user')['token'];

          GetStorage().remove('user');
          GetStorage().write('user', data.toJson());

          Get.lazyPut(() => HomePageController());

          Future.delayed(Duration.zero, () async {
            Get.find<HomePageController>().getData();
            getAllUsers();
          }).then((_) => Get.toNamed(Routes.HOME));

          change(data, status: RxStatus.success());
        } catch (e) {
          responseStatusError(null, e.toString(), RxStatus.error());
        } finally {
          change(null, status: RxStatus.empty());
        }
      } else {
        change(null, status: RxStatus.error());
      }
    },);
  }

  Future<dynamic> addPaymentAccount(String paymentMethodId, String number) async {
    change(null, status: RxStatus.loading());
    await UserProvider()
        .addPaymentAccount(
            userAuth.read('user')['token'], paymentMethodId, number)
        .then((response) {
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

          var paymentAccountListNew = StaticData.payment.where((element) => element.userId == userAuth.read('user')['id']).map((payment) => payment.toJson()).toList();
          StaticData.box.write('payment_account', paymentAccountListNew);

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
              } else {
                var data =
                    Payment.fromJson(response.body['data']['payment'][i]);
                StaticData.payment.add(data);
                // print(data.toJson());
              }
            }

            List<Map<String, dynamic>> paymentData = StaticData.payment
                .where((element) => element.userId == GetStorage().read('user')['id'])
                .map((payment) => payment.toJson()) // Mengonversi Payment menjadi Map
                .toList();

            GetStorage().write('payment_account', paymentData);


            change(paymentData, status: RxStatus.success());
          } catch (e) {
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
          } catch (e) {
            change(null, status: RxStatus.error());
          }
        }
      }, onError: (e) {
        responseStatusError(null, e.toString(), RxStatus.error());
      });
    } catch (e) {
      change(null, status: RxStatus.error());
    }
  }

  Future addNewConnection(String friendEmail) async {
    bool flagNewConnection = false;
    var chat_id;
    User _currentUser = User.fromJson(GetStorage().read('user'));
    String date = DateTime.now().toIso8601String();
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");

    final docChats =
    await users.doc(_currentUser!.email).collection("chats").get();

    if (docChats.docs.isNotEmpty) {
      // user sudah pernah chat dengan siapapun
      final checkConnection = await users
          .doc(_currentUser!.email)
          .collection("chats")
          .where("connection", isEqualTo: friendEmail)
          .get();

      if (checkConnection.docs.isNotEmpty) {
        // sudah pernah buat koneksi dengan => friendEmail
        flagNewConnection = false;

        //chat_id from chats collection
        chat_id = checkConnection.docs[0].id;
      } else {
        // blm pernah buat koneksi dengan => friendEmail
        // buat koneksi ....
        flagNewConnection = true;
      }
    } else {
      // blm pernah chat dengan siapapun
      // buat koneksi ....
      flagNewConnection = true;
    }

    if (flagNewConnection) {
      // cek dari chats collection => connections => mereka berdua...
      final chatsDocs = await chats.where(
        "connections",
        whereIn: [
          [
            _currentUser!.email,
            friendEmail,
          ],
          [
            friendEmail,
            _currentUser!.email,
          ],
        ],
      ).get();

      if (chatsDocs.docs.isNotEmpty) {
        // terdapat data chats (sudah ada koneksi antara mereka berdua)
        final chatDataId = chatsDocs.docs[0].id;
        final chatsData = chatsDocs.docs[0].data() as Map<String, dynamic>;

        await users
            .doc(_currentUser!.email)
            .collection("chats")
            .doc(chatDataId)
            .set({
          "connection": friendEmail,
          "lastTime": chatsData["lastTime"],
          "total_unread": 0,
        });

        final listChats =
        await users.doc(_currentUser!.email).collection("chats").get();

        if (listChats.docs.isNotEmpty) {
          List<ChatUser> dataListChats = List<ChatUser>.empty();
          for (var element in listChats.docs) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          }
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        chat_id = chatDataId;

        user.refresh();
      } else {
        // buat baru , mereka berdua benar2 belum ada koneksi
        final newChatDoc = await chats.add({
          "connections": [
            _currentUser!.email,
            friendEmail,
          ],
        });

        chats.doc(newChatDoc.id).collection("chat");

        await users
            .doc(_currentUser!.email)
            .collection("chats")
            .doc(newChatDoc.id)
            .set({
          "connection": friendEmail,
          "lastTime": date,
          "total_unread": 0,
        });

        final listChats =
        await users.doc(_currentUser.email).collection("chats").get();

        if (listChats.docs.isNotEmpty) {
          List<ChatUser> dataListChats = List<ChatUser>.empty(growable: true); // Fix here
          for (var element in listChats.docs) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          }
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        chat_id = newChatDoc.id;

        user.refresh();
      }
    }

    print(chat_id);

    final updateStatusChat = await chats
        .doc(chat_id)
        .collection("chat")
        .where("isRead", isEqualTo: false)
        .where("penerima", isEqualTo: _currentUser!.email)
        .get();

    updateStatusChat.docs.forEach((element) async {
      await chats
          .doc(chat_id)
          .collection("chat")
          .doc(element.id)
          .update({"isRead": true});
    });

    await users
        .doc(_currentUser!.email)
        .collection("chats")
        .doc(chat_id)
        .update({"total_unread": 0});

    Get.toNamed(
      Routes.CHAT_ROOM,
      arguments: {
        "chat_id": "$chat_id",
        "friendEmail": friendEmail,
      },
    );
  }
}
