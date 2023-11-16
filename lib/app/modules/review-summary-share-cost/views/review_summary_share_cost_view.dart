import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tripusfrontend/app/controllers/feeds_controller.dart';

import '../../../data/models/follow_model.dart';
import '../../../helpers/format_number.dart';
import '../../../helpers/theme.dart';
import '../controllers/review_summary_share_cost_controller.dart';

class ReviewSummaryShareCostView extends StatefulWidget{
  ReviewSummaryShareCostView({Key? key}) : super(key: key);

  @override
  State<ReviewSummaryShareCostView> createState() => _ReviewSummaryShareCostViewState();
}

class _ReviewSummaryShareCostViewState extends State<ReviewSummaryShareCostView> {
  List<UserFollowing> splitUsers = Get.arguments[0];

  double splitPrice = Get.arguments[1];
  List<int> join = [];

  @override
  void initState(){
    super.initState();
    Get.lazyPut(() => FeedsController());
    splitPrice = splitPrice / (splitUsers.length + 1);
    for(var user in splitUsers){
      join.add(user.id!);
    }
  }

  @override
  Widget build(BuildContext context) {

    print("user: ${splitUsers}");
    print("price: ${splitPrice}");

    Widget buttonSendRequest() {
      return ElevatedButton(
        onPressed: () async{
          // print(Get.arguments[2]);
          var imageList = Get.arguments[2]['image_list'];
          var title = Get.arguments[2]['title'];
          var description = Get.arguments[2]['description'];
          var location = Get.arguments[2]['location'];
          var others = Get.arguments[2]['others'];
          var dateStart = Get.arguments[2]['date_start'];
          var dateEnd = Get.arguments[2]['date_end'];
          var fee = Get.arguments[2]['fee'];

          print("imageList: ${imageList}");
          print("title: ${title}");
          print("description: ${description}");
          print("location: ${location}");
          print("others: ${others}");
          print("dateStart: ${dateStart}");
          print("dateEnd: ${dateEnd}");
          print("fee: ${fee}");
          print("join: ${join}");

          await Get.find<FeedsController>().createShareCost(
              title,
              description,
              location,
              imageList,
              others,
              dateStart,
              dateEnd,
              fee,
              join
          );
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
              "Send a Request",
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
            title: Text("Review Summary"),
            titleTextStyle: TextStyle(
                fontWeight: semibold, color: textPrimaryColor, fontSize: 16),
            centerTitle: true,
            iconTheme: IconThemeData(color: textPrimaryColor),
            toolbarHeight: kToolbarHeight + 15,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Center(
              child: Text("Share a cost of", style: primaryTextStylePlusJakartaSans.copyWith(
                fontWeight: FontWeight.bold, fontSize: 14
              ),),
            ),
            const SizedBox(height: 10,),
            Container(
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
              child: Text('Rp ${formatNumber(Get.arguments[1])}', style: primaryTextStylePlusJakartaSans.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 32
              ),),
            ),
            const SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              margin: EdgeInsets.symmetric(horizontal: 20),
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
                  Row(
                    children: [
                      Text('You', style: primaryTextStylePlusJakartaSans.copyWith(
                          fontSize: 14, fontWeight: medium
                      ),),
                      Spacer(),
                      Text('Rp ${formatNumber(splitPrice)}', style: primaryTextStylePlusJakartaSans.copyWith(
                          fontSize: 14, fontWeight: medium
                      ),),
                    ],
                  ),
                  const SizedBox(height: 5,),
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
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: buttonSendRequest(),
            ),
          ],
        ),
      )
    );
  }
}
