import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tripusfrontend/app/data/models/feeds_home_model.dart';
import 'package:tripusfrontend/app/data/static_data.dart';
import 'package:tripusfrontend/app/helpers/carousel_widget.dart';
import 'package:tripusfrontend/app/modules/home/views/widget/feeds_widget.dart';

import '../../../data/models/follow_model.dart';
import '../../../helpers/format_datetime.dart';
import '../../../helpers/format_number.dart';
import '../../../helpers/theme.dart';
import '../controllers/share_cost_post_detail_controller.dart';

class ShareCostPostDetailView extends GetView<ShareCostPostDetailController> {
  const ShareCostPostDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    FeedsHome feed = controller.exploreShareCostController.shareCostFeeds.firstWhere((element) => element.id == int.parse(Get.parameters['id'] ?? '0'));
    List<Widget> images = feed.feedImage!
        .map((item) => Container(
      child: Stack(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(urlImage + item.imageUrl!,
                  fit: BoxFit.cover, width: double.infinity,
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
                            height: double.infinity),
                      ); // Replace with your LoadingWidget
                    }
                  }),
            ),
          ),
        ],
      ),
    ))
        .toList();
    double splitPrice = feed.fee!.toDouble() / (feed.feedsJoin!.length + 1);
    List<UserFollowing> splitUsers = [UserFollowing(name: feed.user!.name, id: feed.userId, status: 'joined')];
    for(var user in feed.feedsJoin!){
      splitUsers.add(UserFollowing(
          status: user.status,
          name: StaticData.users.firstWhere((element) => element.id == user.userId!).name,
          id: user.userId));
    }

    Widget titleAndLocationTrip() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          Container(
            width: Get.size.width * 0.8,
            child: Text(
              feed.title!,
              style: primaryTextStylePlusJakartaSans.copyWith(
                  fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
              overflow: TextOverflow.fade,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_pin,
                color: Colors.blue,
              ),
              Container(
                width: Get.size.width * 0.6,
                child: Text(
                  feed.location!,
                  overflow: TextOverflow.fade,
                  style: primaryTextStylePlusJakartaSans.copyWith(fontSize: 14),
                ),
              )
            ],
          ),
        ],
      );
    }

    Widget buttonJoin() {
      return ElevatedButton(
        onPressed: () {

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
              "Join",
              style: buttonPrimaryTextStyle.copyWith(
                  fontSize: 22, fontWeight: semibold),
            ),
          ],
        ),
      );
    }

    Widget buttonSendRequest() {
      return Expanded(
        child: ElevatedButton(
          onPressed: () {

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
                "Request to Join",
                style: buttonPrimaryTextStyle.copyWith(
                    fontSize: 22, fontWeight: semibold),
              ),
            ],
          ),
        ),
      );
    }

    Widget buttonReject() {
      return ElevatedButton(
        onPressed: () {

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
          MaterialStateProperty.all<Color>(Colors.redAccent),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Reject",
              style: buttonPrimaryTextStyle.copyWith(
                  fontSize: 22, fontWeight: semibold),
            ),
          ],
        ),
      );
    }

    Widget reviewSummary(){
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,  // Warna bayangan
                  offset: Offset(0, 2),  // Geser bayangan pada sumbu X dan Y
                  blurRadius: 9.0,  // Besarnya blur pada bayangan
                  spreadRadius: 1.0,  // Seberapa tersebar bayangan
                ),
              ],
              color: containerPostColor
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Split Breakdown', style: primaryTextStylePlusJakartaSans.copyWith(
                  fontSize: 14, fontWeight: medium
              ),),
              const SizedBox(height: 10,),
              Column(
                children: splitUsers.map((e) => Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '${e.name}',
                          style: primaryTextStylePlusJakartaSans.copyWith(
                            fontSize: 14,
                            fontWeight: medium,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'Rp ${formatNumber(splitPrice)}',
                          style: primaryTextStylePlusJakartaSans.copyWith(
                            fontSize: 14,
                            fontWeight: medium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5,),
                  ],
                )).toList(),
              )
            ],
          )
      );
    }

    Widget totalPrice(){
      return Container(
        margin: EdgeInsets.only(bottom: 50, top: 20, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total", style: primaryTextStylePlusJakartaSans.copyWith(
              fontWeight: FontWeight.bold, fontSize: 16
            ),),
            const SizedBox(height: 10,),
            Center(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 45, vertical: 13),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,  // Warna bayangan
                        offset: Offset(0, 2),  // Geser bayangan pada sumbu X dan Y
                        blurRadius: 9.0,  // Besarnya blur pada bayangan
                        spreadRadius: 1.0,  // Seberapa tersebar bayangan
                      ),
                    ],
                    color: containerPostColor
                ),
                child: Center(
                  child: Text('Rp ${formatNumber(feed.fee!.toDouble())}', style: primaryTextStylePlusJakartaSans.copyWith(
                      fontWeight: FontWeight.bold, fontSize: 25
                  ),),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget dateAndTitle() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "${formatDate(feed.dateStart!)} - ${formatDate(feed.dateEnd!)}",
            style: primaryTextStylePlusJakartaSans.copyWith(fontSize: 14),
          ),
          const SizedBox(
            height: 2,
          ),
          titleAndLocationTrip()
        ],
      );
    }

    Widget desription() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 8,
          ),
          Text(
           "Description",
            style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.5),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            feed?.description ?? '',
            style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 14,
                fontWeight: medium,
                color: textSecondaryColor,
                height: 1.5),
            textAlign: TextAlign.justify,
          ),
        ],
      );
    }

    Widget details(){
      print(feed.others!.runtimeType);
      List<Map<String, dynamic>> mapList = jsonDecode(feed.others!).cast<Map<String, dynamic>>();

      print(mapList[0]['value']);

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: mapList.map((e) =>
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(e['text'], style: primaryTextStylePlusJakartaSans.copyWith(
                  fontSize: 14,
                ),),
                Text(e['value'], style: primaryTextStylePlusJakartaSans.copyWith(
                  fontSize: 14,
                ),)
              ],
            )
          ).toList(),
        ),
      );
    }

    Widget detailsAndReviewSummary(){
      return Obx(
          () => Container(
          margin: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Divider(thickness: 1, color: textButtonSecondaryColor,),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.onClickDetail();
                        },
                        child: Text("Details", style: primaryTextStylePlusJakartaSans.copyWith(
                          fontWeight: controller.details.value ? FontWeight.bold : FontWeight.normal, fontSize: 16
                        ),),
                      ),
                      const SizedBox(height: 5,),
                      CircleAvatar(backgroundColor: controller.details.value ? textButtonSecondaryColor : Colors.transparent, radius: 3,),
                    ],
                  ),
                  const SizedBox(width: 20,),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => controller.onClickReview(),
                        child: Text("Review Summary", style: primaryTextStylePlusJakartaSans.copyWith(
                            fontWeight: controller.review.value ? FontWeight.bold : FontWeight.normal, fontSize: 16
                        ),),
                      ),
                      const SizedBox(height: 5,),
                      CircleAvatar(backgroundColor: controller.review.value ? textButtonSecondaryColor : Colors.transparent, radius: 3,),
                    ],
                  ),
                ],
              ),

              controller.details.value ? details() : reviewSummary(),
            ],
          ),
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
            iconTheme: IconThemeData(color: textPrimaryColor),
            title: Text("Share Cost"),
            titleTextStyle: TextStyle(
                fontWeight: semibold, color: textPrimaryColor, fontSize: 16),
            centerTitle: true,
            toolbarHeight: kToolbarHeight + 15,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FeedsCarousel(images),
              dateAndTitle(),
              desription(),
              detailsAndReviewSummary(),
              totalPrice(),
              StaticData.box.read('user')['id'] == feed.userId ? Container() :
              splitUsers.any((element) => element.id != StaticData.box.read('user')['id'] && element.status == 'request')
                  ? buttonSendRequest()
                  : Row(
                    children: [
                      Expanded(child: buttonJoin()),
                      const SizedBox(width: 10,),
                      Expanded(child: buttonReject())
                    ],
                  ),
              const SizedBox(height: 30,),
            ],
          ),
        ),
      )
    );
  }
}
