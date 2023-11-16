import 'package:clipboard/clipboard.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tripusfrontend/app/controllers/home_page_controller.dart';
import 'package:tripusfrontend/app/data/models/feeds_home_model.dart';
import 'package:tripusfrontend/app/data/static_data.dart';
import 'package:tripusfrontend/app/helpers/avatar_custom.dart';
import 'package:tripusfrontend/app/helpers/format_datetime.dart';
import 'package:tripusfrontend/app/helpers/loading_widget.dart';
import 'package:tripusfrontend/app/modules/history_transaction/views/widget/content.dart';
import 'package:tripusfrontend/app/routes/app_pages.dart';

import '../../../controllers/order_controller.dart';
import '../../../controllers/order_controller.dart';
import '../../../controllers/order_controller.dart';
import '../../../controllers/withdraw_controller.dart';
import '../../../data/models/orders_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/withdraw_model.dart';
import '../../../helpers/theme.dart';
import '../controllers/history_transaction_controller.dart';

class HistoryTransactionView extends StatefulWidget {
  const HistoryTransactionView({Key? key}) : super(key: key);

  @override
  State<HistoryTransactionView> createState() => _HistoryTransactionViewState();
}

class _HistoryTransactionViewState extends State<HistoryTransactionView> {
  var formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );
  List<FeedsHome> feeds =  StaticData.feeds.where((e) => e.type == 'open trip').where((element) => element.userId == StaticData.box.read('user')['id']).toList();
  List<Withdraw> withdraws = StaticData.withdraws;

  RefreshController refreshC = RefreshController();

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => OrderController());
    Get.lazyPut(() => HomePageController());
    Get.lazyPut(() => WithdrawController());
  }


  void refreshData() async {
    try {
      print("refresh");
      await Future.delayed(Duration(seconds: 1));
      StaticData.feeds.clear();
      await initData();
      setState(() {
        feeds =  StaticData.feeds.where((e) => e.type == 'open trip').where((element) => element.userId == StaticData.box.read('user')['id']).toList();
      });
      refreshC.refreshCompleted();
    } catch (e) {
      refreshC.refreshFailed();
    }
  }

  Future initData() async {
    await Get.find<OrderController>().getOrdersByEmail();
    await Get.find<OrderController>().getOrdersByAgent();
    await Get.find<HomePageController>().getData();
    await Get.find<WithdrawController>().getAllWithdraw();
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
    print('feeds: ${feeds.length}');
    User user = User.fromJson(StaticData.box.read('user'));
    List<Orders> orders = StaticData.orders;
    var orderController = Get.find<OrderController>();
    // print("StaticData.orders hist: ${orders.length}");

    handleCancelPayment(String orderId) {
      print('cancel');
      showDialog(
        context: context, // Pastikan Anda memiliki akses ke BuildContext
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  20.0), // Radius yang Anda inginkan
            ),
            child: Container(
              height: 300,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.warning_rounded, color: Colors.red, size: 30,),
                      SizedBox(width: Get.size.width * 0.25,),
                      IconButton(
                          onPressed: () => Get.back(),
                          splashRadius: 25,
                          icon: SvgPicture.asset('assets/icon_close.svg')
                      )
                    ],
                  ),
                  SizedBox(height: 15,),
                  Text("Warning !", style: primaryTextStyle.copyWith(
                      fontSize: 20,
                      color: Colors.red,
                      fontWeight: FontWeight.bold
                  ),),
                  SizedBox(height: 24,),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 22, right: 22, top: 7, bottom: 17),
                    child: Text(
                      "It will be impossible to undo this action. Do you want to continue?",
                      style: primaryTextStylePlusJakartaSans.copyWith(
                          fontSize: 14,
                          fontWeight: semibold,
                          overflow: TextOverflow.fade
                      ), textAlign: TextAlign.justify,),
                  ),
                  SizedBox(height: 24,),
                  Container(
                    width: 200,
                    child: GetBuilder<OrderController>(builder: (orderController) {
                      return orderController.status.isLoading ? Center(child: LoadingWidget()) :
                      ElevatedButton(
                          onPressed: () async {
                            await Get.find<OrderController>()
                                .cancelPayment(orderId)
                                .then((value) => {
                                  refreshData(),
                                  Get.back(),
                                  Get.back()
                                });
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Set the desired border radius
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.red),
                          ),
                          child: Center(
                            child: Text(
                              "Yes, Cancel",
                              style: buttonPrimaryTextStyle.copyWith(
                                  fontSize: 16, fontWeight: semibold),
                            ),
                          )
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    Widget profile() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            user.name!,
            style: primaryTextStylePlusJakartaSans.copyWith(
                color: Colors.white, fontSize: 16),
          ),
          user.profilePhotoPath == null
              ? AvatarCustom(
            name: user.name!,
            width: 30,
            height: 30,
            color: Colors.blue,
            fontSize: 30,
            radius: 30,
            backgroundColor: Colors.white,
          )
              : CircleAvatar(
            radius: 30, // Setengah dari lebar atau tinggi gambar
            backgroundImage: NetworkImage(
              urlImage + user.profilePhotoPath!,
            ),
          ),
        ],
      );
    }

    Widget contentSeeDetail(String title, String value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15,
          ),
          Text(
            title,
            style: primaryTextStylePlusJakartaSans.copyWith(
              fontSize: 12,
              overflow: TextOverflow.fade,
              color: textHintColor,
            ),
            textAlign: TextAlign.justify,
          ),
          Text(
            value,
            style: primaryTextStylePlusJakartaSans.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                overflow: TextOverflow.fade,
                color: value == "Success"
                    ? Colors.green
                    : value == "Pending"
                    ? Colors.orangeAccent
                    : value == "Cancel"
                    ? Colors.red
                    : Colors.black),
            textAlign: TextAlign.justify,
          ),
        ],
      );
    }

    Widget seeDetails(Orders order) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                          splashRadius: 15,
                          onPressed: () => Get.back(),
                          icon: SvgPicture.asset(
                            'assets/icon_close.svg',
                            width: 30,
                            height: 30,
                            color: textButtonSecondaryColor,
                          )),
                      Spacer(),
                      SvgPicture.asset('assets/logo.svg', width: 30, height: 30)
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TITLE TRIP
                      Text(
                        order.feeds?.title ?? '',
                        style: primaryTextStylePlusJakartaSans.copyWith(
                            fontWeight: semibold, fontSize: 20),
                      ),
                      // TRIP AGENT NAME
                      Text(
                        order.feeds?.location ?? '',
                        style: primaryTextStylePlusJakartaSans.copyWith(
                            fontSize: 12),
                        overflow: TextOverflow.fade,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            color: Colors.green,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${formatDateNum(
                                order.feeds!.dateStart!)} - ${formatDateNum(
                                order.feeds!.dateEnd!)}",
                            style: primaryTextStylePlusJakartaSans.copyWith(
                              fontSize: 14,
                              overflow: TextOverflow.fade,
                              color: textSecondaryColor,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            color: Colors.green,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Open Trip',
                            style: primaryTextStylePlusJakartaSans.copyWith(
                              fontSize: 14,
                              overflow: TextOverflow.fade,
                              color: textSecondaryColor,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        order.feeds!.agentName!,
                        style: primaryTextStylePlusJakartaSans.copyWith(
                          fontSize: 14,
                          overflow: TextOverflow.fade,
                          color: textSecondaryColor,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                  contentSeeDetail('Order Name', user.name!),
                  contentSeeDetail(
                      'Quantity', "${order.qty.toString()} tickets"),
                  contentSeeDetail('Transaction Date',
                      "${formatDate(order.createdAt!)} ${order.createdAt!
                          .substring(10, 16)}"),
                  order.status == 'pending' || order.status == 'Expired' ?
                  contentSeeDetail('Expired payment date',
                      "${formatDate(order.expireTime!)} ${order.updatedAt!
                          .substring(10, 16)}")
                      : order.status == 'success' ?
                  contentSeeDetail('Paid Date',
                      "${formatDate(order.updatedAt!)} ${order.updatedAt!
                          .substring(10, 16)}")
                      : contentSeeDetail('Cancelled Date',
                      "${formatDate(order.updatedAt!)} ${order.updatedAt!
                          .substring(10, 16)}"),
                  contentSeeDetail(
                      'Transaction Status',
                      order.status![0].toUpperCase() +
                          order.status!.substring(1)),
                ],
              ),
            ),
            DottedDashedLine(
              height: 0,
              width: double.infinity,
              axis: Axis.horizontal,
              dashColor: textHintColor,
            ),
            Padding(
                padding:
                EdgeInsets.only(left: 22, right: 13, top: 7, bottom: 17),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Details',
                        style: primaryTextStylePlusJakartaSans.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Column(
                          children: [
                            Row(children: [
                              Text(
                                'Ticket Trip',
                                style: primaryTextStylePlusJakartaSans.copyWith(
                                    fontSize: 12,
                                    color: textHintColor,
                                    fontWeight: semibold),
                              ),
                              const Spacer(),
                              Container(
                                width: 140,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Rp ',
                                      style: primaryTextStylePlusJakartaSans
                                          .copyWith(
                                          fontSize: 12,
                                          color: textHintColor,
                                          fontWeight: semibold),
                                    ),
                                    Text(
                                      '${formatter.format(order.fee)
                                          .toString()}  x  ${order.qty}',
                                      style: primaryTextStylePlusJakartaSans
                                          .copyWith(
                                          fontSize: 12,
                                          color: textHintColor,
                                          fontWeight: semibold),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                            Row(children: [
                              Text(
                                'Admin',
                                style: primaryTextStylePlusJakartaSans.copyWith(
                                    fontSize: 12,
                                    color: textHintColor,
                                    fontWeight: semibold),
                              ),
                              Spacer(),
                              Container(
                                width: 140,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Rp ',
                                      style: primaryTextStylePlusJakartaSans
                                          .copyWith(
                                          fontSize: 12,
                                          color: textHintColor,
                                          fontWeight: semibold),
                                    ),
                                    Text(
                                      '6.000',
                                      style: primaryTextStylePlusJakartaSans
                                          .copyWith(
                                          fontSize: 12,
                                          color: textHintColor,
                                          fontWeight: semibold),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total',
                                    style: primaryTextStylePlusJakartaSans
                                        .copyWith(
                                        fontSize: 12,
                                        fontWeight: semibold,
                                        color: textHintColor),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Rp ',
                                        style:
                                        primaryTextStylePlusJakartaSans
                                            .copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        formatter.format(order.totalPrice)
                                            .toString(),
                                        style:
                                        primaryTextStylePlusJakartaSans
                                            .copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.fade,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ],
                                  )
                                ])
                          ],
                        ),
                      ),

                    ])),
            DottedDashedLine(
              height: 0,
              width: double.infinity,
              axis: Axis.horizontal,
              dashColor: textHintColor,
            ),
            Padding(
              padding: EdgeInsets.only(left: 22, right: 13, top: 7, bottom: 17),
              child: Row(
                  children: [
                    order.status != 'pending' ? Container() :
                    ElevatedButton(
                      onPressed: () => handleCancelPayment(order.id!),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Set the desired border radius
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.red),
                      ),
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: buttonPrimaryTextStyle.copyWith(
                              fontSize: 16, fontWeight: semibold),
                        ),
                      ),
                    ),
                    Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              order.bank == 'BCA'
                                  ? 'assets/payment/logo_bca.png'
                                  :
                              order.bank == 'BNI'
                                  ? 'assets/payment/logo_bni.png'
                                  :
                              'assets/payment/logo_mandiri.png',
                              width: 30, height: 30,),
                            SizedBox(width: 5,),
                            Text(
                              order.bank == 'BCA' ? 'Bank BCA' :
                              order.bank == 'BNI' ? 'Bank BNI' : 'Bank Mandiri',
                              style: primaryTextStylePlusJakartaSans.copyWith(
                                  fontWeight: semibold, fontSize: 12
                              ),
                            )
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            FlutterClipboard.copy(order.vaNumber!).then((
                                value) =>
                                Get.snackbar('Copied', ""));
                          },
                          child: Row(
                            children: [
                              Icon(Icons.copy_all_rounded),
                              SizedBox(width: 5,),
                              Text(
                                order.vaNumber!,
                                style: primaryTextStylePlusJakartaSans.copyWith(
                                    fontWeight: semibold, fontSize: 16
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ]
              ),
            ),
          ],
        ),
      );
    }

    Widget buttonSeeDetails(Orders order) {
      return Container(
        width: 115,
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context, // Pastikan Anda memiliki akses ke BuildContext
              builder: (BuildContext context) {
                return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20.0), // Radius yang Anda inginkan
                    ),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/background_history.png', fit: BoxFit.fill,
                          height: Get.size.height,),
                        seeDetails(order),
                      ],
                    )

                );
              },
            );
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 25), // Set the desired padding values
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(10), // Set the desired border radius
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          child: Text(
            "See Details",
            style: buttonPrimaryTextStyle.copyWith(
                fontSize: 11, fontWeight: semibold, color: textHintColor),
          ),
        ),
      );
    }

    Widget buttonRating() {
      return Container(
        width: 115,
        child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 25), // Set the desired padding values
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(10), // Set the desired border radius
              ),
            ),
            backgroundColor:
            MaterialStateProperty.all<Color>(Colors.orangeAccent),
          ),
          child: Text(
            "Rate Agent",
            style: buttonPrimaryTextStyle.copyWith(
                fontSize: 11, fontWeight: semibold, color: Colors.white),
          ),
        ),
      );
    }

    Widget content(Orders order) {
      // print(order.feeds!.agentName);
      return Container(
        margin: EdgeInsets.only(bottom: 20, left: 20),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: textButtonSecondaryColor)),
        child: Column(
          children: [
            // HEADER CONTENT
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                order.status == 'pending'
                    ? Image.asset(
                  'assets/icon_flat.png',
                  width: 40,
                  height: 40,
                  color: Colors.orangeAccent,
                )
                    : order.status == 'success'
                    ? Image.asset(
                  'assets/icon_smile.png',
                  width: 40,
                  height: 40,
                  color: Colors.green,
                )
                    : order.status == 'cancel'
                    ? Image.asset(
                  'assets/icon_frown.png',
                  width: 40,
                  height: 40,
                  color: Colors.red,
                )
                    : Image.asset(
                  'assets/icon_frown.png',
                  width: 40,
                  height: 40,
                  color: Colors.black38,
                ),
                SizedBox(
                  width: 9,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TITLE TRIP
                      Text(
                        order.feeds?.title ?? '',
                        style: primaryTextStylePlusJakartaSans.copyWith(
                            fontWeight: semibold, fontSize: 16),
                      ),
                      // TRIP AGENT NAME
                      Text(
                        order.feeds?.agentName ?? '',
                        style: primaryTextStylePlusJakartaSans.copyWith(
                            fontSize: 12),
                        overflow: TextOverflow.fade,
                      )
                    ],
                  ),
                ),
                // buttonRating()
              ],
            ),
            // FEE CONTENT
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child:
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                // TRIP FEE
                Container(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp ',
                        style: primaryTextStylePlusJakartaSans.copyWith(
                            fontSize: 16,
                            color: textButtonSecondaryColor,
                            fontWeight: semibold),
                      ),
                      Text(
                        formatter.format(order.totalPrice).toString(),
                        style: primaryTextStylePlusJakartaSans.copyWith(
                            fontSize: 16,
                            color: textButtonSecondaryColor,
                            fontWeight: semibold),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                buttonSeeDetails(order)
              ]),
            ),
            SizedBox(
              height: 15,
            ),
            Divider(
              thickness: 1,
              height: 1,
              color: textButtonSecondaryColor,
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                order.status == 'pending'
                    ? Text(
                  "Pending",
                  style: primaryTextStylePlusJakartaSans.copyWith(
                      fontSize: 12,
                      color: Colors.orangeAccent,
                      fontWeight: semibold),
                )
                    : order.status == 'success'
                    ? Text(
                  "Success",
                  style: primaryTextStylePlusJakartaSans.copyWith(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: semibold),
                )
                    : order.status == 'cancel'
                    ? Text(
                  "Cancel",
                  style: primaryTextStylePlusJakartaSans.copyWith(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: semibold),
                )
                    : Text(
                  "Expired",
                  style: primaryTextStylePlusJakartaSans.copyWith(
                      fontSize: 12,
                      color: Colors.black38,
                      fontWeight: semibold),
                ),
                Spacer(),
                Text(
                  formatDate(order.createdAt!).toString(),
                  style: primaryTextStylePlusJakartaSans.copyWith(
                    fontSize: 12,
                    color: textHintColor,
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    Widget header() {
      return Container(
        margin: EdgeInsets.only(left: 0, right: 20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => Get.toNamed(Routes.HOME),
                      splashRadius: 25,
                      icon: SvgPicture.asset(
                        'assets/icon_home.svg',
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Home',
                      style: primaryTextStylePlusJakartaSans.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 38),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "HISTORY",
                      style: primaryTextStylePlusJakartaSans.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(1, 2), // Mengatur offset bayangan
                            blurRadius: 1, // Mengatur intensitas blur
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "TRANSACTION",
                      style: primaryTextStylePlusJakartaSans.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(1, 2), // Mengatur offset bayangan
                            blurRadius: 1, // Mengatur intensitas blur
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              profile(),
              SizedBox(
                height: 50,
              ),
              StaticData.box.read('user')['role'] == 'open trip' ? ContentWidget(feeds: feeds, withdraws: withdraws, refreshData: refreshData,) :
              Column(
                children: orders.map((e) => content(e)).toList(),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
        body: SmartRefresher(
          controller: refreshC,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: refreshData,
          footer: CustomFooter(
            builder: (context, mode) {
              if (mode == LoadStatus.idle) {
                return Center(child: Text("Load more"));
              } else if (mode == LoadStatus.loading) {
                return Center(
                  child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CupertinoActivityIndicator()),
                );
              } else if (mode == LoadStatus.failed) {
                return Center(child: Text("Load Failed!Click retry!"));
              } else if (mode == LoadStatus.canLoading) {
                return Center(child: Text("release to load more"));
              } else {
                return Center();
              }
            },
          ),
          onLoading: loadData,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 290,
                  decoration: BoxDecoration(
                      color: textButtonSecondaryColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                ),
                header(),
              ],
            ),
          ),
        ));
  }
}
