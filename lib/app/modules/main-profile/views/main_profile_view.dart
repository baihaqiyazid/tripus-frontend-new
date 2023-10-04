import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tripusfrontend/app/data/models/feeds_home_model.dart';
import 'package:tripusfrontend/app/data/models/user_model.dart';
import 'package:tripusfrontend/app/data/static_data.dart';
import 'package:tripusfrontend/app/helpers/loading_widget.dart';
import 'package:tripusfrontend/app/modules/profile/views/profile_view.dart';

import '../../../controllers/home_page_controller.dart';
import '../../../helpers/theme.dart';
import '../controllers/main_profile_controller.dart';

class MainProfileView extends StatefulWidget {
  int? currentIndex;

  MainProfileView({this.currentIndex = 0, super.key});

  @override
  State<MainProfileView> createState() => _MainProfileViewState();
}

class _MainProfileViewState extends State<MainProfileView> {

  late HomePageController homePageController;

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => MainProfileController());

    Future.delayed(Duration.zero, () async {
       Get.find<MainProfileController>().updateData(
          int.parse(Get.parameters['id'] ?? '0'));
      homePageController = Get.find<HomePageController>();
    });
  }

  @override
  Widget build(BuildContext context) {
    // print('build');
    // print(Get.parameters['id']);

    Widget navigation() {
      return Obx(() {
        return Container(
          height: 50,
          margin: const EdgeInsets.only(right: 40, left: 40),
          color: Colors.transparent,
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 0.0,
                  sigmaY: 4.0,
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 0, left: 0, top: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                    border: Border.all(color: Colors.white.withOpacity(0.13)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        //begin color
                        Colors.white.withOpacity(0.8),
                        //end color
                        Colors.white.withOpacity(0.8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Shadow color
                        offset: Offset(0, 2), // Shadow offset
                        blurRadius: 5, // Shadow blur radius
                        spreadRadius: 0, // Shadow spread radius
                      ),
                    ]),
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: BottomNavigationBar(
                    elevation: 0,
                    onTap: (value) {
                      setState(() {
                        widget.currentIndex = value;
                      });
                    },
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Colors.transparent,
                    items: [
                      BottomNavigationBarItem(
                          icon: Text(
                            '${Get
                                .find<MainProfileController>()
                                .feedsUserLogged
                                .length} Photos',
                            style: primaryTextStylePlusJakartaSans.copyWith(
                                fontWeight: semibold,
                                fontSize: Get.size.height * 0.014,
                                color: widget.currentIndex == 0
                                    ? Colors.black
                                    : textHintColor),
                          ),
                          label: ''),
                      BottomNavigationBarItem(
                          icon: Text(
                            '${Get
                                .find<MainProfileController>()
                                .feedsLikeUserLogged
                                .length} Likes',
                            style: primaryTextStylePlusJakartaSans.copyWith(
                                fontWeight: semibold,
                                fontSize: Get.size.height * 0.014,
                                color: widget.currentIndex == 1
                                    ? Colors.black
                                    : textHintColor),
                          ),
                          label: ''),
                      BottomNavigationBarItem(
                          icon: Text(
                            '${Get
                                .find<MainProfileController>()
                                .feedsSaveUserLogged
                                .length} Collections',
                            style: primaryTextStylePlusJakartaSans.copyWith(
                                fontWeight: semibold,
                                fontSize: Get.size.height * 0.014,
                                color: widget.currentIndex == 2
                                    ? Colors.black
                                    : textHintColor),
                          ),
                          label: ''),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
    }

    Widget body() {
      switch (widget.currentIndex) {
        case 0:
          return ProfileView(
            feedsUserLogged: Get
                .find<MainProfileController>()
                .feedsUserLogged,
            users: Get
                .find<MainProfileController>()
                .usersData,
          );
        case 1:
          return ProfileView(
            feedsUserLogged: Get
                .find<MainProfileController>()
                .feedsLikeUserLogged,
            users: Get
                .find<MainProfileController>()
                .usersData,
          );
        case 2:
          return ProfileView(
            feedsUserLogged: Get
                .find<MainProfileController>()
                .feedsSaveUserLogged!,
            users: Get
                .find<MainProfileController>()
                .usersData,
          );
        default:
          return ProfileView(
            feedsUserLogged: Get
                .find<MainProfileController>()
                .feedsUserLogged!,
            users: Get
                .find<MainProfileController>()
                .usersData,);
      }
    }
    return Get.find<MainProfileController>().obx((state) {
      return Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            body(),
            Align(alignment: Alignment.bottomCenter, child: navigation())
          ],
        ),
      );
    }, onLoading: Center(child: LoadingWidget()), onEmpty: Container() );
  }
}
