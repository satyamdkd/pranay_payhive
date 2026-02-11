import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  String userTypeKey = "USERTYPE";
  String userIdKey = "USER";
  String tokenKey = "TOKEN";
  String tempMobileKey = "TEMP_EMAIL";
  String mapStarted = "MAP_STARTED";

  final Future<SharedPreferences> sharedPref = SharedPreferences.getInstance();

  void saveUserType({userData}) async {
    final SharedPreferences prefs = await sharedPref;
    await prefs.setString(userTypeKey, json.encode(userData));
  }

  Future getUserType() async {
    final SharedPreferences prefs = await sharedPref;

    if (prefs.getString(userTypeKey) != null) {
      return prefs.getString(userTypeKey);
    } else {
      return null;
    }
  }

  void saveUser({userData}) async {
    final SharedPreferences prefs = await sharedPref;
    await prefs.setString(userIdKey, jsonEncode(userData));
    debugPrint("USER SAVED");
  }

  Future getUser() async {
    final SharedPreferences prefs = await sharedPref;

    if (prefs.getString(userIdKey) != null) {
      return prefs.getString(userIdKey);
    } else {
      return null;
    }
  }

  void saveToken({String? myToken}) async {
    final SharedPreferences prefs = await sharedPref;
    await prefs.setString(tokenKey, myToken!);
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await sharedPref;
    final String? action = prefs.getString(tokenKey);
    return action;
  }

  void saveTempMobile({String? mobile}) async {
    final SharedPreferences prefs = await sharedPref;
    await prefs.setString(tempMobileKey, mobile!);
  }

  Future<String?> getTempMobile() async {
    final SharedPreferences prefs = await sharedPref;
    if (prefs.getString(tempMobileKey) != null) {
      return prefs.getString(tempMobileKey);
    } else {
      return null;
    }
  }

  void saveMapStarted({String? startedOrNot}) async {
    final SharedPreferences prefs = await sharedPref;
    await prefs.setString(mapStarted, startedOrNot!);
  }

  Future<String?> getMapStarted() async {
    final SharedPreferences prefs = await sharedPref;
    if (prefs.getString(mapStarted) != null) {
      return prefs.getString(mapStarted);
    } else {
      return null;
    }
  }

  clearSharedPref() async {
    final SharedPreferences prefs = await sharedPref;
    await prefs.remove(userTypeKey);
    await prefs.remove(tempMobileKey);
    await prefs.remove(userTypeKey);
    await prefs.remove(userIdKey);
    await prefs.remove(tokenKey);
  }

  clearTempMobile() async {
    final SharedPreferences prefs = await sharedPref;
    await prefs.remove(tempMobileKey);
  }

  clearMap() async {
    final SharedPreferences prefs = await sharedPref;
    await prefs.remove(mapStarted);
  }

  logout() async {
    final SharedPreferences prefs = await sharedPref;
    await prefs.remove(userTypeKey);
    await prefs.remove(tempMobileKey);
    await prefs.remove(userTypeKey);
    await prefs.remove(userIdKey);
    await prefs.remove(tokenKey);
  }
}
