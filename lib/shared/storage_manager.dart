import 'dart:io';

import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class StorageManager {
  ///  eg:theme
  static SharedPreferences sharedPreferences;

  ///  eg: cookie
  static Directory temporaryDirectory;


  static LocalStorage localStorage;


  static init() async {
    // async 
    // sync 
    temporaryDirectory = await getTemporaryDirectory();
    sharedPreferences = await SharedPreferences.getInstance();
    localStorage = LocalStorage('LocalStorage');
    await localStorage.ready;
  }
}
