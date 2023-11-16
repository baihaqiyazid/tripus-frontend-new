import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:tripusfrontend/app/helpers/carousel_widget.dart';
import 'package:tripusfrontend/app/helpers/format_number.dart';
import 'package:tripusfrontend/app/helpers/loading_widget.dart';
import 'package:tripusfrontend/app/helpers/parseCurrencyToInteger.dart';
import 'package:tripusfrontend/app/modules/home/views/widget/date.dart';
import 'package:tripusfrontend/app/modules/home/views/widget/place_Search.dart';
import 'package:tripusfrontend/app/routes/app_pages.dart';

import '../../../controllers/feeds_controller.dart';
import '../../../helpers/convertMapToJson.dart';
import '../../../helpers/dialog_widget.dart';
import '../../../helpers/theme.dart';
import 'widget/title.dart';

class PostShareCostView extends StatefulWidget {
  PostShareCostView();

  @override
  State<PostShareCostView> createState() => _PostShareCostViewState();
}

class _PostShareCostViewState extends State<PostShareCostView> {
  List<MapBoxPlace> places = [];
  List<MapBoxPlace> placesMeet = [];
  double totalPriceCost = 0;

  int contentDetailsCount = 1;
  List<Widget> contentDetailsIndices = [];
  double heightDetail = 40;

  final _formKey = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController(text: '');

  static List<String> detailList = [];

  File? image;
  List<File> imageList = [];

  TextEditingController locationController = TextEditingController(text: '');

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
  TextEditingController feeValue = TextEditingController();
  TextEditingController dateStart = TextEditingController();
  TextEditingController dateEnd = TextEditingController();

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
    detailList.clear();
    detailList.add('{"text": "", "value": ""}');
    // contentDetailsIndices.add(contentDetails());
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

    Widget description() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description *",
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

    print("detailList.length: ${detailList.length}");

