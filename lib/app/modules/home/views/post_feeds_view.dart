import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:tripusfrontend/app/controllers/user_auth_controller.dart';
import 'package:tripusfrontend/app/helpers/carousel_widget.dart';
import 'package:tripusfrontend/app/helpers/loading_widget.dart';
import 'package:tripusfrontend/app/modules/home/views/widget/date.dart';
import 'package:tripusfrontend/app/modules/home/views/widget/exclude.dart';
import 'package:tripusfrontend/app/modules/home/views/widget/fee.dart';
import 'package:tripusfrontend/app/modules/home/views/widget/include.dart';
import 'package:tripusfrontend/app/modules/home/views/widget/max_person.dart';
import 'package:tripusfrontend/app/modules/home/views/widget/other.dart';
import 'package:tripusfrontend/app/modules/home/views/widget/payment_account.dart';
import 'package:tripusfrontend/app/modules/home/views/widget/place_Search.dart';
import 'package:tripusfrontend/app/modules/home/views/widget/trip_category.dart';

import '../../../controllers/feeds_controller.dart';
import '../../../helpers/theme.dart';
import 'widget/title.dart';

class PostFeedsView extends StatefulWidget {
  String typePost;
  PostFeedsView({required this.typePost});

  @override
  State<PostFeedsView> createState() => _PostFeedsViewState();
}

class _PostFeedsViewState extends State<PostFeedsView> {
  List<MapBoxPlace> places = [];
  List<MapBoxPlace> placesMeet = [];

  String selectedCategory = '';

  File? image;
  List<File> imageList = [];

  TextEditingController locationController = TextEditingController(text: '');
  TextEditingController meetingPointController =
  TextEditingController(text: '');
  TextEditingController descriptionController = TextEditingController(text: '');

  final ValueNotifier<String> searchText = ValueNotifier('');
  final ValueNotifier<String> searchTextMeet = ValueNotifier('');

  var placesSearch = PlacesSearch(
    apiKey:
    'pk.eyJ1IjoiYmFpaGFxeSIsImEiOiJjbGpzODBuMDMwYmo0M2p2c2JneXE2MGlrIn0.xeSSV9yBJ-nTKgbh2JrOhQ',
    limit: 10,
    country: 'ID',
  );

  void clearPlaces() {
    setState(() {
      places.clear();
    });
  }

  void clearPlacesMeet() {
    setState(() {
      placesMeet.clear();
    });
  }

  Future<List<MapBoxPlace>> getPlaces(String name) async {
    try {
      final result = await placesSearch.getPlaces(name);
      print("result: ${result}");

      setState(() {
        places = result!;
      });
      return places;
    } catch (e) {
      // Handle error jika terjadi exception
      print("Error: $e");
      setState(() {
        places = [];
      });
      return [];
    }
  }

  Future<List<MapBoxPlace>> getPlacesMeet(String name) async {
    try {
      final result = await placesSearch.getPlaces(name);
      print("result: ${result}");

      setState(() {
        placesMeet = result!;
      });
      return placesMeet;
    } catch (e) {
      // Handle error jika terjadi exception
      print("Error: $e");
      setState(() {
        placesMeet = [];
      });
      return [];
    }
  }

