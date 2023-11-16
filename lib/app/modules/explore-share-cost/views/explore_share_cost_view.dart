import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tripusfrontend/app/modules/mainPage/views/main_page_view.dart';

import '../../../helpers/avatar_custom.dart';
import '../../../helpers/format_datetime.dart';
import '../../../helpers/theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/explore_share_cost_controller.dart';

class ExploreShareCostView extends GetView<ExploreShareCostController> {
  const ExploreShareCostView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Widget wishlist() {
      return Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "History",
                    style: primaryTextStylePlusJakartaSans.copyWith(
                        fontSize: 16, fontWeight: semibold),
                  ),
                  Text(
                    "See all",
                    style: primaryTextStylePlusJakartaSans.copyWith(
                        color: textHintColor,
                        fontSize: 14,
                        fontWeight: semibold),
                  ),
                ]),
          ),
          Container(
            height: 200,
            child: controller.shareCostFeeds.isNotEmpty
                ? ListView(
                scrollDirection: Axis.horizontal,
                children: controller.historyShareCostFeeds
                    .map((e) => GestureDetector(
                  onTap: () => Get.toNamed(Routes.FEED_DETAIL,
                      parameters: {'id': e.id.toString()}),
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                          urlImage + e.feedImage!.first.imageUrl!,
                          fit: BoxFit.cover,
                          width: 150,
                          loadingBuilder: (BuildContext context,
                              Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              // Image is fully loaded
                              return child;
                            } else {
                              // Image is still loading, show a loading widget
                              return SkeletonAvatar(
                                style: SkeletonAvatarStyle(
                                  width: 150,
                                ),
                              ); // Replace with your LoadingWidget
                            }
                          }),
                    ),
                  ),
                ))
                    .toList())
                : Container(),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Divider(
              thickness: 1,
              height: 1,
              color: textButtonSecondaryColor,
            ),
          ),
        ],
      );
    }

    Widget buttonSeeDetails(int id) {
      return Container(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () =>
              Get.toNamed(Routes.SHARE_COST_POST_DETAIL, parameters: {'id': id.toString()}),
          style: ElevatedButton.styleFrom(
            primary: Colors.white70, // Warna latar belakang
            padding:
            EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(10.0), // Radius yang Anda inginkan
            ),
          ),
          child: Text(
            'See Details',
            style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 12, fontWeight: semibold),
          ),
        ),
      );
    }

    Widget contentFeeds() {
      return Column(
          children: controller.shareCostFeeds
              .map((e) => Container(
              child: Padding(
                padding:
                const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                              urlImage + e.feedImage!.first.imageUrl!,
                              fit: BoxFit.cover,
                              width: 150,
                              height: 200, loadingBuilder:
                              (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              // Image is fully loaded
                              return child;
                            } else {
                              // Image is still loading, show a loading widget
                              return SkeletonAvatar(
                                style: SkeletonAvatarStyle(
                                    width: 150, height: 200),
                              ); // Replace with your LoadingWidget
                            }
                          }),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.description!,
                                style: primaryTextStylePlusJakartaSans
                                    .copyWith(
                                    fontSize: 13,
                                    fontWeight: medium,
                                    color: textSecondaryColor,
                                    overflow: TextOverflow.ellipsis),
                                maxLines: 3,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "${formatDate(e.dateStart!)} - ${formatDate(e.dateEnd!)}",
                                style: primaryTextStylePlusJakartaSans
                                    .copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis),
                                maxLines: 2,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Rp ${controller.formatter.format(e.fee!)}/Person",
                                style: primaryTextStylePlusJakartaSans
                                    .copyWith(
                                    fontSize: 10,
                                    overflow: TextOverflow.ellipsis),
                                maxLines: 2,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              buttonSeeDetails(e.id!)
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        e.user!.profilePhotoPath == null
                            ? Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Get.toNamed(Routes.MAIN_PROFILE,
                                    parameters: {
                                      'id': e.user!.id.toString()
                                    });
                              },
                              icon: AvatarCustom(
                                radius: 20,
                                name: e.user!.name!,
                                width: 40,
                                height: 10,
                                fontSize: 16,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            )
                          ],
                        )
                            : IconButton(
                          onPressed: () => Get.toNamed(
                              Routes.MAIN_PROFILE,
                              parameters: {
                                'id': e.user!.id.toString()
                              }),
                          icon: CircleAvatar(
                            radius:
                            50, // Set the radius to control the size of the circle
                            backgroundImage: NetworkImage(
                                urlImage + e.user!.profilePhotoPath!),
                          ),
                        ),
                        Text(
                          e.user!.name!,
                          style: primaryTextStylePlusJakartaSans.copyWith(
                              fontWeight: semibold, fontSize: 12),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      thickness: 1,
                      height: 1,
                      color: textButtonSecondaryColor,
                    ),
                  ],
                ),
              )))
              .toList());
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
            leading: IconButton(
              splashRadius: 25,
              icon: Icon(Icons.arrow_back, color: textPrimaryColor),
              onPressed: () => Get.to(() => MainPageView()),
            ),
            title: Text("Share Cost"),
            titleTextStyle: TextStyle(
                fontWeight: semibold, color: textPrimaryColor, fontSize: 16),
            centerTitle: true,
            toolbarHeight: kToolbarHeight + 15,
          ),
        ),
      ),
      body: Obx(
          () {
            return SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                        child: Column(
                          children: [
                            wishlist(),
                            contentFeeds(),
                            SizedBox(
                              height: Get.size.height * 0.15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
      )
    );
  }
}
