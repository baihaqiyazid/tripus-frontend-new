import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tripusfrontend/app/data/models/user_model.dart';
import 'package:tripusfrontend/app/data/static_data.dart';
import 'package:tripusfrontend/app/helpers/avatar_custom.dart';
import 'package:tripusfrontend/app/helpers/loading_widget.dart';

import '../../../controllers/user_auth_controller.dart';
import '../../../helpers/theme.dart';
import '../../main-profile/controllers/main_profile_controller.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends StatefulWidget {
  EditProfileView({Key? key}) : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final controller = Get.find<EditProfileController>();

  List<DateTime?> _dates = [];

  User user = User.fromJson(StaticData.box.read('user'));
  dynamic imageBackground;
  dynamic imageProfile;

  Future takePhoto(bool isProfile) async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
        source: ImageSource.camera, maxHeight: 2000, maxWidth: 2000);
    if (photo != null) {
      print("photo ${photo}");
      setState(() {
        if (isProfile) {
          imageProfile = File(photo.path);
          print("photo path ${imageProfile}");
        } else {
          imageBackground = File(photo.path);
          print("photo path ${imageBackground}");
        }
      });
    }

    Get.back();
  }

  Future getImage(bool isProfile) async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    print("photo ${photo}");
    if (photo != null) {
      setState(() {
        if (isProfile) {
          imageProfile = File(photo.path);
          print("photo path ${imageProfile}");
        } else {
          imageBackground = File(photo.path);
          print("photo path ${imageBackground}");
        }
      });
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    Widget uploadPhoto(bool isProfile) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(64),
              topLeft: Radius.circular(64),
            ),
            color: Colors.white),
        height: 100,
        child: Column(
          children: [
            Text(
              'Change From',
              style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => takePhoto(isProfile),
                  child: Text(
                    'Take Photo',
                    style: primaryTextStylePlusJakartaSans.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => getImage(isProfile),
                  child: Text(
                    'Upload Photo',
                    style: primaryTextStylePlusJakartaSans.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    Widget header() {
      return Stack(
        alignment: Alignment.topCenter,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              imageBackground != null
                  ? Image.file(
                      imageBackground!,
                      width: double.infinity,
                      height: Get.size.height * 0.32,
                      fit: BoxFit.cover,
                    )
                  : user.backgroundImageUrl != null
                      ? Image.network(urlImage + user.backgroundImageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: Get.size.height * 0.32, loadingBuilder:
                              (BuildContext context, Widget child,
                                  ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            // Image is fully loaded
                            return child;
                          } else {
                            // Image is still loading, show a loading widget
                            return SkeletonAvatar(
                              style: SkeletonAvatarStyle(
                                  width: double.infinity,
                                  height: Get.size.height * 0.32),
                            ); // Replace with your LoadingWidget
                          }
                        })
                      : Image.asset(
                          'assets/feeds_example.png',
                          width: double.infinity,
                          height: Get.size.height * 0.32,
                          fit: BoxFit.cover,
                        ),
              GestureDetector(
                onTap: () => Get.bottomSheet(uploadPhoto(false)),
                child: Column(children: [
                  Icon(
                    Icons.camera_enhance_rounded,
                    color: Colors.black,
                  ),
                  Text(
                    'Change Background',
                    style: primaryTextStylePlusJakartaSans.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Get.bottomSheet(uploadPhoto(true));
            },
            child: Container(
              margin: EdgeInsets.only(top: Get.size.height * 0.26),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  imageProfile != null
                      ? CircleAvatar(
                          radius:
                              50, // Set the radius to control the size of the circle
                          backgroundImage: FileImage(imageProfile!),
                        )
                      : user.profilePhotoPath != null
                          ? CircleAvatar(
                              radius:
                                  50, // Set the radius to control the size of the circle
                              backgroundImage: NetworkImage(
                                  urlImage + user.profilePhotoPath!),
                            )
                          : AvatarCustom(
                              name: user.name!,
                              width: 80,
                              height: 80,
                              color: Colors.white,
                              fontSize: 40,
                              radius: 50),
                  Icon(
                    Icons.camera_enhance_rounded,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          )
        ],
      );
    }

    Widget nameInput() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name',
            style: primaryTextStylePlusJakartaSans.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            width: 200,
            padding: EdgeInsets.only(
              bottom: 10,
            ),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: textHintColor, width: 0.4))),
            child: TextFormField(
              style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              controller: controller.name,
              decoration: InputDecoration.collapsed(
                  hintText: user.name!,
                  hintStyle: primaryTextStylePlusJakartaSans.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  )),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      );
    }

    Widget bioInput() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Bio',
            style: primaryTextStylePlusJakartaSans.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            width: 200,
            padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: textHintColor, width: 0.4))),
            child: TextFormField(
              controller: controller.bio,
              style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration.collapsed(
                  hintText: user.bio ?? "Add bio",
                  hintStyle: user.bio != null
                      ? primaryTextStylePlusJakartaSans.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )
                      : primaryTextStylePlusJakartaSans.copyWith(
                          fontSize: 15, color: textHintColor)),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      );
    }

    Widget linkInput() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Links',
            style: primaryTextStylePlusJakartaSans.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            width: 200,
            padding: EdgeInsets.only(bottom: 10),
            child: TextFormField(
              controller: controller.links,
              style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration.collapsed(
                  hintText: user.links ?? "Add links",
                  hintStyle: user.links != null
                      ? primaryTextStylePlusJakartaSans.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )
                      : primaryTextStylePlusJakartaSans.copyWith(
                          fontSize: 15, color: textHintColor)),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      );
    }

    Widget emailInput() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email',
            style: primaryTextStylePlusJakartaSans.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            width: 200,
            padding: EdgeInsets.only(
              bottom: 10,
            ),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: textHintColor, width: 0.4))),
            child: TextFormField(
              controller: controller.email,
              style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration.collapsed(
                  hintText: user.email,
                  hintStyle: primaryTextStylePlusJakartaSans.copyWith(
                      fontSize: 15, fontWeight: FontWeight.bold)),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      );
    }

    Widget phoneInput() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Phone',
            style: primaryTextStylePlusJakartaSans.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            width: 200,
            padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: textHintColor, width: 0.4))),
            child: TextFormField(
              controller: controller.phone,
              style: primaryTextStylePlusJakartaSans.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration.collapsed(
                  hintText: user.phoneNumber ?? "Add your phone number",
                  hintStyle: user.phoneNumber != null
                      ? primaryTextStylePlusJakartaSans.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )
                      : primaryTextStylePlusJakartaSans.copyWith(
                          fontSize: 15, color: textHintColor)),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      );
    }

    Widget birthdayInput() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Birthday',
            style: primaryTextStylePlusJakartaSans.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.defaultDialog(
                  title: 'Select Date',
                  content: Container(
                    width: Get.size.width,
                    child: CalendarDatePicker2WithActionButtons(
                      onCancelTapped: () {
                        Get.back();
                      },
                      onOkTapped: () {
                        if (_dates.length > 0) {
                          print("date ${_dates.first}");
                        }
                        Get.back();
                      },
                      config: CalendarDatePicker2WithActionButtonsConfig(
                        lastDate: DateTime(2005, 12, 31),
                      ),
                      value: _dates,
                      onValueChanged: (dates) {
                        setState(() {
                          _dates = dates;
                        });
                      },
                    ),
                  ));
            },
            child: Container(
              width: 200,
              padding: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                enabled: false,
                style: primaryTextStylePlusJakartaSans.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration.collapsed(
                    hintText: _dates.length > 0
                        ? _dates.first.toString().substring(0, 10)
                        : user.birthdate != null
                            ? user.birthdate.toString()
                            : "Add your birthday",
                    hintStyle: _dates.length > 0 || user.birthdate != null
                        ? primaryTextStylePlusJakartaSans.copyWith(
                            fontSize: 15, fontWeight: FontWeight.bold)
                        : primaryTextStylePlusJakartaSans.copyWith(
                            fontSize: 15, color: textHintColor)),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ],
      );
    }

    Widget body() {
      return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Text(
                    'Cancel',
                    style: primaryTextStylePlusJakartaSans.copyWith(
                        fontSize: 15,
                        fontWeight: medium,
                        color: textSecondaryColor),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.find<UserAuthController>().updateProfile(
                        name: controller.name.text != ''
                            ? controller.name.text
                            : user.name,
                        email: controller.email.text != ''
                            ? controller.email.text
                            : user.email,
                        bio: controller.bio.text != ''
                            ? controller.bio.text
                            : user.bio,
                        links: controller.links.text != ''
                            ? controller.links.text
                            : user.links,
                        phone: controller.phone.text != ''
                            ? controller.phone.text
                            : user.phoneNumber,
                        birthdate: _dates.length > 0
                            ? _dates.first.toString().substring(0, 10)
                            : null,
                        profilePhotoPath: imageProfile ?? null,
                        backgroundImageUrl: imageBackground ?? null);
                  },
                  child: Text(
                    'Done',
                    style: primaryTextStylePlusJakartaSans.copyWith(
                      fontSize: 15,
                      fontWeight: semibold,
                      color: Colors.blueAccent,
                    ),
                  ),
                )
              ],
            ),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              header(),
              SizedBox(
                height: 10,
              ),
              Text(
                'Edit Profile',
                style: primaryTextStylePlusJakartaSans.copyWith(
                  fontSize: 15,
                  fontWeight: semibold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 10, bottom: 10, left: 50, right: 50),
                child: Column(
                  children: [
                    nameInput(),
                    SizedBox(
                      height: 10,
                    ),
                    bioInput(),
                    SizedBox(
                      height: 10,
                    ),
                    linkInput()
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 50),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Personal Information',
                    style: primaryTextStylePlusJakartaSans.copyWith(
                      fontSize: 15,
                      fontWeight: semibold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 10, bottom: 10, left: 50, right: 50),
                child: Column(
                  children: [
                    emailInput(),
                    SizedBox(
                      height: 10,
                    ),
                    phoneInput(),
                    SizedBox(
                      height: 10,
                    ),
                    birthdayInput(),
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
            ],
          ),
        ),
      );
    }

    return Get.find<UserAuthController>().obx((state) {
      return body();
    },
        onEmpty: body(),
        onLoading: Center(
          child: LoadingWidget(),
        ));
  }
}
