import "dart:developer";
import "dart:io";

import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:intl/intl.dart";
import "package:tripusfrontend/app/controllers/withdraw_controller.dart";
import "package:tripusfrontend/app/data/models/withdraw_model.dart";
import "package:tripusfrontend/app/data/static_data.dart";
import "package:tripusfrontend/app/routes/app_pages.dart";

import "../../../../controllers/order_controller.dart";
import "../../../../data/models/feeds_home_model.dart";
import "../../../../data/models/orders_model.dart";
import "../../../../helpers/dialog_widget.dart";
import "../../../../helpers/format_datetime.dart";
import "../../../../helpers/loading_widget.dart";
import "../../../../helpers/theme.dart";

class ContentWidget extends StatefulWidget {
  List<FeedsHome> feeds;
  List<Withdraw> withdraws;
  final void Function() refreshData;
  ContentWidget({required this.feeds, required this.withdraws, required this.refreshData, super.key});

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {

  WithdrawController withdrawController = Get.find<WithdrawController>();

  @override
  void initState(){
    super.initState();
    Get.lazyPut(() => WithdrawController());
  }

  var formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );

  String fileName = '';
  String filePath = '';

  _handleRefreshData() {
    widget.refreshData();
  }

  void handleRequestWithdraw(FeedsHome feed){
    if (filePath == ''){

    }else{
      withdrawController.create(feed.id!, filePath);
      Get.back();
      _handleRefreshData();
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget buttonReqWithdraw(FeedsHome feed) {
      bool isWithdrawEmpty = widget.withdraws.where((element) => element.feedId == feed.id).isEmpty;
      List<Withdraw> withdrawFeed = widget.withdraws.where((element) => element.feedId == feed.id).toList();
      bool isWithdrawReject = withdrawFeed.isNotEmpty && withdrawFeed.first.status == 'reject';
      return Container(
        width: 115,
        child: ElevatedButton(
          onPressed: () {
            if (feed.fee! * feed.feedsJoin!.length == 0){
              dialogError("Sorry you can't withdraw this trip");
            }else{
              if(isWithdrawEmpty || isWithdrawReject){
                showDialog(
                  context: context, // Pastikan Anda memiliki akses ke BuildContext
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                        builder: (context, setstate) {
                          return Dialog(
                            backgroundColor: textButtonSecondaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Radius yang Anda inginkan
                            ),
                            child: Container(
                              height: 270,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 15,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("Withdraw", style: primaryTextStyle.copyWith(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      ),),
                                      SizedBox(width: 60,),
                                      IconButton(
                                          splashRadius: 25,
                                          onPressed: () => Get.back(),
                                          icon: Icon(Icons.close, color: Colors.white)
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 24,),
                                  Text("Upload File ( Trip Activies, Ticket, etc)", style: primaryTextStylePlusJakartaSans.copyWith(
                                      color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold
                                  ),),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                    onTap: () async {
                                      print("ditap");
                                      FilePickerResult? result = await FilePicker.platform
                                          .pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg']);

                                      if (result != null) {
                                        final file = result.files.first;

                                        setstate(() {
                                          fileName = file.name;
                                          filePath = result.files.single.path.toString();
                                        });

                                        print("name: ${file.name}");
                                        print("ext: ${file.extension}");
                                        print("type: ${file.runtimeType}");
                                        print("byte: ${File(result.files.single.path.toString())}");


                                      } else {
                                        return;
                                      }
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white
                                      ),
                                      child: Center(
                                        child: Text(fileName == "" ? "choose your file" : fileName, style: primaryTextStylePlusJakartaSans.copyWith(
                                            color: textHintColor, fontWeight: semibold, fontSize: 14, overflow: TextOverflow.ellipsis
                                        ),),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  filePath == '' ?
                                  Text("*File required", style: primaryTextStylePlusJakartaSans.copyWith(
                                      color: Colors.white, fontSize: 12
                                  ),): Container(),
                                  Center(
                                    child: GestureDetector(
                                      onTap: () => handleRequestWithdraw(feed),
                                      child: Container(
                                        margin: EdgeInsets.only(top: 20),
                                        width: 100,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.green
                                        ),
                                        child: Center(
                                          child: Text("Upload", style: primaryTextStylePlusJakartaSans.copyWith(
                                              color: Colors.white, fontWeight: semibold, fontSize: 14
                                          ),),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                    );
                  },
                );
              }
            }

          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 25), // Set the desired padding values
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(10), // Set the desired border radius
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(isWithdrawEmpty || isWithdrawReject ? textButtonSecondaryColor :  Colors.orangeAccent),
          ),
          child: Center(
            child: Text(
              isWithdrawEmpty || isWithdrawReject ? "Withdraw" : "Withdraw Pending",
              style: buttonPrimaryTextStyle.copyWith(
                  fontSize: 11, fontWeight: semibold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    Widget buttonReqCancel() {
      return Container(
        width: 115,
        child: ElevatedButton(
          onPressed: () {
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
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          ),
          child: Text(
            "Req Cancel",
            style: buttonPrimaryTextStyle.copyWith(
                fontSize: 11, fontWeight: semibold, color: Colors.white),
          ),
        ),
      );
    }

    Widget buttonSeeDetails(FeedsHome feeds) {
      return Container(
        width: 115,
        child: ElevatedButton(
          onPressed: () => Get.toNamed(Routes.AGENT_DETAIL_TRANSACTION, arguments: [StaticData.ordersAgent.where((element) => element.feedId == feeds.id.toString()), feeds.title]),
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

    Widget content(FeedsHome feeds) {
      // print(order.feeds!.agentName);
      List<Withdraw> withdrawFeed = widget.withdraws.where((element) => element.feedId == feeds.id).toList();
      bool isWithdrawSuccess = withdrawFeed.isNotEmpty && withdrawFeed.first.status == 'accept';
      Duration time = DateTime.now().difference(DateTime.parse(feeds.dateEnd!));
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
                feeds.withdrawTrip!.isEmpty && feeds.cancelTrip!.isEmpty
                    ? Image.asset(
                  'assets/icon_flat.png',
                  width: 40,
                  height: 40,
                  color: Colors.orangeAccent,
                )
                    : isWithdrawSuccess
                    ? Image.asset(
                  'assets/icon_smile.png',
                  width: 40,
                  height: 40,
                  color: Colors.green,
                )
                    : isWithdrawSuccess == false || feeds.cancelTrip!.first.status == 'accept'
                    ? Image.asset(
                  'assets/icon_frown.png',
                  width: 40,
                  height: 40,
                  color: Colors.red,
                )
                    : Image.asset(
                  'assets/icon_flat.png',
                  width: 40,
                  height: 40,
                  color: Colors.orangeAccent,
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
                        feeds.title ?? '',
                        style: primaryTextStylePlusJakartaSans.copyWith(
                            fontWeight: semibold, fontSize: 16),
                      ),
                      // TRIP AGENT NAME
                      Text(
                        "${feeds.feedsJoin!.length}/${feeds.maxPerson} Person Joined",
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
                        "${formatter.format(feeds.fee! * feeds.feedsJoin!.length)}",
                        style: primaryTextStylePlusJakartaSans.copyWith(
                            fontSize: 16,
                            color: textButtonSecondaryColor,
                            fontWeight: semibold),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Column(
                  children: [
                    time.inHours > 1 && isWithdrawSuccess ? Container() : time.inHours > 1? buttonReqWithdraw(feeds) :
                    feeds.cancelTrip!.isEmpty && feeds.withdrawTrip!.isEmpty ? buttonReqCancel()
                        : Container()  ,
                    buttonSeeDetails(feeds),
                  ],
                )
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
                feeds.cancelTrip!.isEmpty && feeds.withdrawTrip!.isEmpty ?
                    Text(
                  "Pending",
                  style: primaryTextStylePlusJakartaSans.copyWith(
                      fontSize: 12,
                      color: Colors.orangeAccent,
                      fontWeight: semibold),
                )
                    : isWithdrawSuccess
                    ? Text(
                  "Successfully",
                  style: primaryTextStylePlusJakartaSans.copyWith(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: semibold),
                )
                    : isWithdrawSuccess == false ?
                Text(
                  "Withdraw Rejected",
                  style: primaryTextStylePlusJakartaSans.copyWith(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: semibold),
                ) :
                feeds.cancelTrip!.first.status == 'accept'
                    ? Text(
                  "Cancel",
                  style: primaryTextStylePlusJakartaSans.copyWith(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: semibold),
                )
                    : Text(
                  "Pending",
                  style: primaryTextStylePlusJakartaSans.copyWith(
                      fontSize: 12,
                      color: Colors.orangeAccent,
                      fontWeight: semibold),
                ),
                Spacer(),
                Text(
                  "${formatDateNum(feeds.dateStart!)} - ${formatDateNum(feeds.dateEnd!)}",
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
    return Column(
      children: widget.feeds.map((e) => content(e)).toList(),
    );
  }
}
