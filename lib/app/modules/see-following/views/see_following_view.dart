import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tripusfrontend/app/helpers/theme.dart';
import 'package:tripusfrontend/app/modules/mainPage/views/main_page_view.dart';

import '../../../controllers/follow_controller.dart';
import '../../../controllers/user_auth_controller.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/follow_model.dart';
import '../../../data/static_data.dart';
import '../../../helpers/avatar_custom.dart';
import '../../../helpers/custom_refresh.dart';
import '../../../routes/app_pages.dart';
import '../controllers/see_following_controller.dart';

class SeeFollowingView extends StatefulWidget {
  const SeeFollowingView({Key? key}) : super(key: key);

  @override
  State<SeeFollowingView> createState() => _SeeFollowingViewState();
}

class _SeeFollowingViewState extends State<SeeFollowingView> {

  List<Follow> followingUserLogged = [];

  List<Follow> followersUserLogged = [];

   List<dynamic> arguments = Get.arguments.toList();
   User user = User();
   List<Follow> following = [];
   List<Follow> followers = [];
   List<User> peoples = [];
   String title = '';

   var searchController = TextEditingController(text: '');
   @override
  void initState(){
     super.initState();

     Get.lazyPut(() => FollowController());

     user = arguments[0]['user'];
     followingUserLogged = StaticData.follows
         .where((element) => element.userId == StaticData.box.read('user')['id'])
         .toList();

     followersUserLogged = StaticData.follows
         .where((element) => element.followedUserId == StaticData.box.read('user')['id'])
         .toList();

     following = StaticData.follows.where((element) => element.userId == user.id).toList();
     followers = StaticData.follows.where((element) => element.followedUserId == user.id).toList();
     peoples = StaticData.users
         .where((people) => people.role == 'open trip' || people.role == 'user')
         .toList();
     title = arguments[0]['title'];

     if(title == 'Following'){
       peoples = peoples.where((element) =>
           following.any((fol) => fol.followedUserId == element.id)
       ).toList();
     }else{
       peoples = peoples.where((element) =>
           followers.any((fol) => fol.userId == element.id)
       ).toList();
     }
   }

   void handleFollow(int id) async {
     await Get.find<FollowController>().following(id);
   }

   void handleDeleteFollow(int id) async {
     await Get.find<FollowController>().handleDeleteFollow(id);
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
         if(title == 'Following'){
           peoples = peoples.where((element) =>
               following.any((fol) => fol.followedUserId == element.id)
           ).toList();
         }else{
           peoples = peoples.where((element) =>
               followers.any((fol) => fol.userId == element.id)
           ).toList();
         }
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
    // print(user);
    // print(peoples);
    // print(title);
    print("Follow");
    // print(following.where((element) => element.followedUserId == user.id).first.toJson());

    Widget buttonFollowPeople(int id) {
      // print(follow.where((element) => element.userId == id));
      return Container(
        margin: const EdgeInsets.only(
          top: 0,
        ),
        child: ElevatedButton(
          onPressed: () async {
            // if(following.any((element) => element.followedUserId == StaticData.box.read('user')['id']) ||
            //     followers.any((element) => element.followedUserId == StaticData.box.read('user')['id'])){
            //   Get.toNamed(Routes.MAIN_PROFILE, parameters: {'id': people.id.toString()});
            // }
            if (!followingUserLogged.any((element) => element.followedUserId == id) && !followersUserLogged.any((element) => element.followedUserId == id) )  {
              handleFollow(id);
              setState(() {
                followingUserLogged.add(Follow(userId: user.id, followedUserId: id));
              });
            } else {
              handleDeleteFollow(id);
              setState(() {
                followingUserLogged.removeWhere((element) => element.followedUserId == id);
              });
            }
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
                followingUserLogged.any((element) => element.followedUserId == id) || followersUserLogged.any((element) => element.followedUserId == id) ?
                Color(0xffF5F5F5) : textButtonSecondaryColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                followingUserLogged.any((element) => element.followedUserId == id) || followersUserLogged.any((element) => element.followedUserId == id)? "Followed" : "Follow",
                style: buttonPrimaryTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: semibold,
                    color: followingUserLogged.any((element) => element.followedUserId == id) || followersUserLogged.any((element) => element.followedUserId == id)? textButtonSecondaryColor : Colors.white),
              ),
            ],
          ),
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

    Widget search() {
      return Container(
        margin: EdgeInsets.only(top: 20, bottom: 10),
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

                      if(title == 'Following'){
                        peoples = peoples.where((element) =>
                            following.any((fol) => fol.followedUserId == element.id)
                        ).toList();
                      }else{
                        peoples = peoples.where((element) =>
                            followers.any((fol) => fol.userId == element.id)
                        ).toList();
                      }
                    } else {
                      // If there is a search query, filter the list based on the name
                      peoples = StaticData.users
                          .where((people) =>
                      (people.id != user.id) &&
                          (people.role == 'open trip' || people.role == 'user') &&
                          (people.name!.toLowerCase().contains(value.toLowerCase()) ||
                              people.email!.toLowerCase().contains(value.toLowerCase())) )
                          .toList();

                      if(title == 'Following'){
                        peoples = peoples.where((element) =>
                            following.any((fol) => fol.followedUserId == element.id)
                        ).toList();
                      }else{
                        peoples = peoples.where((element) =>
                            followers.any((fol) => fol.userId == element.id)
                        ).toList();
                      }
                    }
                  });
                },
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text(title, style: primaryTextStylePlusJakartaSans.copyWith(
          fontSize: 16, fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: IconButton(
            splashRadius: 25,
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back, color: Colors.black,),
          ),
        ),
      ),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              search(),
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
      )
    );
  }
}
