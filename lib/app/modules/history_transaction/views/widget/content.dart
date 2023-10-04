import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:intl/intl.dart";
import "package:tripusfrontend/app/data/static_data.dart";
import "package:tripusfrontend/app/routes/app_pages.dart";

import "../../../../data/models/feeds_home_model.dart";
import "../../../../data/models/orders_model.dart";
import "../../../../helpers/format_datetime.dart";
import "../../../../helpers/theme.dart";

class ContentWidget extends StatefulWidget {
  List<FeedsHome> feeds;
  ContentWidget({required this.feeds, super.key});

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {

  var formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {

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

    Widget buttonReqWithdraw() {
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
            backgroundColor: MaterialStateProperty.all<Color>(textButtonSecondaryColor),
          ),
          child: Text(
            "Withdraw",
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
                feeds.withdrawTrip!.isEmpty || feeds.cancelTrip!.isEmpty
                    ? Image.asset(
                  'assets/icon_flat.png',
                  width: 40,
                  height: 40,
                  color: Colors.orangeAccent,
                )
                    : feeds.withdrawTrip!.first.status == 'accept'
                    ? Image.asset(
                  'assets/icon_smile.png',
                  width: 40,
                  height: 40,
                  color: Colors.green,
                )
                    : feeds.cancelTrip!.first.status == 'accept'
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
                    time.inHours > 1 ? buttonReqWithdraw() :
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
                feeds.cancelTrip!.isEmpty || feeds.withdrawTrip!.isEmpty ?
                    Text(
                  "Pending",
                  style: primaryTextStylePlusJakartaSans.copyWith(
                      fontSize: 12,
                      color: Colors.orangeAccent,
                      fontWeight: semibold),
                )
                    : feeds.withdrawTrip!.first.status == 'accept'
                    ? Text(
                  "Done",
                  style: primaryTextStylePlusJakartaSans.copyWith(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: semibold),
                )
                    : feeds.cancelTrip!.first.status == 'accept'
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
