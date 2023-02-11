import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class SharedPrefs {
  // get instance
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  // get string
  static Future<String?> getString(String key) async {
    final prefs = await _instance;
    return prefs.getString(key);
  }

  // set string
  static Future<bool> setString(String key, String value) async {
    final prefs = await _instance;
    return prefs.setString(key, value);
  }

  // get bool
  static Future<bool?> getBool(String key) async {
    final prefs = await _instance;
    return prefs.getBool(key);
  }

  // set bool
  static Future<bool> setBool(String key, bool value) async {
    final prefs = await _instance;
    return prefs.setBool(key, value);
  }

  // encode map to string
  static String encodeMapToString(Map<String, dynamic> value) {
    return convert.jsonEncode(value);
  }

  // decode string to map
  static Map<String, dynamic> decodeStringToMap(String value) {
    return convert.jsonDecode(value);
  }

  // clear
  static Future<bool> clear() async {
    final prefs = await _instance;
    return prefs.clear();
  }
}
