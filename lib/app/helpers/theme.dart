import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

String url = "https://tripus.id/public/api";
String urlImage = "https://tripus.id/public/";

// String url = "http://10.0.2.2:8000/public/api";
// String urlImage = "http://10.0.2.2:8000/public/";

Color backgroundColor = Color(0xffFFFFFF);
Color textPrimaryColor = Color(0xff191D21);
Color textSecondaryColor = Color(0xff656F77);
Color textButtonSecondaryColor = Color(0xff2F80ED);
Color textSenderBackgroundColor = Color(0xffEFEEEE);
Color textSenderColor = Color(0xff7D7A7A);
Color textHintColor = Color(0xffB5B5B5);
Color bottomNavigationColor = Color(0xff4F4F4F);
Color containerPostColor = Color(0xffF5F5F5);

TextStyle primaryTextStyle = GoogleFonts.nunito(
  color: textPrimaryColor,
);

TextStyle primaryTextStylePlusJakartaSans = GoogleFonts.plusJakartaSans(
  color: textPrimaryColor,
);

TextStyle secondaryTextStyle = GoogleFonts.nunito(
  color: textSecondaryColor,
);

TextStyle buttonPrimaryTextStyle = GoogleFonts.nunito(
  color: backgroundColor,
);

TextStyle buttonSecondaryTextStyle = GoogleFonts.nunito(
  color: textButtonSecondaryColor,
);

TextStyle hintTextStyle = GoogleFonts.nunito(
  color: textHintColor,
);

FontWeight semibold = FontWeight.w600;
FontWeight medium = FontWeight.w500;
FontWeight extraBold = FontWeight.w800;
