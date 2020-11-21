import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_management_app/shared/storage_manager.dart';

//const Color(0xFF5394FF),

class ThemeModel with ChangeNotifier {
  static const kThemeColorIndex = 'kThemeColorIndex';
  static const kThemeUserDarkMode = 'kThemeUserDarkMode';
  static const kFontIndex = 'kFontIndex';

  static const fontValueList = ['system', 'kuaile'];

  bool _userDarkMode;

  MaterialColor _themeColor;

  int _fontIndex;

  ThemeModel() {
    _userDarkMode =
        StorageManager.sharedPreferences.getBool(kThemeUserDarkMode) ?? false;

    _themeColor = Colors.primaries[
        StorageManager.sharedPreferences.getInt(kThemeColorIndex) ?? 5];

    _fontIndex = StorageManager.sharedPreferences.getInt(kFontIndex) ?? 0;
  }

  int get fontIndex => _fontIndex;

  /// [brightness]
  void switchTheme({bool userDarkMode, MaterialColor color}) {
    _userDarkMode = userDarkMode ?? _userDarkMode;
    _themeColor = color ?? _themeColor;
    notifyListeners();
    saveTheme2Storage(_userDarkMode, _themeColor);
  }

  void switchRandomTheme({Brightness brightness}) {
    int colorIndex = Random().nextInt(Colors.primaries.length - 1);
    switchTheme(
      userDarkMode: Random().nextBool(),
      color: Colors.primaries[colorIndex],
    );
  }

  switchFont(int index) {
    _fontIndex = index;
    switchTheme();
    saveFontIndex(index);
  }

  /// * Dark Mode
  themeData({bool platformDarkMode: false}) {
    var isDark = platformDarkMode || _userDarkMode;
    Brightness brightness = isDark ? Brightness.dark : Brightness.light;

    var themeColor = _themeColor;
    var accentColor = isDark ? themeColor[800] : _themeColor;
    var scaffoldBackgroundColor = isDark ? Color(0xff1a1c22) : Colors.white;
    var themeData = ThemeData(
        brightness: brightness,
        primaryColorBrightness: Brightness.dark,
        accentColorBrightness: Brightness.dark,
        primarySwatch: themeColor,
        accentColor: accentColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        fontFamily: fontValueList[fontIndex]);

    themeData = themeData.copyWith(
      brightness: brightness,
      accentColor: Color(0xff3938d5),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: themeColor,
        brightness: brightness,
      ),

      appBarTheme: themeData.appBarTheme
          .copyWith(elevation: 0, color: Color(0xff3938d5)),
      splashColor: themeColor.withAlpha(50),
      hintColor: themeData.hintColor.withAlpha(90),
      errorColor: Colors.red,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: accentColor,
        selectionColor: accentColor.withAlpha(60),
        selectionHandleColor: accentColor.withAlpha(60),
      ),
      textTheme: themeData.textTheme.copyWith(
          subtitle1: themeData.textTheme.subhead
              .copyWith(textBaseline: TextBaseline.alphabetic)),
      toggleableActiveColor: accentColor,
      chipTheme: themeData.chipTheme.copyWith(
        pressElevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 10),
        labelStyle: themeData.textTheme.caption,
        backgroundColor: themeData.chipTheme.backgroundColor.withOpacity(0.1),
      ),
//          textTheme: CupertinoTextThemeData(brightness: Brightness.light)
      inputDecorationTheme: ThemeHelper.inputDecorationTheme(themeData),
    );
    return themeData;
  }

  /// 数据持久化到shared preferences
  saveTheme2Storage(bool userDarkMode, MaterialColor themeColor) async {
    var index = Colors.primaries.indexOf(themeColor);
    await Future.wait([
      StorageManager.sharedPreferences
          .setBool(kThemeUserDarkMode, userDarkMode),
      StorageManager.sharedPreferences.setInt(kThemeColorIndex, index)
    ]);
  }

  // static String fontName(index, context) {
  //   switch (index) {
  //     case 0:
  //       return S.of(context).autoBySystem;
  //     case 1:
  //       return S.of(context).fontKuaiLe;
  //     default:
  //       return '';
  //   }
  // }


  static saveFontIndex(int index) async {
    await StorageManager.sharedPreferences.setInt(kFontIndex, index);
  }
}


class ThemeHelper {
  static InputDecorationTheme inputDecorationTheme(ThemeData theme) {

    var primaryColor = theme.primaryColor;
    var dividerColor = theme.dividerColor;
    var errorColor = theme.errorColor;
    var disabledColor = theme.disabledColor;

    var width = 0.5;

    return InputDecorationTheme(
      hintStyle: TextStyle(fontSize: 14),
      errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: width, color: errorColor)),
      focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.7, color: errorColor)),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: width, color: primaryColor)),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: width, color: dividerColor)),
      border: UnderlineInputBorder(
          borderSide: BorderSide(width: width, color: dividerColor)),
      disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: width, color: disabledColor)),
    );
  }
}