import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tripusfrontend/app/controllers/follow_controller.dart';
import 'package:tripusfrontend/app/data/static_data.dart';
import 'package:tripusfrontend/app/helpers/theme.dart';

import '../../../data/models/follow_model.dart';
import '../../../data/models/user_model.dart';
import '../../../helpers/avatar_custom.dart';
import '../../../routes/app_pages.dart';
import '../controllers/see_follow_controller.dart';

class SeeFollowView extends StatefulWidget {
  const SeeFollowView({Key? key}) : super(key: key);

  @override
  State<SeeFollowView> createState() => _SeeFollowViewState();
}

class _SeeFollowViewState extends State<SeeFollowView> {

  List<Follow> following = [];
  List<Follow> followers = [];

  bool isFollowersClick = true;
  bool isFollowingClick = false;

  User user = Get.arguments;

  void initState() {
    super.initState();
    following = StaticData.follows.where((element) => element.userId == user.id).toList();
    followers = StaticData.follows.where((element) => element.followedUserId == user.id).toList();
  }

  handleFollowers(){
    setState(() {
      isFollowersClick = true;
      isFollowingClick = false;
    });
  }

  handleFollowing(){
    setState(() {
      isFollowersClick = false;
      isFollowingClick = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(following.first.userFollowing!.bio);
    print(followers.length);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text(user.name!, style: primaryTextStylePlusJakartaSans.copyWith(
          fontSize: 18, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis
        ),),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back, color: Colors.black,),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => handleFollowers(),
                  child: Column(
                    children: [
                      Text("${followers.length} followers", style:
                        isFollowersClick ? primaryTextStylePlusJakartaSans.copyWith(
                          fontSize: 14, fontWeight: semibold
                      ) : primaryTextStylePlusJakartaSans.copyWith(
                          fontSize: 14,)),
                      SizedBox(
                        width: 80,
                          child: Divider(thickness: 2, height: 20, color: isFollowersClick? Colors.black : Colors.transparent,))
                    ],
                  ),
                ),
                SizedBox(width: 20,),
                GestureDetector(
                  onTap: () => handleFollowing(),
                  child: Column(
                    children: [
                      Text("${following.length} following", style:
                      isFollowingClick ? primaryTextStylePlusJakartaSans.copyWith(
                          fontSize: 14, fontWeight: semibold
                      ) : primaryTextStylePlusJakartaSans.copyWith(
                        fontSize: 14,)),
                     SizedBox(
                          width: 80,
                          child: Divider(thickness: 2, height: 20, color: isFollowingClick? Colors.black : Colors.transparent,))
                    ],
                  ),
                ),
              ],
            ),
            isFollowersClick?
            Expanded(
              child: ListView.builder(
                itemCount: followers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading:  followers[index].user!.profilePhotoPath == null
                        ? GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.MAIN_PROFILE,
                                parameters: {'id': followers[index].user!.id.toString()});
                          },
                          child: AvatarCustom(
                          name: followers[index].user!.name!,
                          width: 60,
                          height: 60,
                          color: Colors.white,
                          fontSize: 20,
                          radius: 22),
                        )
                        : CircleAvatar(
                      radius:
                      25, // Set the radius to control the size of the circle
                      backgroundImage: NetworkImage(
                          urlImage + followers[index].user!.profilePhotoPath!),
                    ),
                    title: Text(followers[index].user!.name!, style: primaryTextStylePlusJakartaSans.copyWith(
                      fontWeight: FontWeight.bold, fontSize: 14
                    ),),
                    subtitle: Text(followers[index].user!.bio ?? "", style: primaryTextStylePlusJakartaSans.copyWith(
                        fontSize: 12
                    ),),
                  );
                },
              ),
            ) :
            Expanded(
              child: ListView.builder(
                itemCount: following.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading:  following[index].userFollowing!.profilePhotoPath == null
                        ? AvatarCustom(
                        name: following[index].userFollowing!.name!,
                        width: 60,
                        height: 60,
                        color: Colors.white,
                        fontSize: 20,
                        radius: 25)
                        : CircleAvatar(
                      radius:
                      25, // Set the radius to control the size of the circle
                      backgroundImage: NetworkImage(
                          urlImage + following[index].userFollowing!.profilePhotoPath!),
                    ),
                    title: Text(following[index].userFollowing!.name!, style: primaryTextStylePlusJakartaSans.copyWith(
                        fontWeight: FontWeight.bold, fontSize: 14
                    ),),
                    subtitle: Text(following[index].userFollowing!.bio ?? "", style: primaryTextStylePlusJakartaSans.copyWith(
                        fontSize: 12, overflow: TextOverflow.ellipsis
                    ),),
                    // subtitle: Text('Item description'),
                    // trailing: Icon(Icons.more_vert),
                  );
                },
              ),
            )
          ],
        ),
      )
    );
  }
}
