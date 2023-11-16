import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tripusfrontend/app/controllers/home_page_controller.dart';
import 'package:tripusfrontend/app/helpers/custom_refresh.dart';
import 'package:tripusfrontend/app/modules/explore-share-cost/controllers/explore_share_cost_controller.dart';
import 'package:tripusfrontend/app/modules/home/views/post_feeds_view.dart';
import 'package:tripusfrontend/app/modules/home/views/share_cost_view.dart';
import 'package:tripusfrontend/app/modules/home/views/widget/feeds_widget.dart';

import '../../../controllers/user_auth_controller.dart';
import '../../../data/static_data.dart';
import '../../../helpers/avatar_custom.dart';
import '../../../helpers/loading_widget.dart';
import '../../../helpers/theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final box = GetStorage().read('user');
  RefreshController refreshC = RefreshController();
  var homePageController = Get.find<HomePageController>();

  @override
  void initState(){
    super.initState();
    Get.lazyPut<ExploreShareCostController>(
          () => ExploreShareCostController(),
    );
    homePageController = Get.find<HomePageController>();
    refreshData();
  }

  void refreshData() async {
    try {
      await Future.delayed(Duration(seconds: 1));
      StaticData.feeds.clear();
      await initData();
      setState(() {});
      refreshC.refreshCompleted();
    } catch (e) {
      refreshC.refreshFailed();
    }
  }

  Future initData() async {
    await homePageController.getData();
  }

  void loadData() async {
    try {
      if (StaticData.feeds.length >= StaticData.feeds.length+1) {
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
    log("data feeds home: ${StaticData.feeds.length}");
    Widget category() {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // OPEN TRIP
            Expanded(
              child: ElevatedButton(
                onPressed: () => Get.toNamed(Routes.EXPLORE),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(
                        vertical: 7,
                        horizontal: 14), // Set the desired padding values
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8), // Set the desired border radius
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      textButtonSecondaryColor),
                ),
                child: Text(
                  "Open Trip",
                  style: buttonPrimaryTextStyle.copyWith(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(
              width: 10,
            ),

            // SHARE COST
            Expanded(
              child: ElevatedButton(
                onPressed: () => Get.toNamed(Routes.EXPLORE_SHARE_COST),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(
                        vertical: 7,
                        horizontal: 14), // Set the desired padding values
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8), // Set the desired border radius
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      textButtonSecondaryColor),
                ),
                child: Text(
                  "Share Cost",
                  style: buttonPrimaryTextStyle.copyWith(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget typePostUser() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => Get.to(() => PostFeedsView(
                  typePost: 'feeds',
                )),
            child: Text(
              'Feeds',
              style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Get.to(() => PostShareCostView()),
            child: Text(
              'Share Cost',
              style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }

    Widget typePostOpenTrip() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              log(box['payment_account'].toString());
              if(box['status'] == 'accept'){
                if(GetStorage().read('payment_account') != null){
                  Get.back();
                  Get.to(() => PostFeedsView(
                    typePost: 'open trip',
                  ));
                }else {
                  Get.defaultDialog(
                      title: 'Alert',
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      content:Text.rich(
                        TextSpan(
                          text: 'Sorry, you haven\'t added your payment account. ',
                          style: primaryTextStylePlusJakartaSans.copyWith(fontSize: 15),
                          children: [
                            TextSpan(
                              text: '\n\n Please add it to ',
                              style: TextStyle(fontWeight: FontWeight.bold), // Atur gaya teks sesuai kebutuhan
                            ),
                            TextSpan(
                              text: '\n profile -> settings -> payment account',
                              style: TextStyle(
                                fontStyle: FontStyle.italic, // Atur gaya teks sesuai kebutuhan
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.justify,
                      ),
                  );
                }
              }else{
                Get.defaultDialog(
                  title: 'Alert',
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  content: Text("Sorry, you can't post an open trip yet because your approval letter is still in the review stage.",
                    style: primaryTextStylePlusJakartaSans.copyWith(
                      fontSize: 15
                    ),
                    textAlign: TextAlign.justify,
                  )
                );
              }

            },
            child: Row(
              children: [
                Text(
                  'Open Trip',
                  style: primaryTextStylePlusJakartaSans.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ),
          GestureDetector(
            onTap: () {
              Get.back();
              Get.to(() => PostFeedsView(
                    typePost: 'feeds',
                  ));
            },
            child: Text(
              'Feed Photo',
              style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }

    Widget typePost() {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(64),
              topLeft: Radius.circular(64),
            ),
            color: Colors.white),
        height: 100,
        child: Column(
          children: [
            Text(
              'Choose Type Post',
              style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            StaticData.box.read('user')['role'] == "user"
                ? typePostUser()
                : typePostOpenTrip(),
          ],
        ),
      );
    }

    return GestureDetector(
      onVerticalDragEnd: (_result) => print('drag'),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: CustomRefresh(
            refreshController: refreshC,
            refreshData: refreshData,
            loadData: loadData,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  elevation: 1,
                  backgroundColor: backgroundColor,
                  title: SvgPicture.asset('assets/logo.svg'),
                  flexibleSpace: Container(
                      margin: EdgeInsets.only(left: 24, right: 24, top: 60),
                      child: category()),
                  actions: [
                    IconButton(
                      onPressed: () => Get.bottomSheet(typePost()),
                      icon: Image.asset('assets/icon_plus.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 24),
                      child: box['profile_photo_path'] == null
                          ? IconButton(
                              onPressed: () {
                                Get.toNamed(Routes.MAIN_PROFILE,
                                    parameters: {'id': box['id'].toString()});
                              },
                              icon: AvatarCustom(
                                name: box['name'],
                                width: 40,
                                height: 10,
                                fontSize: 16,
                                radius: 20,
                                color: Colors.white,
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                Get.toNamed(Routes.MAIN_PROFILE,
                                    parameters: {'id': box['id'].toString()});
                              },
                              icon: CircleAvatar(
                                radius:
                                    50, // Set the radius to control the size of the circle
                                backgroundImage: NetworkImage(
                                    urlImage + box['profile_photo_path']),
                              ),
                            ),
                    ),
                  ],
                  expandedHeight: kToolbarHeight + 60,
                  floating: true,
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.transparent,
                    margin: EdgeInsets.only(left: 24, right: 24),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                            itemCount: StaticData.feeds.where((feed) => feed.type == 'feed').length,
                          itemBuilder: (context, index) => FeedsWidget(feeds: StaticData.feeds.where((feed) => feed.type == 'feed').toList()[index],),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
