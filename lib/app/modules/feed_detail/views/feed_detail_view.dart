import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tripusfrontend/app/data/models/feeds_home_model.dart';
import 'package:tripusfrontend/app/data/static_data.dart';
import 'package:tripusfrontend/app/helpers/carousel_widget.dart';

import '../../../controllers/feeds_controller.dart';
import '../../../helpers/avatar_custom.dart';
import '../../../helpers/format_datetime.dart';
import '../../../helpers/theme.dart';
import '../../../routes/app_pages.dart';
import '../../book_ticket/views/book_ticket_view.dart';
import '../../main-profile/controllers/main_profile_controller.dart';

class FeedDetailView extends StatefulWidget {
  FeedDetailView();

  @override
  State<FeedDetailView> createState() => _FeedDetailViewState();
}

class _FeedDetailViewState extends State<FeedDetailView> {
  FeedsHome? feeds = StaticData.feeds.firstWhere(
          (element) => element.id == int.parse(Get.parameters['id'] ?? '0'));

  bool like = false;
  bool isLiked = false;

  bool save = false;
  bool isSaved = false;

  int feedLikeLength = 0;
  int person = 0;

  var formatter = NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0,);

  @override
  void initState() {
    super.initState();
    Get.put(MainProfileController());
    Get.put(FeedsController());
    feedLikeLength = feeds!.feedsLikes!.length;
    if (feeds!.feedsLikes!
        .any((element) => element.userId == GetStorage().read('user')['id'])) {
      isLiked = true;
    };

    if (feeds!.feedsSaves!
        .any((element) => element.userId == GetStorage().read('user')['id'])) {
      isSaved = true;
    }
  }

  handleBookingTrip(){
    if (person != 0){
      Get.to(() => BookTicketView(feeds, person));
    }
  }

  @override
  Widget build(BuildContext context) {
    if(feeds!.cancelTrip!.isNotEmpty){
      print(feeds?.cancelTrip?.first.toJson());
    }

    // print('id param ${Get.parameters.id}');
    print("arg: ${Get.arguments}");
    print("param: ${int.parse(Get.parameters['id'] ?? '0')}");
    String? name = feeds!.user!.name;
    String? userName = name != null ? toBeginningOfSentenceCase(name) : '';

    List<Widget> imageSliders = feeds!.feedImage!
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
              feeds!.title!,
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
                  feeds!.location!,
                  overflow: TextOverflow.fade,
                  style: primaryTextStylePlusJakartaSans.copyWith(fontSize: 14),
                ),
              )
            ],
          ),
        ],
      );
    }

    Widget desription() {
      return Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Text(
            feeds?.description ?? '',
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

    Widget include(String name, String text) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 14),
            width: double.infinity,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(color: Color(0xffCCCCCC)),
            child: Center(
              child: Text(
                name,
                style: primaryTextStylePlusJakartaSans.copyWith(
                    fontSize: 14, fontWeight: semibold),
              ),
            ),
          ),
          Text(
            text ?? '-',
            style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 14, fontWeight: medium, height: 1.5),
            textAlign: TextAlign.justify,
          ),
        ],
      );
    }

    Widget buttonBook() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: handleBookingTrip,
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 40), // Set the desired padding values
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      24), // Set the desired border radius
                ),
              ),
              backgroundColor:
                  MaterialStateProperty.all<Color>(person != 0 ? textButtonSecondaryColor : textHintColor),
            ),
            child: Center(
              child: Text(
                "Book Now",
                style: buttonPrimaryTextStyle.copyWith(
                    fontSize: 22, fontWeight: semibold),
              ),
            ),
          ),
          SizedBox(
            width: 2,
          ),
          InkWell(
            onTap: () {
              setState(() {
                person = person + 1;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              decoration: BoxDecoration(
                  color: textButtonSecondaryColor,
                  borderRadius: BorderRadius.circular(24)),
              child: Center(child: Icon(Icons.add, color: Colors.white)),
            ),
          ),
          SizedBox(
            width: 2,
          ),
          Container(
            width: 50,
            padding: EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
                color: textHintColor, borderRadius: BorderRadius.circular(24)),
            child: Center(
                child: Text(
              person.toString(),
              style: buttonPrimaryTextStyle.copyWith(
                  fontSize: 22, fontWeight: semibold),
            )),
          ),
          SizedBox(
            width: 2,
          ),
          InkWell(
            onTap: () {
              setState(() {
                if (person > 0) {
                  setState(() {
                    person = person - 1;
                  });
                }
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              decoration: BoxDecoration(
                  color: textButtonSecondaryColor,
                  borderRadius: BorderRadius.circular(24)),
              child: Center(
                  child: Icon(Icons.horizontal_rule, color: Colors.white)),
            ),
          ),
        ],
      );
    }

    Widget joinPerson() {
      return Center(
          child: Text(
        "${feeds!.feedsJoin!.length}/${feeds!.maxPerson.toString()} person joined",
        style: primaryTextStylePlusJakartaSans.copyWith(
            fontSize: 14, color: textHintColor, fontWeight: FontWeight.bold),
      ));
    }

    Widget footer() {
      return Row(children: [
        feeds!.user!.profilePhotoPath == null
            ? Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.toNamed(Routes.MAIN_PROFILE,
                          parameters: {'id': feeds!.user!.id.toString()});
                    },
                    icon: AvatarCustom(
                      radius: 20,
                      name: feeds!.user!.name!,
                      width: 40,
                      height: 10,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              )
            : IconButton(
                onPressed: () => Get.toNamed(Routes.MAIN_PROFILE,
                    parameters: {'id': feeds!.user!.id.toString()}),
                icon: CircleAvatar(
                  radius:
                      50, // Set the radius to control the size of the circle
                  backgroundImage:
                      NetworkImage(urlImage + feeds!.user!.profilePhotoPath!),
                ),
              ),
        SizedBox(width: 2,),
        Container(
          width: Get.size.width*0.25,
          child: Text(feeds!.user!.name!, style: primaryTextStylePlusJakartaSans.copyWith(
            fontSize: 14, fontWeight: FontWeight.bold
            ),
            overflow: TextOverflow.fade,
          ),

        ),
        Spacer(),
        Text("Rp ${formatter.format(feeds!.fee).toString()}/Person", style: primaryTextStylePlusJakartaSans.copyWith(
            fontSize: 14,
        ),),
      ]);
    }

    Widget contentTrip() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          desription(),
          include('Include', feeds!.include!),
          include('Others', feeds!.others != null ? feeds!.others! : '-'),
          include('Exclude', feeds!.exclude!),
          SizedBox(
            height: 30,
          ),
          StaticData.box.read('user')['role'] != 'open trip' ?
          buttonBook() : Container(),
          SizedBox(
            height: 10,
          ),
          joinPerson(),
          SizedBox(
            height: 30,
          ),
          footer()
        ],
      );
    }

    Widget date() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            feeds!.type == 'feed'
                ? formatTimeAgo(feeds!.createdAt!)
                : "${formatDate(feeds!.dateStart!)} - ${formatDate(feeds!.dateEnd!)}",
            style: primaryTextStylePlusJakartaSans.copyWith(fontSize: 14),
          ),
          const SizedBox(
            height: 2,
          ),
          feeds!.location != null && feeds!.type == 'feed'
              ? Row(
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
                        feeds!.location!,
                        overflow: TextOverflow.ellipsis,
                        style: primaryTextStylePlusJakartaSans.copyWith(
                            fontSize: 14),
                      ),
                    )
                  ],
                )
              : Container(),
          feeds!.type == 'open trip' ? titleAndLocationTrip() : Container()
        ],
      );
    }

    Widget likeAndShare() {
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSaved) {
                        save = false;
                        isSaved = !isSaved;
                        Get.find<FeedsController>().deleteSave(feeds!.id!);
                      } else {
                        save = !save;
                        isSaved = !isSaved;
                        Get.find<FeedsController>().save(feeds!.id!);
                      }
                      print(isLiked);
                    });
                  },
                  child: isSaved || save
                      ? Icon(
                          Icons.bookmark,
                          size: 30,
                          color: Colors.black,
                        )
                      : Icon(
                          Icons.bookmark_outline,
                          size: 30,
                          color: Colors.black,
                        )),
              Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isLiked) {
                            like = false;
                            isLiked = !isLiked;
                            feedLikeLength = feedLikeLength - 1;
                            Get.find<FeedsController>().deleteLike(feeds!.id!);
                          } else {
                            like = !like;
                            isLiked = !isLiked;
                            feedLikeLength = feedLikeLength + 1;
                            Get.find<FeedsController>().like(feeds!.id!);
                          }
                          print(isLiked);
                        });
                      },
                      child: isLiked || like
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 30,
                            )
                          : Icon(
                              Icons.favorite_border,
                              size: 30,
                            )),
                  Text(
                    feedLikeLength.toString(),
                    style: primaryTextStylePlusJakartaSans.copyWith(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }

    Widget favorite() {
      return Column(
        children: [
          GestureDetector(
              onTap: () {
                setState(() {
                  if (isLiked) {
                    like = false;
                    isLiked = !isLiked;
                    feedLikeLength = feedLikeLength - 1;
                    Get.find<FeedsController>().deleteLike(feeds!.id!);
                  } else {
                    like = !like;
                    isLiked = !isLiked;
                    feedLikeLength = feedLikeLength + 1;
                    Get.find<FeedsController>().like(feeds!.id!);
                  }
                  print(isLiked);
                });
              },
              child: isLiked || like
                  ? Icon(
                      Icons.stars_sharp,
                      color: Colors.blueAccent,
                      size: 30,
                    )
                  : Icon(
                      Icons.stars_sharp,
                      size: 30,
                    )),
          Text(
            feedLikeLength.toString(),
            style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

    Widget content() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            userName.toString(),
            style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 24, fontWeight: FontWeight.bold),
          ),
          desription()
        ],
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Opacity(
              opacity: 0.6,
              child: Image.network(
                urlImage + feeds!.feedImage!.first.imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: Get.size.height,
              )),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 10),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      AppBar(
                        shadowColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        title: Text('Post'),
                        titleTextStyle: TextStyle(
                            fontWeight: semibold,
                            color: textPrimaryColor,
                            fontSize: 16),
                        centerTitle: true,
                        iconTheme: IconThemeData(color: textPrimaryColor),
                        leading: IconButton(
                          highlightColor: Colors.transparent,
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            final MainProfileController mainProfileController =
                                Get.find();
                            mainProfileController.updateData(Get.arguments != null ? Get.arguments : StaticData.box.read('user')['id']);
                            Get.back();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 46,
                      ),
                      FeedsCarousel(imageSliders),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                DraggableScrollableSheet(
                    initialChildSize: 0.2,
                    minChildSize: 0.2,
                    maxChildSize: 0.7,
                    snap: false,
                    builder: (context, scrollController) {
                      return Container(
                        padding: EdgeInsets.only(left: 24, right: 24, top: 0),
                        height: Get.size.height,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40),
                                topLeft: Radius.circular(40)),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                //begin color
                                Colors.white.withOpacity(0.8),
                                //end color
                                Colors.white.withOpacity(0.9),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.4), // Shadow color
                                offset: Offset(0, 2), // Shadow offset
                                blurRadius: 7, // Shadow blur radius
                                spreadRadius: 0, // Shadow spread radius
                              ),
                            ]),
                        child: ListView(
                          controller: scrollController,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                date(),
                                Spacer(),
                                feeds!.type == 'feed'
                                    ? likeAndShare()
                                    : favorite()
                              ],
                            ),
                            feeds!.type == 'feed' ? content() : contentTrip()
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
