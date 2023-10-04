import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:nanoid/async.dart';
import 'package:tripusfrontend/app/controllers/order_controller.dart';
import 'package:tripusfrontend/app/helpers/loading_widget.dart';
import 'package:tripusfrontend/app/helpers/theme.dart';

import '../../../data/models/feeds_home_model.dart';
import '../../../helpers/format_datetime.dart';
import '../../../routes/app_pages.dart';
import '../../payment-account/widget/radio_list_widget.dart';
import '../controllers/book_ticket_controller.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';

class BookTicketView extends StatefulWidget {
  FeedsHome? feed;
  int? person;

  BookTicketView(this.feed, this.person);

  @override
  State<BookTicketView> createState() => _BookTicketViewState();
}

class _BookTicketViewState extends State<BookTicketView> {
  bool isChecked = false;

  var formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );
  double admin = 6000;

  String paymentAccountValue = '';

  void handlePaymentValue(String value) {
    // Do something with the selected category in this class
    setState(() {
      paymentAccountValue = value;
    });
    print("paymentAccount set: ${paymentAccountValue}");
  }

  var user = GetStorage().read('user');

  @override
  void initState() {
    Get.lazyPut(() => OrderController());
  }

  @override
  Widget build(BuildContext context) {
    print("address get: ${user}");
    var controller = Get.find<OrderController>();
    print(widget.feed?.toJson());
    print(widget.person);
    // DateFormat('yyyyMMddTHHmmss-SSSSSS').format(DateTime.now()).toString();
    double totalPrice = (widget.feed!.fee! * widget.person!) + admin;

    handleBook() async {
      var id = await nanoid(10);
      var orderID = user['name'][0] + widget.feed!.id!.toString() + id;

      print('order_id: ${orderID}');
      print("total_price: $totalPrice");
      print("fee: ${widget.feed!.fee!}");
      print("admin_price: ${admin}");
      print("bank: ${paymentAccountValue}");
      print("qty: ${widget.person}");
      print("name: ${user['name']}");
      print("email: ${user['email']}");
      print("phone: ${user['address']}");
      print("phone: ${user['phone_number']}");
      print("feed_id: ${widget.feed!.id}");

      controller.createOrder(
          orderID,
          totalPrice,
          widget.feed!.fee!,
          admin,
          paymentAccountValue,
          widget.person!,
          user['name'],
          user['email'],
          user['address'],
          user['phone_number'],
          widget.feed!.id!
      );
    }

    Widget header() {
      return Container(
        margin: EdgeInsets.only(left: 20),
        child: SafeArea(
          child: AppBar(
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            title: Text('Book Ticket'),
            titleTextStyle: TextStyle(
                fontWeight: semibold, color: Colors.white, fontSize: 16),
            iconTheme: IconThemeData(color: Colors.white),
            leading: IconButton(
              highlightColor: Colors.transparent,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ),
      );
    }

    Widget content() {
      return SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  left: 20, right: 20, top: Get.size.height * 0.08),
              height: Get.size.height * 0.54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Warna bayangan
                    spreadRadius: 2, // Penyebaran bayangan
                    blurRadius: 5, // Radius blur bayangan
                    offset: Offset(0, 3), // Posisi bayangan (x, y)
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CONTENT HEADER
                  Padding(
                    padding: EdgeInsets.only(
                        left: 13, right: 13, top: 7, bottom: 17),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              formatDate(DateTime.now().toString()),
                              style: primaryTextStylePlusJakartaSans.copyWith(
                                  fontSize: 14, color: textHintColor),
                            ),
                            Spacer(),
                            Icon(
                              Icons.location_pin,
                              color: textButtonSecondaryColor,
                              size: 30,
                            )
                          ],
                        ),
                        Text(
                          widget.feed!.title!,
                          style: primaryTextStylePlusJakartaSans.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.fade,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        Text(
                          widget.feed!.location!,
                          style: primaryTextStylePlusJakartaSans.copyWith(
                            fontSize: 14,
                            overflow: TextOverflow.fade,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 25, top: 12),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline_rounded,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${formatDateNum(widget.feed!
                                        .dateStart!)} - ${formatDateNum(
                                        widget.feed!.dateEnd!)}",
                                    style: primaryTextStylePlusJakartaSans
                                        .copyWith(
                                      fontSize: 14,
                                      overflow: TextOverflow.fade,
                                      color: textSecondaryColor,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline_rounded,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Open Trip',
                                    style: primaryTextStylePlusJakartaSans
                                        .copyWith(
                                      fontSize: 14,
                                      overflow: TextOverflow.fade,
                                      color: textSecondaryColor,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  widget.feed!.user!.profilePhotoPath == null
                                      ? Icon(
                                    Icons.person,
                                    color: Colors.blueAccent,
                                  )
                                      : CircleAvatar(
                                    radius:
                                    15,
                                    // Setengah dari lebar atau tinggi gambar
                                    backgroundImage: NetworkImage(
                                      urlImage +
                                          widget.feed!.user!
                                              .profilePhotoPath!,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    widget.feed!.user!.name!,
                                    style: primaryTextStylePlusJakartaSans
                                        .copyWith(
                                      fontSize: 14,
                                      overflow: TextOverflow.fade,
                                      color: textSecondaryColor,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  DottedDashedLine(
                    height: 0,
                    width: double.infinity,
                    axis: Axis.horizontal,
                    dashColor: textHintColor,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // CONTENT DETAILS
                  Padding(
                      padding: EdgeInsets.only(
                          left: 22, right: 13, top: 7, bottom: 17),
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
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Column(
                                children: [
                                  Row(children: [
                                    Text(
                                      'Ticket Trip',
                                      style: primaryTextStylePlusJakartaSans
                                          .copyWith(
                                          fontSize: 14,
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
                                            style:
                                            primaryTextStylePlusJakartaSans
                                                .copyWith(
                                                fontSize: 14,
                                                color: textHintColor,
                                                fontWeight: semibold),
                                          ),
                                          Text(
                                            '${formatter.format(
                                                widget.feed!.fee!)
                                                .toString()}  x  ${widget
                                                .person!}',
                                            style:
                                            primaryTextStylePlusJakartaSans
                                                .copyWith(
                                                fontSize: 14,
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
                                      style: primaryTextStylePlusJakartaSans
                                          .copyWith(
                                          fontSize: 14,
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
                                            style:
                                            primaryTextStylePlusJakartaSans
                                                .copyWith(
                                                fontSize: 14,
                                                color: textHintColor,
                                                fontWeight: semibold),
                                          ),
                                          Text(
                                            formatter.format(admin).toString(),
                                            style:
                                            primaryTextStylePlusJakartaSans
                                                .copyWith(
                                                fontSize: 14,
                                                color: textHintColor,
                                                fontWeight: semibold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
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
                  // CONTENT TOTAL PRICE INFO
                  Padding(
                      padding: EdgeInsets.only(
                          left: 32, right: 13, top: 20, bottom: 17),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total',
                              style: primaryTextStylePlusJakartaSans.copyWith(
                                  fontSize: 14,
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
                                  primaryTextStylePlusJakartaSans.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  formatter.format(totalPrice).toString(),
                                  style:
                                  primaryTextStylePlusJakartaSans.copyWith(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.fade,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            )
                          ])),
                ],
              ),
            ),
            // CONTENT PAYMENT
            Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Warna bayangan
                      spreadRadius: 2, // Penyebaran bayangan
                      blurRadius: 5, // Radius blur bayangan
                      offset: Offset(0, 3), // Posisi bayangan (x, y)
                    ),
                  ],
                ),
                margin: EdgeInsets.only(right: 20, left: 20, top: 20),
                child: Column(
                  children: [
                    Container(
                      padding:
                      EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      width: double.infinity,
                      color: textHintColor,
                      child: Text(
                        "Bank Transfer",
                        style: primaryTextStylePlusJakartaSans.copyWith(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    RadioListBank(
                      onBankSelected: handlePaymentValue,
                      selectedValue: paymentAccountValue,
                    )
                  ],
                )),
            // CONTENT TERM
            Container(
              margin: EdgeInsets.only(right: 20, left: 20, top: 10),
              child: Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  Container(
                    width: Get.size.width * 0.75,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        "By procceding, i acknowledge that i have read and agree.",
                        style: primaryTextStylePlusJakartaSans.copyWith(
                            fontSize: 14),
                      ),
                    ),
                  )
                ],
              ),
            ),

            GetBuilder<OrderController>(builder: (controller) {
              if (controller.status.isLoading){
                return LoadingWidget();
              }else{
                return Container(
                  margin: EdgeInsets.only(left: 40, right: 40, top: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      if (isChecked && paymentAccountValue != '') {
                        handleBook();
                      }
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(
                            vertical: 11,
                            horizontal: 20), // Set the desired padding values
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Set the desired border radius
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          isChecked && paymentAccountValue != ''
                              ? textButtonSecondaryColor
                              : textHintColor),
                    ),
                    child: Center(
                      child: Text(
                        "Pay Now",
                        style: buttonPrimaryTextStyle.copyWith(
                            fontSize: 22, fontWeight: semibold),
                      ),
                    ),
                  ),
                );
              }

            })
          ],
        ),
      );
    }

    return Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 213,
                color: textButtonSecondaryColor,
              ),
              header(),
              content()
            ],
          ),
        ));
  }
}
