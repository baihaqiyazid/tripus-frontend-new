import 'package:clipboard/clipboard.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tripusfrontend/app/helpers/theme.dart';

import '../../../data/models/orders_agent_model.dart';
import '../../../data/models/orders_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/static_data.dart';
import '../../../helpers/format_datetime.dart';
import '../controllers/agent_detail_transaction_controller.dart';

class AgentDetailTransactionView extends StatefulWidget{
  const AgentDetailTransactionView({Key? key}) : super(key: key);

  @override
  State<AgentDetailTransactionView> createState() => _AgentDetailTransactionViewState();
}

class _AgentDetailTransactionViewState extends State<AgentDetailTransactionView> {
  @override

  bool isPending = true;
  bool isSuccess = false;
  bool isCancel = false;
  bool isExpired = false;

  var formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );

  List<OrdersAgent> orders = Get.arguments[0].toList();
  String title = Get.arguments[1];
  var user = StaticData.box.read('user');

  Widget build(BuildContext context) {
    print("arg: ${orders.length}" );
    print("pending: ${isPending}");
    if(true){
      setState(() {
        orders = Get.arguments[0].toList();
        if(isPending){
          orders = orders.where((element) => element.status == 'pending').toList();
        }else if(isSuccess){
          orders = orders.where((element) => element.status == 'success').toList();
        }else if(isCancel){
          orders = orders.where((element) => element.status == 'cancel').toList();
        }else if(isExpired){
          orders = orders.where((element) => element.status == 'expired').toList();
        }
      });
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

    Widget seeDetails(OrdersAgent order) {
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
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            style: primaryTextStylePlusJakartaSans.copyWith(
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
                      Text(
                        user['name'],
                        style: primaryTextStylePlusJakartaSans.copyWith(
                          fontSize: 14,
                          overflow: TextOverflow.fade,
                          color: textSecondaryColor,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                  contentSeeDetail('Order Name', order.name!),
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

    Widget buttonSeeDetails(OrdersAgent order) {
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
    Widget content(OrdersAgent order) {
      // print(order.feeds!.agentName);
      return Container(
        margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
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
                        order.name!,
                        style: primaryTextStylePlusJakartaSans.copyWith(
                            fontWeight: semibold, fontSize: 16),
                      ),
                      // TRIP AGENT NAME
                      Text(
                        user['name'],
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

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Text(title, style: primaryTextStylePlusJakartaSans.copyWith(
          fontSize: 18, fontWeight: FontWeight.bold
        ),),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,

      ),
      body: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    TextButton(
                        onPressed: (){
                          setState(() {
                            isPending = true;
                            isSuccess = false;
                            isCancel = false;
                            isExpired = false;
                          });
                        },
                        child:  Text('Pending', style: primaryTextStylePlusJakartaSans.copyWith(
                            fontSize: 14, fontWeight: semibold
                        ),),
                    ),
                    isPending ?
                    Container(
                      width: 60,
                        child: Divider(thickness: 2, height: 1, color: textButtonSecondaryColor,)
                    ) : Container()
                  ],
                ),
                Column(
                  children: [
                    TextButton(
                      onPressed: (){
                        setState(() {
                          isPending = false;
                          isSuccess = true;
                          isCancel = false;
                          isExpired = false;
                        });
                      },
                      child:  Text('Successful', style: primaryTextStylePlusJakartaSans.copyWith(
                          fontSize: 14, fontWeight: semibold
                      ),),
                    ),
                    isSuccess ?
                    Container(
                        width: 60,
                        child: Divider(thickness: 2, height: 1, color: textButtonSecondaryColor,)
                    ) : Container()
                  ],
                ),
                Column(
                  children: [
                    TextButton(
                      onPressed: (){
                        setState(() {
                          isPending = false;
                          isSuccess = false;
                          isCancel = true;
                          isExpired = false;
                        });
                      },
                      child:  Text('Canceled', style: primaryTextStylePlusJakartaSans.copyWith(
                          fontSize: 14, fontWeight: semibold
                      ),),
                    ),
                    isCancel ?
                    Container(
                        width: 60,
                        child: Divider(thickness: 2, height: 1, color: textButtonSecondaryColor,)
                    ) : Container()
                  ],
                ),
                Column(
                  children: [
                    TextButton(
                      onPressed: (){
                        setState(() {
                          isPending = false;
                          isSuccess = false;
                          isCancel = false;
                          isExpired = true;
                        });
                      },
                      child:  Text('Expired', style: primaryTextStylePlusJakartaSans.copyWith(
                          fontSize: 14, fontWeight: semibold
                      ),),
                    ),
                    isExpired ?
                    Container(
                        width: 60,
                        child: Divider(thickness: 2, height: 1, color: textButtonSecondaryColor,)
                    ) : Container()
                  ],
                ),
              ],
            ),
            SizedBox(height: 20,),
            SingleChildScrollView(
              child: Column(
                children: orders.map((e) => content(e)).toList(),
              ),
            )
          ],
        )
      )
    );
  }
}
