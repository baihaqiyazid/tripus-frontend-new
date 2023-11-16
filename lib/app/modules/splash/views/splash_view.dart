import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tripusfrontend/app/controllers/withdraw_controller.dart';
import 'package:tripusfrontend/app/modules/explore-share-cost/controllers/explore_share_cost_controller.dart';
import 'package:tripusfrontend/app/routes/app_pages.dart';

import '../../../controllers/follow_controller.dart';
import '../../../controllers/home_page_controller.dart';
import '../../../controllers/order_controller.dart';
import '../../../controllers/user_auth_controller.dart';
import '../../landing/views/landing_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>{

  // var orderController = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => UserAuthController());
    Get.lazyPut(() => HomePageController());
    Get.lazyPut(() => OrderController());
    Get.lazyPut(() => FollowController());
    Get.lazyPut(() => WithdrawController());
    Get.lazyPut(() => ExploreShareCostController());
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration(seconds: 2), () {
    //   GetStorage().erase();
    //   print("read storage ${GetStorage().read('user').runtimeType}");
    //
    // });
    Future.delayed(Duration.zero, () async {
      await Get.find<HomePageController>().getData();
      await Get.find<UserAuthController>().getAllUsers();
      await Get.find<FollowController>().getData();
      await Get.find<WithdrawController>().getAllWithdraw();
      await Get.find<ExploreShareCostController>().getDataShareCost();

      // log("user: ${GetStorage().read('user')}");

      if (GetStorage().read('user') != null) {
        await Get.find<UserAuthController>().getAllPaymentAccountUsers();
        await Get.find<OrderController>().getOrdersByEmail().then((value) => Get.offNamed(Routes.HOME));

      } else {
        Get.to(() => LandingView());
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: Get.size.height,
            child: Align(
              alignment: Alignment.center,
              child: SvgPicture.asset('assets/logo.svg'),
            ),
          ),
        ),
      ),
    );
  }
}
