import 'dart:ui' show Color;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AppColors {
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color initial = Color.fromRGBO(23, 43, 77, 1.0);
  static const Color primary = Color.fromARGB(255, 99, 164, 181);
  static const Color secondary = Color.fromRGBO(247, 250, 252, 1.0);
  static const Color label = Color.fromRGBO(158, 152, 154, 1);
  static const Color info = Color.fromRGBO(17, 205, 239, 1.0);
  static const Color error = Color.fromRGBO(198, 77, 101, 1);
  static const Color success = Color.fromRGBO(45, 206, 137, 1.0);
  static const Color warning = Color.fromRGBO(226, 210, 102, 1);
  static const Color header = Color.fromRGBO(82, 95, 127, 1.0);
  static const Color bgColorScreen = Color.fromRGBO(248, 249, 254, 1.0);
  static const Color border = Color.fromRGBO(202, 209, 215, 1.0);
  static const Color inputSuccess = Color.fromRGBO(123, 222, 177, 1.0);
  static const Color inputError = Color.fromRGBO(252, 179, 164, 1.0);
  static const Color muted = Color.fromRGBO(136, 152, 170, 1.0);
  static const Color text = Color(0xFF6C757D);
}

class AppMeasures {
  static const paddingApp = EdgeInsets.fromLTRB(5, 5, 5, 5);
}

class AppText {
  static TextStyle fontSize(double value) {
    return GoogleFonts.urbanist(fontSize: value);
  }

  static String capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  static String upperCase(String value) {
    if (value.isEmpty) return value;
    return value.toUpperCase();
  }

  static String currency(double value) {
    final number = NumberFormat("#,##0", "es_CO").format(value);
    return '\$ $number';
  }

  static final title2 = GoogleFonts.urbanist(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: Colors.black87,
  );

  static final headline = GoogleFonts.urbanist(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Colors.black,
    height: 1.2,
  );

  static final header = GoogleFonts.urbanist(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
    height: 1.3,
  );

  static final title = GoogleFonts.urbanist(
    fontSize: 18,
    fontWeight: FontWeight.w900,
    color: AppColors.primary,
  );

  static final subtitle = GoogleFonts.urbanist(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.grey[600],
  );

  static final body = GoogleFonts.urbanist(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static final caption = GoogleFonts.urbanist(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: Colors.grey[500],
  );

  static final button = GoogleFonts.urbanist(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static final link = GoogleFonts.urbanist(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF39D2C0),
    decoration: TextDecoration.underline,
  );

  static final error = GoogleFonts.urbanist(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Colors.red[600],
  );

  static final detail = GoogleFonts.urbanist(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.green[500],
  );

  static final bold = GoogleFonts.urbanist(fontWeight: FontWeight.bold);
}
