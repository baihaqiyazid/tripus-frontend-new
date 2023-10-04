import 'dart:developer';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tripusfrontend/app/controllers/home_page_controller.dart';
import 'package:tripusfrontend/app/helpers/theme.dart';
import 'package:tripusfrontend/app/routes/app_pages.dart';
import '../../../data/models/feeds_home_model.dart';
import '../../../data/static_data.dart';
import '../../../helpers/avatar_custom.dart';
import '../../../helpers/format_datetime.dart';
import '../controllers/explore_controller.dart';

class ExploreView extends StatefulWidget {
  ExploreView({Key? key}) : super(key: key);

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final AppinioSwiperController controllerSwipe = AppinioSwiperController();

  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    // Hapus FocusNode saat State di-dipose
    _focusNode.dispose();
    super.dispose();
  }

  void clearFocusNode() {
    // Beri fokus pada objek yang tidak dapat di-focus (misalnya, GlobalKey)
    FocusScope.of(context).requestFocus(FocusNode());
  }

  var formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );
  RefreshController refreshC = RefreshController();

  void refreshData() async {
    try {
      print("refresh");
      await Future.delayed(Duration(seconds: 1));
      StaticData.feeds.clear();
      await initData();
      setState(() {
        feeds =
            StaticData.feeds.where((feed) => feed.type == 'open trip').toList();
        searchController.clear();
      });
      print(StaticData.feeds.length);
      refreshC.refreshCompleted();
    } catch (e) {
      refreshC.refreshFailed();
    }
  }

  Future initData() async {
    await Get.find<HomePageController>().getData();
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

  void _swipe(int index, AppinioSwiperDirection direction) {
    log("the card was swiped to the: " + direction.name);
  }

  void _unswipe(bool unswiped) {
    if (unswiped) {
      log("SUCCESS: card was unswiped");
    } else {
      log("FAIL: no card left to unswipe");
    }
  }

  void _onEnd() {
    log("end reached!");
  }

  var searchController = TextEditingController(text: '');
  FocusNode _focusNode = FocusNode();

  List<FeedsHome> feeds =
  StaticData.feeds.where((feed) => feed.type == 'open trip').toList();


  Widget buttonCategory(String name, String image) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          feeds =
              StaticData.feeds.where((feed) => feed.type == 'open trip').toList();
          feeds = feeds.where(
                (element) => element.categoryId!.toLowerCase().contains(name.toLowerCase())
          ).toList();
        });
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.white, // Warna latar belakang
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20.0), // Radius yang Anda inginkan
        ),
      ),
      child: Row(
        children: [
          Image.asset("assets/icon_${image}.png"),
          SizedBox(
            width: 10,
          ),
          Text(
            name,
            style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 14, fontWeight: semibold),
          )
        ],
      ),
    );
  }

  Widget buttonSeeDetails(int id) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () =>
            Get.toNamed(Routes.FEED_DETAIL, parameters: {'id': id.toString()}),
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

  @override
  Widget build(BuildContext context) {

    List<FeedsHome> feedsLike = StaticData.feeds.where((feed) => feed.type == 'open trip')
        .where((element) => element.feedsLikes!
        .any((e) => e.userId == StaticData.box.read('user')['id']))
        .toList();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        print("stat");
        // Logika atau aksi yang ingin Anda lakukan ketika TextFormField kehilangan fokus
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });

    Widget header() {
      return Stack(
        children: [
          feeds.isNotEmpty ?
          SizedBox(
            width: Get.size.width,
            height: Get.size.height * 0.55,
            child: AppinioSwiper(
              backgroundCardsCount: 2,
              cardsSpacing: 35,
              loop: true,
              swipeOptions: const AppinioSwipeOptions.all(),
              unlimitedUnswipe: true,
              controller: controllerSwipe,
              unswipe: _unswipe,
              onSwiping: (AppinioSwiperDirection direction) {
                debugPrint(direction.toString());
              },
              onSwipe: _swipe,
              padding: const EdgeInsets.only(
                bottom: 40,
              ),
              onEnd: _onEnd,
              cardsCount: feeds.length,
              cardsBuilder: (BuildContext context, int index) {
                final image = feeds[index].feedImage!.first.imageUrl;
                return GestureDetector(
                  onTap: () => Get.toNamed(Routes.FEED_DETAIL,
                      parameters: {'id': feeds[index].id.toString()}),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                    ),
                    child: Container(
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Image.network(urlImage + image!,
                                fit: BoxFit.cover, width: double.infinity,
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
                                      width: double.infinity,
                                      height: double.infinity),
                                ); // Replace with your LoadingWidget
                              }
                            }),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: Get.size.height * 0.11,
                                  left: 30,
                                  bottom: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Wanna plan your next trip?",
                                      style: primaryTextStyle.copyWith(
                                        color: Colors.white,
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.fade,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(1.0,
                                                1.0), // Geser bayangan horizontal dan vertikal
                                            blurRadius:
                                                3.0, // Besarnya blur pada bayangan
                                            color: Colors.black.withOpacity(
                                                0.5), // Warna bayangan
                                          ),
                                        ],
                                      )),
                                  Spacer(),
                                  Text(
                                    feeds[index].title!,
                                    style: primaryTextStyle.copyWith(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.fade,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1.0,
                                              1.0), // Geser bayangan horizontal dan vertikal
                                          blurRadius:
                                              3.0, // Besarnya blur pada bayangan
                                          color: Colors.black.withOpacity(
                                              0.5), // Warna bayangan
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    feeds[index].location!,
                                    style: primaryTextStyle.copyWith(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.fade,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1.0,
                                              1.0), // Geser bayangan horizontal dan vertikal
                                          blurRadius:
                                              3.0, // Besarnya blur pada bayangan
                                          color: Colors.black.withOpacity(
                                              0.5), // Warna bayangan
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                );
              },
            ),
          ) : Container(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    splashRadius: 25,
                    iconSize: 30,
                    icon: const Icon(
                      Icons.arrow_circle_left,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Container(
                          padding: const EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            focusNode: _focusNode,
                            autofocus: false,
                            controller: searchController,
                            style: primaryTextStyle,
                            decoration: InputDecoration.collapsed(
                                hintText: "search...",
                                hintStyle: hintTextStyle.copyWith(
                                  fontSize: 16,
                                )),
                          )),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      log(feeds.length.toString());
                      setState(() {
                        feeds =
                            StaticData.feeds.where((feed) => feed.type == 'open trip').toList();
                        feeds = feeds.where(
                              (element) {
                            return element.title!.toLowerCase().contains(searchController.text.toLowerCase()) ||
                                element.description!.toLowerCase().contains(searchController.text.toLowerCase()) ||
                                element.user!.name!.toLowerCase().contains(searchController.text.toLowerCase());
                          },
                        ).toList();
                      });
                      log(feeds.length.toString());
                    },
                    splashRadius: 25,
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    Widget category() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buttonCategory('Alam', 'alam'),
          buttonCategory('Sejarah', 'sejarah'),
          buttonCategory('Budaya', 'budaya'),
        ],
      );
    }

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
                    "Wishlist",
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
            child: feedsLike.isNotEmpty
                ? ListView(
                    scrollDirection: Axis.horizontal,
                    children: feedsLike
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

    Widget contentFeeds() {
      return Column(
          children: feeds
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
                                    "Rp ${formatter.format(e.fee!)}/Person",
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
                  width: 50, height: 50, child: CupertinoActivityIndicator()),
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
        child: Column(
          children: [
            header(),
            feeds.isNotEmpty ?
            GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: Column(
                    children: [
                      category(),
                      wishlist(),
                      contentFeeds(),
                      SizedBox(
                        height: Get.size.height * 0.15,
                      ),
                    ],
                  ),
                ),
              ),
            ) : Center(
              child: Text("Sorry, what you are looking for doesn't exist", style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 22, overflow: TextOverflow.fade
              ),),
            ),
          ],
        ),
      ),
    ));
  }
}
