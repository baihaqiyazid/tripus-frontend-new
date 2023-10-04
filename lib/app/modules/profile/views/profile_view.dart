import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tripusfrontend/app/controllers/follow_controller.dart';
import 'package:tripusfrontend/app/data/models/follow_model.dart';
import 'package:tripusfrontend/app/data/models/user_model.dart';
import 'package:tripusfrontend/app/helpers/avatar_custom.dart';
import 'package:tripusfrontend/app/modules/main-profile/controllers/main_profile_controller.dart';

import '../../../controllers/home_page_controller.dart';
import '../../../data/models/feeds_home_model.dart';
import '../../../data/models/follow_model.dart';
import '../../../data/static_data.dart';
import '../../../helpers/theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends StatefulWidget {
  RxList<FeedsHome>? feedsUserLogged;
  RxList<User>? users;

  ProfileView({this.feedsUserLogged = null, this.users = null});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  List<Follow> follow = StaticData.follows.where((element) => element.userId == StaticData.box.read('user')['id']).toList();
  bool isFollow = false;
  void initState(){
    super.initState();
    Get.lazyPut(() => MainProfileController());
    Get.lazyPut(() => HomePageController());

    Future.delayed(Duration.zero, () async {
      Get.find<MainProfileController>().updateData(widget.users!.first.id!);
      Get.find<HomePageController>();
    });

    Get.lazyPut(() => FollowController());
    isFollow = follow.any((e) => e.followedUserId == widget.users!.first.id);

  }

  bool isTapFollowing = false;
  bool isTapFollower = true;


  void handleFollow() async{
    await Get.find<FollowController>().following(widget.users!.first.id!);
  }

  void handleDeleteFollow() async{
    await Get.find<FollowController>().handleDeleteFollow(widget.users!.first.id!);
  }


  // bool isFollow = false;

  @override
  Widget build(BuildContext context) {

    print(follow.length);

    String? name = widget.users!.first.name;

    String? userName = name != null ? toBeginningOfSentenceCase(name) : '';

    Widget buttonEditProfile() {
      return Expanded(
        child: Container(
          margin: EdgeInsets.only(top: 16),
          child: ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.EDIT_PROFILE, arguments: widget.users!.first);
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 38), // Set the desired padding values
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Set the desired border radius
                ),
              ),
              backgroundColor:
                  MaterialStateProperty.all<Color>(textButtonSecondaryColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Edit Profile",
                  style: buttonPrimaryTextStyle.copyWith(
                      fontSize: 14, fontWeight: semibold),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget buttonSettings() {
      return Expanded(
        child: Container(
          margin: EdgeInsets.only(
            top: 16,
          ),
          child: ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.PROFILE_SETTINGS);
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 38), // Set the desired padding values
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Set the desired border radius
                ),
              ),
              backgroundColor:
                  MaterialStateProperty.all<Color>(containerPostColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Settings",
                  style: buttonPrimaryTextStyle.copyWith(
                      fontSize: 14, fontWeight: semibold, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget buttonMessage() {
      return Container(
        child: IconButton(
            onPressed: () {},
            splashRadius: 25,
            icon: SvgPicture.asset('assets/icon_chat.svg')),
      );
    }

    Widget seeFollow() {
      print(isTapFollower);
      print(isTapFollowing);
      return Container(
        margin: EdgeInsets.only(top: 15),
        child: IconButton(
            onPressed: () => Get.toNamed(Routes.SEE_FOLLOW, arguments: widget.users!.first),
            splashRadius: 25,
            icon: Icon(
              Icons.people_alt_rounded,
              color: Colors.black,
            )),
      );
    }

    Widget buttonFollow() {
      return Expanded(
        child: Container(
          margin: EdgeInsets.only(
            top: 16,
          ),
          child: ElevatedButton(
            onPressed: () async{
              if(isFollow == false){
                handleFollow();
                setState(() {
                  follow = StaticData.follows.where((element) => element.userId == StaticData.box.read('user')['id']).toList();
                });
              }else{
                handleDeleteFollow();
                setState(() {
                  follow = StaticData.follows.where((element) => element.userId == StaticData.box.read('user')['id']).toList();
                });
              }
              print("state");
              print(follow.length);
              setState(() {
                isFollow = !isFollow;
              });
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 38), // Set the desired padding values
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Set the desired border radius
                ),
              ),
              backgroundColor:
                  MaterialStateProperty.all<Color>(isFollow? Color(0xffF5F5F5) : textButtonSecondaryColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isFollow? "Followed" : "Follow",
                  style: buttonPrimaryTextStyle.copyWith(
                      fontSize: 14, fontWeight: semibold, color: isFollow? textButtonSecondaryColor: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          widget.users?.first.backgroundImageUrl != null
              ? Image.network(
                  urlImage + widget.users!.first.backgroundImageUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  height: Get.size.height / 3.5,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      // Image is fully loaded
                      return child;
                    } else {
                      // Image is still loading, show a loading widget
                      return SkeletonAvatar(
                        style: SkeletonAvatarStyle(
                            width: double.infinity,
                            height: Get.size.height / 3.5),
                      ); // Replace with your LoadingWidget
                    }
                  },
                )
              : Image.asset(
                  'assets/feeds_example.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  height: Get.size.height / 3.5,
                ),
          Align(
              alignment: Alignment.topLeft,
              child: SafeArea(
                child: Container(
                    margin: EdgeInsets.only(left: 24),
                    child: IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ))),
              )),
          Center(
            child: Container(
              margin: EdgeInsets.only(
                  top: Get.size.height / 4.5, right: 45, left: 45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.users?.first.profilePhotoPath == null
                      ? AvatarCustom(
                          name: widget.users!.first.name!,
                          width: 150,
                          height: 150,
                          color: Colors.white,
                          fontSize: 40,
                          radius: 50)
                      : CircleAvatar(
                          radius:
                              60, // Set the radius to control the size of the circle
                          backgroundImage: NetworkImage(
                              urlImage + widget.users!.first.profilePhotoPath!),
                        ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    userName!,
                    style: primaryTextStylePlusJakartaSans.copyWith(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  widget.users?.first.bio != null
                      ? Text(
                          widget.users?.first.bio,
                          style: primaryTextStylePlusJakartaSans.copyWith(
                              fontSize: 12),
                        )
                      : Container(),
                  widget.users?.first.id == StaticData.box.read('user')['id']
                      ? Row(
                          children: [
                            buttonEditProfile(),
                            const SizedBox(
                              width: 14,
                            ),
                            buttonSettings()
                          ],
                        )
                      : Row(
                          children: [
                            buttonFollow(),
                            const SizedBox(
                              width: 14,
                            ),
                            seeFollow()
                          ],
                        ),
                  Obx(() {
                    return Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1,
                            crossAxisCount: 2, // Number of columns in the grid
                            crossAxisSpacing: 2, // Spacing between columns
                            mainAxisSpacing: 2, // Spacing between rows
                          ),
                          itemCount: widget.feedsUserLogged?.length,
                          // Number of items in the grid
                          itemBuilder: (BuildContext context, int index) {
                            String? imageUrl =
                                widget.feedsUserLogged?[index].feedImage![0].imageUrl;
                            return GestureDetector(
                                onTap: () => Get.toNamed(Routes.FEED_DETAIL,
                                        arguments: widget.users!.first.id,
                                        parameters: {
                                          'id': widget.feedsUserLogged![index]
                                              .id
                                              .toString()
                                        }),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(urlImage + imageUrl!,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      // Image is fully loaded
                                      return child;
                                    } else {
                                      // Image is still loading, show a loading widget
                                      return SkeletonAvatar(); // Replace with your LoadingWidget
                                    }
                                  }),
                                ));
                          }),
                    );
                  })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
