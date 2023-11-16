import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tripusfrontend/app/modules/main-profile/views/main_profile_view.dart';
import 'package:tripusfrontend/app/modules/mainPage/views/main_page_view.dart';

import '../../../helpers/avatar_custom.dart';
import '../../../helpers/theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  final authC = GetStorage().read('user');
  var searchController = TextEditingController(text: '');

  final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
  );

  final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF686D76),
  );

  String searchQuery = '';

  Widget search() {
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: 10, right: 30, left: 30),
      padding: const EdgeInsets.only(left: 10, right: 5, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: containerPostColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.search,
            color: textHintColor,
          ),
          Expanded(
            child: TextFormField(
              // focusNode: _focusNode,
              autofocus: false,
              controller: searchController,
              style: primaryTextStyle,
              decoration: InputDecoration.collapsed(
                hintText: "Search by name or email",
                hintStyle: hintTextStyle.copyWith(
                  fontSize: 16,
                ),
              ),
              onChanged: (value) {
                print(value);
                searchQuery = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Material(
            elevation: 5,
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: context.mediaQueryPadding.top),
              padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Messages",
                    style: primaryTextStylePlusJakartaSans.copyWith(
                      fontSize: 20, fontWeight: FontWeight.bold
                    ),
                  ),
                  authC['profile_photo_path'].isEmpty?
                  AvatarCustom(
                      name: authC['name'],
                      width: 150,
                      height: 150,
                      color: Colors.white,
                      fontSize: 20,
                      radius: 20)
                      : CircleAvatar(
                    radius:
                    20, // Set the radius to control the size of the circle
                    backgroundImage: NetworkImage(
                        urlImage + authC['profile_photo_path']),
                  ),
                ],
              ),
            ),
          ),
          // search(),
          const SizedBox(height: 10,),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: controller.chatsStream(authC['email']),
              builder: (context, snapshot1) {
                if (snapshot1.connectionState == ConnectionState.active) {
                  var listDocsChats = snapshot1.data!.docs;

                  return Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: listDocsChats.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                          stream: controller
                              .friendStream(listDocsChats[index]["connection"]),
                          builder: (context, snapshot2) {
                            if (snapshot2.connectionState ==
                                ConnectionState.active) {
                              var data = snapshot2.data!.data();
                              print("data?['profile_photo_path']: ${data?['profile_photo_path']}");
                              return data!["status"] == ""
                                  ? ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 5,
                                ),
                                onTap:  () {
                                  print("${listDocsChats[index].id}");
                                  controller.goToChatRoom(
                                    "${listDocsChats[index].id}",
                                    authC['email'],
                                    listDocsChats[index]["connection"],
                                  );
                                },
                                leading: data['profile_photo_path'] == "" || data['profile_photo_path'] == null
                                    ? AvatarCustom(
                                    name: data['name'],
                                    width: 150,
                                    height: 150,
                                    color: Colors.white,
                                    fontSize: 20,
                                    radius: 25)
                                    : CircleAvatar(
                                  radius:
                                  25, // Set the radius to control the size of the circle
                                  backgroundImage: NetworkImage(
                                      urlImage + data['profile_photo_path']),
                                ),
                                title: Text(
                                  "${data["name"]}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: listDocsChats[index]
                                ["total_unread"] ==
                                    0
                                    ? SizedBox()
                                    : Chip(
                                  backgroundColor: Colors.red[900],
                                  label: Text(
                                    "${listDocsChats[index]["total_unread"]}",
                                    style: const TextStyle(
                                        color: Colors.white),
                                  ),
                                ),
                              )
                                  : ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 5,
                                ),
                                onTap: () {},
                                leading: data['profile_photo_path'] == ""
                                    ? AvatarCustom(
                                    name: data['name'],
                                    width: 150,
                                    height: 150,
                                    color: Colors.white,
                                    fontSize: 40,
                                    radius: 30)
                                    : CircleAvatar(
                                  radius:
                                  30, // Set the radius to control the size of the circle
                                  backgroundImage: NetworkImage(
                                      urlImage + data['profile_photo_path']),
                                ),
                                title: Text(
                                  "${data["name"]}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  "${data["status"]}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: listDocsChats[index]
                                ["total_unread"] ==
                                    0
                                    ? const SizedBox()
                                    : Chip(
                                  backgroundColor: Colors.red[900],
                                  label: Text(
                                    "${listDocsChats[index]["total_unread"]}",
                                    style: const TextStyle(
                                        color: Colors.white),
                                  ),
                                ),
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );
                      },
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(
      //     Icons.search,
      //     size: 30,
      //     color: Colors.white,
      //   ),
      //   backgroundColor: Colors.red[900],
      // ),
    );
  }
}
