import 'package:shared_preferences/shared_preferences.dart';

import '../constants/string.dart';

class SharedPref {
  static Future setUserDetails(
      {required String name,
      required String email,
      required String url}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(userDetails, [name, email, url]);
  }

  static Future<List<String>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(userDetails) ?? [];
  }

  static Future clearSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
