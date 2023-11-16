import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tripusfrontend/app/data/models/follow_model.dart';
import 'package:tripusfrontend/app/data/models/user_model.dart';
import 'package:tripusfrontend/app/routes/app_pages.dart';

import '../../../data/static_data.dart';
import '../../../helpers/theme.dart';
import '../controllers/split_bill_controller.dart';

class SplitBillView extends StatefulWidget {
  SplitBillView({Key? key}) : super(key: key);

  @override
  State<SplitBillView> createState() => _SplitBillViewState();
}

class _SplitBillViewState extends State<SplitBillView> {
  var friends = StaticData.follows;
  List<Follow> mutualFollowers = [];
  List<bool> isCheckList = [];
  List<UserFollowing> splitUsers = [];

  @override
  void initState(){
    super.initState();
    int currentUserId = StaticData.box.read('user')['id'];

    mutualFollowers = StaticData.follows.where((follow) =>
    follow.userId == currentUserId &&
        follow.userFollowing!.role == 'user' && // Tambahkan kondisi untuk peran 'user'
        StaticData.follows.any((otherFollow) =>
        otherFollow.userId == follow.followedUserId &&
            otherFollow.followedUserId == currentUserId &&
            otherFollow.userFollowing!.role == 'user') // Tambahkan kondisi untuk peran 'user'
    ).toList();

    isCheckList = List.filled(mutualFollowers.length, false);
  }

  @override
  Widget build(BuildContext context) {
    // print("mutualFollowers ${mutualFollowers.first.toJson()}");

    Widget buttonContinue() {
      return ElevatedButton(
        onPressed: () {
          print("mutual friens: ${mutualFollowers.length}");
          print("splitUsers length: ${splitUsers.length}");
          print("arguments: ${Get.arguments[0]}");
          print("arguments1: ${Get.arguments[1]['others']}");
          Get.toNamed(Routes.REVIEW_SUMMARY_SHARE_COST, arguments: [splitUsers, Get.arguments[0], Get.arguments[1]]);
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(
                vertical: 12), // Set the desired padding values
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(10), // Set the desired border radius
            ),
          ),
          backgroundColor:
          MaterialStateProperty.all<Color>(textButtonSecondaryColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Continue",
              style: buttonPrimaryTextStyle.copyWith(
                  fontSize: 22, fontWeight: semibold),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 15),
        // Ukuran tinggi AppBar dengan margin vertical
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20), // Margin horizontal
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text("Who’s  Splitting the Bill?"),
            titleTextStyle: TextStyle(
                fontWeight: semibold, color: textPrimaryColor, fontSize: 16),
            centerTitle: true,
            iconTheme: IconThemeData(color: textPrimaryColor),
            toolbarHeight: kToolbarHeight + 15,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: mutualFollowers.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      print("mutualFollowers[index].userFollowing: ${mutualFollowers[index].userFollowing?.runtimeType}");
                      setState(() {
                        isCheckList[index] = !isCheckList[index];
                        if(isCheckList[index] == true){
                          splitUsers.add(mutualFollowers[index].userFollowing!);
                        }else{
                          splitUsers.removeWhere((element) => element.id == mutualFollowers[index].userFollowing!.id!);
                        }
                      });
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(urlImage + mutualFollowers[index].userFollowing!.profilePhotoPath!),
                      ),
                      title: Text(mutualFollowers[index].userFollowing!.name!, style: primaryTextStylePlusJakartaSans.copyWith(
                        fontWeight: FontWeight.bold, fontSize: 16
                      ),),
                      subtitle: Text(mutualFollowers[index].userFollowing!.email!),
                      trailing: SizedBox(
                        width: 24.0, // Set a specific width here
                        height: 24.0, // Set a specific height here
                        child: isCheckList[index]
                            ? Icon(
                          Icons.check,
                          color: textButtonSecondaryColor,
                        )
                            : Container(),
                      ),
                      // Add more widgets or functionality as needed
                    ),
                  );
                },
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: buttonContinue(),
            )
          ],
        ),
      ),
    );
  }
}
