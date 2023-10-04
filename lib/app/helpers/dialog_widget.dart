import 'package:flutter/material.dart';
import 'package:get/get.dart';

void dialogError(String msg) {
  Get.snackbar(
    'Oopss!!', 'Oopss!! ' + msg,
    titleText: Icon(Icons.warning_amber_rounded, size: 50,),
    messageText: Center(child: Text('Oopss!! ' + msg)),
  );
}