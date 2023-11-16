import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tripusfrontend/app/controllers/user_auth_controller.dart';
import 'package:tripusfrontend/app/helpers/avatar_custom.dart';
import 'package:tripusfrontend/app/helpers/custom_refresh.dart';
import 'package:tripusfrontend/app/helpers/theme.dart';
import 'package:tripusfrontend/app/routes/app_pages.dart';

import '../../../controllers/follow_controller.dart';
import '../../../data/models/follow_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/static_data.dart';
import '../../main-profile/controllers/main_profile_controller.dart';

class SearchFriendsView extends StatefulWidget {
  const SearchFriendsView({Key? key}) : super(key: key);

  @override
  State<SearchFriendsView> createState() => _SearchFriendsViewState();
}

class _SearchFriendsViewState extends State<SearchFriendsView> {
  User user = User();
  List<Follow> followingUserLogged = [];

  List<Follow> followersUserLogged = [];

  List<Follow> following = [];
  List<Follow> followers = [];

  bool isFollow = false;
  bool isTapFollowing = false;
  bool isTapFollower = true;

  List<User> peoples = StaticData.users
      .where((people) => people.role == 'open trip' || people.role == 'user')
      .toList();
  var searchController = TextEditingController(text: '');

  void handleFollow(int id) async {
    await Get.find<FollowController>().following(id);
  }

  void handleDeleteFollow(int id) async {
    await Get.find<FollowController>().handleDeleteFollow(id);
  }

  @override
  void initState() {
    super.initState();

    if(Get.arguments == null){
      user = User.fromJson(StaticData.box.read('user'));
    }else{
      user = Get.arguments;
    }

    followingUserLogged = StaticData.follows
        .where((element) => element.userId == StaticData.box.read('user')['id'])
        .toList();

    followersUserLogged = StaticData.follows
        .where((element) => element.followedUserId == StaticData.box.read('user')['id'])
        .toList();

    isFollow = followingUserLogged.any((e) => e.followedUserId == user.id);
    peoples = peoples.where((element) => element.id != user.id).toList();

    following = StaticData.follows.where((element) => element.userId == user.id).toList();
    followers = StaticData.follows.where((element) => element.followedUserId == user.id).toList();

    Get.lazyPut(() => MainProfileController());
    Get.lazyPut(() => FollowController());

    Future.delayed(Duration.zero, () async {
      Get.find<MainProfileController>().updateData(user.id!);
    });


  }

  RefreshController refreshC = RefreshController();

  void refreshData() async {
    try {
      print("refresh");
      await Future.delayed(Duration(seconds: 1));
      StaticData.users.clear();
      await initData();
      setState(() {
        peoples = StaticData.users
            .where((user) => user.role == 'open trip' || user.role == 'user')
            .toList();
        peoples = peoples.where((element) => element.id != user.id).toList();

        following = StaticData.follows.where((element) => element.userId == user.id).toList();
        followers = StaticData.follows.where((element) => element.followedUserId == user.id).toList();

        followingUserLogged = StaticData.follows
            .where((element) => element.userId == StaticData.box.read('user')['id'])
            .toList();

        followersUserLogged = StaticData.follows
            .where((element) => element.followedUserId == StaticData.box.read('user')['id'])
            .toList();
        searchController.clear();
      });
      print(StaticData.feeds.length);
      refreshC.refreshCompleted();
    } catch (e) {
      refreshC.refreshFailed();
    }
  }

  Future initData() async {
    await Get.find<UserAuthController>().getAllUsers();
    await Get.find<FollowController>().getData();
  }

