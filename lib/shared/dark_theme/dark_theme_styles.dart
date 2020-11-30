import 'dart:ui';

import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      textTheme: TextTheme().copyWith(
        bodyText2: TextStyle(color: isDarkTheme ? Colors.black : Colors.black), 
      ),
      scaffoldBackgroundColor: isDarkTheme ? Color(0xff252a2d) : Colors.white,
      primarySwatch: Colors.indigo,
      accentColor: Color(0xff3938d5),
      primaryColor: isDarkTheme ? Color(0xff1f2224) : Colors.white,
      backgroundColor: isDarkTheme ? Color(0xff252a2d) : Color(0xff3938d5),
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
      hintColor: isDarkTheme ? Colors.black: Colors.black,
      highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: AppBarTheme().copyWith(
          elevation: 0,
          color: isDarkTheme ? Color(0xff1f2224) : Color(0xff3938d5),
          textTheme: TextTheme(
              headline6: TextStyle()
                  .copyWith(color: isDarkTheme ? Colors.white : Colors.white,fontSize: 20,fontWeight: FontWeight.bold))),
    );
  }
}