  Future takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
        source: ImageSource.camera, maxHeight: 2000, maxWidth: 2000);
    if (photo != null) {
      print("photo ${photo}");
      setState(() {
        image = File(photo.path);
        print("photo path ${image}");
        imageList.add(image!);
      });
    }
    print("image: ${image!.path}");
  }

  Future getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    print("photo ${photo}");
    if (photo != null) {
      setState(() {
        image = File(photo.path);
        print("photo path ${image}");
        imageList.add(image!);
      });
    }
    print("image: ${image!.path}");
  }

  Timer? _timer;

  TextEditingController titleValue = TextEditingController();
  TextEditingController includeValue = TextEditingController();
  TextEditingController excludeValue = TextEditingController();
  TextEditingController otherValue = TextEditingController();
  TextEditingController feeValue = TextEditingController();
  TextEditingController maxPersonValue = TextEditingController();
  TextEditingController dateStart = TextEditingController();
  TextEditingController dateEnd = TextEditingController();

  String paymentAccountValue = '';
  void handlePaymentValue(String value) {
    // Do something with the selected category in this class
    setState(() {
      paymentAccountValue = value;
    });
    print("paymentAccount set: ${paymentAccountValue}");
  }

  String bankCodeValue = '';
  void handleBankCodeValue(String value) {
    // Do something with the selected category in this class
    setState(() {
      bankCodeValue = value;
    });
    print("bankCodeValue set: ${bankCodeValue}");
  }

  String selectedCategoryValue = '';
  void handleSelectedCategoryValue(String value) {
    // Do something with the selected category in this class
    setState(() {
      selectedCategoryValue = value;
    });
    print("selectedCategoryValue set: ${selectedCategoryValue}");
  }

  @override
  void initState() {
    Get.put(FeedsController());
    super.initState();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get.put<UserAuthController>;

    final controller = Get.find<FeedsController>();

    List<Widget> imageSliders = imageList
        .map((item) => Container(
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: Stack(
          children: [
            Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Image.file(
                    item,
                    fit: BoxFit.cover,
                  )),
            ),
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: 0,
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        imageList
                            .removeWhere((element) => element == item);
                      });
                    },
                    iconSize: 30,
                    icon: Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                    ),
                  ),
                )),
          ],
        ),
      ),
    ))
        .toList();

    Widget uploadImage() {
      return Container(
        height: 200,
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(vertical: 27, horizontal: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: containerPostColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () async {
                        print("hello");
                        await takePhoto();
                      },
                      iconSize: 30,
                      icon: Icon(
                        Icons.camera_enhance_rounded,
                        color: Colors.black38,
                      )),
                  VerticalDivider(
                    color: Colors.black38,
                    thickness: 1,
                  ),
                  IconButton(
                      onPressed: () async {
                        print("hello");
                        await getImage();
                      },
                      iconSize: 30,
                      icon: Icon(
                        Icons.file_upload_outlined,
                        color: Colors.black38,
                      )),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Tap to choose",
                  style: primaryTextStylePlusJakartaSans.copyWith(
                      color: Color(0xffA1A1A1), fontSize: 10),
                ),
                Text(
                  "Image",
                  style: primaryTextStylePlusJakartaSans.copyWith(
                      color: textButtonSecondaryColor, fontSize: 10),
                ),
              ],
            )
          ],
        ),
      );
    }

    if (imageList.length < 3) {
      imageSliders.add(uploadImage());
    }

    Widget description() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.typePost == 'feed' ? "Description" : "Description *",
            style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 12, fontWeight: semibold),
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            width: double.infinity,
            height: 100,
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: containerPostColor,
            ),
            child: TextFormField(
              textAlign: TextAlign.justify,
              style: primaryTextStylePlusJakartaSans.copyWith(fontSize: 12),
              maxLines: 6,
              controller: descriptionController,
              decoration: InputDecoration.collapsed(
                hintText: "Type Here...",
                hintStyle: primaryTextStylePlusJakartaSans.copyWith(
                    color: Color(0xffA1A1A1), fontSize: 12),
              ),
            ),
          ),
        ],
      );
    }

    Widget location() {
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.typePost == 'feed' ? "Location" : "Location *",
              style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 12,
                fontWeight: semibold,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              width: double.infinity,
              height: 40,
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: containerPostColor,
              ),
              child: ValueListenableBuilder<String>(
                valueListenable: searchText,
                builder: (context, value, child) {
                  return TextFormField(
                    scrollPadding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).viewInsets.bottom),
                    controller: locationController,
                    onChanged: (newValue) {
                      searchText.value = newValue;
                      getPlaces(newValue);
                    },
                    textAlign: TextAlign.justify,
                    style:
                    primaryTextStylePlusJakartaSans.copyWith(fontSize: 12),
                    maxLines: 1,
                    decoration: InputDecoration.collapsed(
                      hintText: "Type Here...",
                      hintStyle: primaryTextStylePlusJakartaSans.copyWith(
                        color: Color(0xffA1A1A1),
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
            ),
            places.length != 0
                ? Container(
              margin: EdgeInsets.only(top: 5),
              width: double.infinity,
              height: 400,
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: containerPostColor,
              ),
              child: ListView(
                children: [
                  ...places
                      .map((place) => LocationItem(
                    place: place,
                    locationController: locationController,
                    onClearPlaces: clearPlaces,
                  ))
                      .toList(),
                ],
              ),
            )
                : Container(),
          ],
        ),
      );
    }

    if (imageList.isNotEmpty) print('imageList: ${imageList.length}');

    Widget meetingPoint() {
      return Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Meeting Point *",
              style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 12,
                fontWeight: semibold,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              width: double.infinity,
              height: 40,
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: containerPostColor,
              ),
              child: ValueListenableBuilder<String>(
                valueListenable: searchTextMeet,
                builder: (context, value, child) {
                  return TextFormField(
                    scrollPadding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).viewInsets.bottom),
                    controller: meetingPointController,
                    onChanged: (newValue) {
                      searchTextMeet.value = newValue;
                      getPlacesMeet(newValue);
                    },
                    textAlign: TextAlign.justify,
                    style:
                    primaryTextStylePlusJakartaSans.copyWith(fontSize: 12),
                    maxLines: 1,
                    decoration: InputDecoration.collapsed(
                      hintText: "Type Here...",
                      hintStyle: primaryTextStylePlusJakartaSans.copyWith(
                        color: Color(0xffA1A1A1),
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
            ),
            placesMeet.length != 0
                ? Container(
              margin: EdgeInsets.only(top: 5),
              width: double.infinity,
              height: 400,
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: containerPostColor,
              ),
              child: ListView(
                children: [
                  ...placesMeet
                      .map((place) => LocationItem(
                    place: place,
                    locationController: meetingPointController,
                    onClearPlaces: clearPlacesMeet,
                  ))
                      .toList(),
                ],
              ),
            )
                : Container(),
          ],
        ),
      );
    }

    Widget footer() {
      return Column(
        children: [
          Row(children: [
            TripCategoryWidget(
              onHandleChange: handleSelectedCategoryValue,
              selectedCategory: selectedCategoryValue,
            ),
            SizedBox(width: 10),
            FeeWidget(
              feeValue: feeValue,
            )
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DateWidget(
                dateEnd: dateEnd,
                dateStart: dateStart,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    MaxPersonWidget(maxPersonValue: maxPersonValue),
                    PaymentAccount(
                      paymentAccountValue: paymentAccountValue,
                      onHandleChange: handlePaymentValue,
                      bankCodeValue: bankCodeValue,
                      onBankCode: handleBankCodeValue,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      );
    }

    Widget openTripPost() {
      return Column(
        children: [
          TitleWidget(
            titleValue: titleValue,
          ),
          description(),
          location(),
          meetingPoint(),
          IncludeWidget(includeValue: includeValue),
          ExcludeWidget(excludeValue: excludeValue),
          OthersWidget(otherValue: otherValue),
          footer()
        ],
      );
    }

    Widget userPost() {
      return Column(
        children: [
          description(),
          location(),
        ],
      );
    }

    return controller.obx(
          (state) {
        return Center(child: Text('success'));
      },
      onError: (error) => Center(child: Text(error.toString())),
      onLoading: Center(child: LoadingWidget()),
      onEmpty: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 15),
          // Ukuran tinggi AppBar dengan margin vertical
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20), // Margin horizontal
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(widget.typePost == 'feeds'
                  ? "Post Feed Photo"
                  : "Post a Open Trip"),
              titleTextStyle: TextStyle(
                  fontWeight: semibold, color: textPrimaryColor, fontSize: 16),
              centerTitle: true,
              iconTheme: IconThemeData(color: textPrimaryColor),
              actions: [
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {
                    print("title: ${titleValue.text}");
                    print("includeValue: ${includeValue.text}");
                    print("excludeValue: ${excludeValue.text}");
                    print("otherValue: ${otherValue.text}");
                    print("feeValue: ${feeValue.text}");
                    print("maxPersonValue: ${maxPersonValue.text}");
                    print(
                        "paymentAccountValue: ${bankCodeValue + ' ' + paymentAccountValue}");
                    print("selectedCategoryValue: ${selectedCategoryValue}");
                    print("dateStart: ${dateStart.text}");
                    print("dateEnd: ${dateEnd.text}");

                    if (widget.typePost == 'feed') {
                      Get.find<FeedsController>().create(
                          descriptionController.text,
                          locationController.text,
                          imageList);
                    } else {
                      Get.find<FeedsController>().createTrips(
                        titleValue.text,
                        descriptionController.text,
                        locationController.text,
                        imageList,
                        meetingPointController.text,
                        includeValue.text,
                        excludeValue.text,
                        otherValue.text,
                        selectedCategoryValue,
                        dateStart.text,
                        dateEnd.text,
                        paymentAccountValue,
                        double.parse(
                            feeValue.text != ''?
                            feeValue.text.replaceAll(RegExp(r'[^\d]'), ''): '0'),
                        int.parse(maxPersonValue.text != '' ? maxPersonValue.text : '0'),
                      );
                    }
                  },
                  child: Text(
                    "Done",
                    style: buttonSecondaryTextStyle.copyWith(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              toolbarHeight: kToolbarHeight + 15,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 35),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      imageList.isNotEmpty
                          ? FeedsCarousel(imageSliders)
                          : uploadImage(),
                      widget.typePost == 'open trip'
                          ? openTripPost()
                          : userPost()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}