  void loadData() async {
    try {
      print("load ulang");
      if (StaticData.feeds.length >= StaticData.feeds.length + 1) {
        // stop gaada user di database .... sudah abis datanya
        refreshC.loadNoData();
      } else {
        await initData();
        setState(() {});
        refreshC.loadComplete();
      }
    } catch (e) {
      refreshC.loadFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(user.toJson());
    // print(StaticData.users[1].toJson());
    // print(follow.first.toJson());
    // print("following");
    // print(following.last.toJson());
    // print("followers");
    // print(followers.last.toJson());

    Widget buttonFollowPeople(int id) {
      return Container(
        margin: const EdgeInsets.only(
          top: 0,
        ),
        child: ElevatedButton(
          onPressed: () async {
            if (!followingUserLogged.any((element) => element.followedUserId == id)) {
              handleFollow(id);
              setState(() {
                followingUserLogged.add(Follow(userId: user.id, followedUserId: id));
                // followers.add(Follow(userId: id, followedUserId: user.id));
              });
              // print("following add");
              // print(following.last.toJson());
              //
              // print("followers add");
              // print(followers.last.toJson());
            } else {
              handleDeleteFollow(id);
              setState(() {
                followingUserLogged.removeWhere((element) => element.followedUserId == id);
                // followers.removeWhere((element) => element.followedUserId == user.id);
              });
              print("follow delete");
              // print(following.where((element) => element.userId == id).first);
            }
            setState(() {
              isFollow = !isFollow;

            });
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(
                  vertical: 0), // Set the desired padding values
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10), // Set the desired border radius
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
                followingUserLogged.any((element) => element.followedUserId == id) ?
                Color(0xffF5F5F5) : textButtonSecondaryColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                followingUserLogged.any((element) => element.followedUserId == id) ? "Followed" : "Follow",
                style: buttonPrimaryTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: semibold,
                    color: followingUserLogged.any((element) => element.followedUserId == id)  ? textButtonSecondaryColor : Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    Widget buttonFollow(String name, int countFollow) {
      return ElevatedButton(
          onPressed: () {
            if(name == 'Following'){
              Get.toNamed(Routes.SEE_FOLLOWING, arguments: [{ 'user': user, 'following': following, 'followers': followers, 'peoples': peoples, 'title': "Following"}]);
            } else{
              Get.toNamed(Routes.SEE_FOLLOWING, arguments: [{ 'user': user, 'following': following, 'followers': followers, 'peoples': peoples, 'title': "Followers"}]);
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.white, // Warna latar belakang
            padding:
                EdgeInsets.symmetric(horizontal: 30, vertical: 10), // Padding
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20.0), // Radius yang Anda inginkan
            ),
          ),
          child: Text("${countFollow.toString()} $name",
              style: primaryTextStylePlusJakartaSans.copyWith(
                  fontSize: 16, fontWeight: FontWeight.bold)));
    }

    Widget search() {
      return Container(
        margin: EdgeInsets.only(top: 20),
        padding: const EdgeInsets.only(left: 10, right: 5, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: containerPostColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
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
                  setState(() {
                    if (value.isEmpty) {
                      // If the search query is empty, restore the original list
                      peoples = StaticData.users
                          .where((people) =>
                      (people.id != user.id) &&
                          (people.role == 'open trip' || people.role == 'user'))
                          .toList();
                    } else {
                      // If there is a search query, filter the list based on the name
                      peoples = StaticData.users
                          .where((people) =>
                      (people.id != user.id) &&
                          (people.role == 'open trip' || people.role == 'user') &&
                          (people.name!.toLowerCase().contains(value.toLowerCase()) ||
                          people.email!.toLowerCase().contains(value.toLowerCase())) )
                          .toList();
                    }
                  });
                },
              ),
            ),
          ],
        ),
      );
    }

    Widget people(User people) {
      return Container(
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            color: containerPostColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, left: 40, right: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              people.profilePhotoPath == null
                  ? GestureDetector(
                      onTap: () {
                        print(people.id);
                        Get.toNamed(Routes.MAIN_PROFILE,
                            parameters: {'id': people.id.toString()});
                      },
                      child: AvatarCustom(
                          name: people.name!,
                          width: 0,
                          height: 0,
                          color: Colors.white,
                          fontSize: 20,
                          radius: 30),
                    )
                  : GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.MAIN_PROFILE,
                            parameters: {'id': people.id.toString()});
                      },
                      child: CircleAvatar(
                        radius:
                            30, // Set the radius to control the size of the circle
                        backgroundImage:
                            NetworkImage(urlImage + people.profilePhotoPath!),
                      ),
                    ),
              const SizedBox(
                height: 5,
              ),
              Text(
                people.name!,
                style: primaryTextStylePlusJakartaSans.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis),
              ),
              Text(
                people.bio ?? "",
                style: primaryTextStylePlusJakartaSans.copyWith(
                    fontWeight: medium,
                    fontSize: 11,
                    overflow: TextOverflow.ellipsis),
              ),
              buttonFollowPeople(people.id!)
            ],
          ),
        ),
      );
    }

    Widget peopleMayYouKnow() {
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "People you may know",
              style: primaryTextStylePlusJakartaSans.copyWith(
                  fontWeight: medium, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: Get.arguments != null ? AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Text(
          'Friends',
          style: primaryTextStylePlusJakartaSans.copyWith(
              fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back, color: Colors.black,),
          ),
        ),
      ) : AppBar(
        automaticallyImplyLeading: false,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Text(
        'Friends',
        style: primaryTextStylePlusJakartaSans.copyWith(
        fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // leading: Padding(
        //   padding: const EdgeInsets.only(left: 25),
        //   child: IconButton(
        //     onPressed: () => Get.back(),
        //     icon: Icon(Icons.arrow_back, color: Colors.black,),
        //   ),
        // ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buttonFollow("Followers",
                  user.id == StaticData.box.read('user')['id'] ? followersUserLogged.where((element) => element.followedUserId == user.id).length : followers.where((element) => element.followedUserId == user.id).length),
                SizedBox(
                  width: 10,
                ),
                buttonFollow("Following",  user.id == StaticData.box.read('user')['id'] ? followingUserLogged.length : following.length)
              ],
            ),
            search(),
            peopleMayYouKnow(),

            Expanded(
                child: CustomRefresh(
              refreshController: refreshC,
              refreshData: refreshData,
              loadData: loadData,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1,
                    crossAxisCount: 2, // Number of columns in the grid
                    crossAxisSpacing: 10, // Spacing between columns
                    mainAxisSpacing: 4, // Spacing between rows
                  ),
                  itemCount: peoples.length,
                  // Number of items in the grid
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {}, child: people(peoples[index]));
                  }),
            ))
          ],
        ),
      ),
    );
  }
}