    Widget textfieldBtn(int index) {
      bool isLast = index == detailList.length - 1;

      return InkWell(
        onTap: () => setState(() {
          if(isLast){
            if(heightDetail <= 400){
              heightDetail += 40;
            }

            detailList.add('{"text": "", "value": ""}');
          }else{
            if(heightDetail - 40 <= 40){
              heightDetail = 40;
            }else{
              heightDetail -= 40;
            }
            detailList.removeAt(index);
          }
        }),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: isLast ? Colors.green : Colors.red,
          ),
          child: Icon(
            isLast ? Icons.add : Icons.remove,
            color: Colors.white,
          ),
        ),
      );
    }

    Widget contentDetails() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(top: 0),
              child: Text(
                "Details *",
                style: primaryTextStylePlusJakartaSans.copyWith(
                  fontSize: 12,
                  fontWeight: semibold,
                ),
              )),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  height: heightDetail,
                  width:
                      double.infinity, // Set a height according to your design
                  child: ListView.separated(
                    itemCount: detailList.length,
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, index) => Row(
                      children: [
                        Expanded(
                          child: DynamicTextfield(
                            key: UniqueKey(),
                            initialValue: detailList[index],
                            onChanged: (v) => detailList[index] = v,
                          ),
                        ),
                        const SizedBox(width: 20),
                        textfieldBtn(index),
                      ],
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 0,
                    ),
                  ),
                ),
                // submit button
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        print(detailList);
                      }
                      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(json.decode(detailList.toString().replaceAll(RegExp(r',\s*]$'), ']')));
                      // print("price detaile list: ${data[0]['value']}");
                      setState(() {
                        totalPriceCost = 0;
                        for(int i = 0; i < data.length; i++){
                          if(data[i]['value'] != ''){
                            totalPriceCost += parseRpToInteger(data[i]['value']);
                          }
                        }
                      });

                    },
                    child: Text('Submit Details'),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    }

    if (imageList.length < 3) {
      imageSliders.add(uploadImage());
    }

    Widget location() {
      return Container(
        margin: EdgeInsets.only(top: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Location *",
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

    Widget totalPrice(){
      return Container(
        margin: EdgeInsets.only(bottom: 50, top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total", style: primaryTextStylePlusJakartaSans.copyWith(
              fontWeight: FontWeight.bold,
            ),),
            const SizedBox(height: 10,),
            Center(
              child: Container(
                width: double.infinity,
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
                child: Center(
                  child: Text('Rp ${formatNumber(totalPriceCost)}', style: primaryTextStylePlusJakartaSans.copyWith(
                      fontWeight: FontWeight.bold, fontSize: 32
                  ),),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget buttonContinue(String message) {
      return ElevatedButton(
        onPressed: () {
          print("title: ${titleValue.text}");
          print("location: ${locationController.text}");
          print("others: ${detailList.toString()}");
          print("date start: ${dateStart.text}");
          print("date end: ${dateEnd.text}");
          print("fee: ${totalPriceCost}");
          print("description: ${descriptionController.text}");

          if (imageList.isEmpty) {
            dialogError("images required");
          } else if (titleValue.text == ''){
            dialogError("title field required");
          } else if (locationController.text == ''){
            dialogError("location field required");
          } else if (dateStart.text == '' || dateEnd.text == ''){
            dialogError("date field required");
          } else if (totalPriceCost == 0.0){
            dialogError("Price must be rather than zero");
          } else{
            Map<String, dynamic> shareCostPost = {
              "image_list": imageList,
              "title": titleValue.text,
              "description": descriptionController.text,
              "location": locationController.text,
              "others": detailList.toString(),
              "date_start": dateStart.text,
              "date_end": dateEnd.text,
              "fee": totalPriceCost
            };
            Get.toNamed(Routes.SPLIT_BILL, arguments: [totalPriceCost, shareCostPost]);
          }
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
              "Continue",
              style: buttonPrimaryTextStyle.copyWith(
                  fontSize: 22, fontWeight: semibold),
            ),
          ],
        ),
      );
    }

    Widget userPost() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(
            titleValue: titleValue,
          ),
          description(),
          location(),
          SizedBox(height: 10),
          contentDetails(),
          Row(
            children: [
              DateWidget(
                dateEnd: dateEnd,
                dateStart: dateStart,
              ),
            ],
          ),
          SizedBox(height: 10),
          totalPrice(),
          buttonContinue(''),
          SizedBox(height: 20),
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
              title: Text("Post a Share Cost"),
              titleTextStyle: TextStyle(
                  fontWeight: semibold, color: textPrimaryColor, fontSize: 16),
              centerTitle: true,
              iconTheme: IconThemeData(color: textPrimaryColor),
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
                      userPost()
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

class DynamicTextfield extends StatefulWidget {
  final String? initialValue;
  final void Function(String) onChanged;

  const DynamicTextfield({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<DynamicTextfield> createState() => _DynamicTextfieldState();
}

class _DynamicTextfieldState extends State<DynamicTextfield> {
  late final TextEditingController _controller;
  late final TextEditingController _controller2;

  // String detail = "{'text': 'init', 'value':2000}";

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller2 = TextEditingController();
    Map<String, dynamic> detailMap = parseStringToMap(widget.initialValue != ''
        ? widget.initialValue!
        : '{"text": "", "value": ""}');
    // print(detailMap['text']);
    _controller.text = detailMap['text'] ?? '';
    _controller2.text = detailMap['value'] ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }

  String concatenateValues() {
    return '{"text": "${_controller.text}", "value":"${_controller2.text}"}';
  }

  // Remove single quotes around keys and convert to valid JSON string

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: containerPostColor,
              ),
              child: TextFormField(
                controller: _controller,
                onChanged: (v) {
                  setState(() {
                    widget.onChanged(concatenateValues());
                  });
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
                validator: (v) {
                  if (v == null || v.trim().isEmpty)
                    return 'Please enter something';
                  return null;
                },
              ),)
          ),
          const SizedBox(
            width: 5,
          ),
          Container(
            width: 100,
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: containerPostColor,
            ),
            child: TextFormField(
              controller: _controller2,
              onChanged: (v) {
                setState(() {
                  widget.onChanged(concatenateValues());
                });
              },
              inputFormatters: [
                CurrencyTextInputFormatter(
                  locale: 'id',
                  decimalDigits: 0,
                  symbol: 'Rp ',
                ),
              ],
              textAlign: TextAlign.justify,
              style: primaryTextStylePlusJakartaSans.copyWith(fontSize: 12),
              keyboardType: TextInputType.number,
              maxLines: 1,
              decoration: InputDecoration.collapsed(
                hintText: "Rp. 0",
                hintStyle: primaryTextStylePlusJakartaSans.copyWith(
                  color: Color(0xffA1A1A1),
                  fontSize: 12,
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty)
                  return 'Please enter something';
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
