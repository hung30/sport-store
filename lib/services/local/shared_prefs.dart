import 'dart:convert';

import 'package:ck/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final String keyUser = "keyUser";
  final bool isLogin = false;

  Future<List<UserModel>?> getUserList() async {
    SharedPreferences prefs = await _prefs;
    String? data = prefs.getString(keyUser);
    if (data == null) return null;

    List<dynamic> jsonData = jsonDecode(data);
    List<Map<String, dynamic>> maps = jsonData.cast<Map<String, dynamic>>();

    return maps.map((e) => UserModel.fromJson(e)).toList();
  }

  Future<void> saveUserList(List<UserModel> userList) async {
    SharedPreferences prefs = await _prefs;
    List<Map<String, dynamic>> maps = userList.map((e) => e.toJson()).toList();
    prefs.setString(keyUser, jsonEncode(maps));
  }

  Future<bool> updateUserPassword(String id, String newPassword) async {
    SharedPreferences prefs = await _prefs;
    String? data = prefs.getString(keyUser);
    if (data == null) return false;

    List<dynamic> jsonData = jsonDecode(data);
    List<Map<String, dynamic>> maps = jsonData.cast<Map<String, dynamic>>();
    List<UserModel> usersList = maps.map((e) => UserModel.fromJson(e)).toList();

    bool userFound = false;
    for (UserModel user in usersList) {
      if (user.id == id) {
        user.password = newPassword;
        userFound = true;
        break;
      }
    }

    if (!userFound) return false;

    List<Map<String, dynamic>> updatedMaps =
        usersList.map((e) => e.toJson()).toList();
    String updatedData = jsonEncode(updatedMaps);
    await prefs.setString(keyUser, updatedData);

    return true;
  }

  Future<bool> getIsLogin() async {
    SharedPreferences prefs = await _prefs;
    return prefs.getBool('isLogin') ?? false;
  }

  Future<void> setIsLogin(bool value) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setBool('isLogin', value);
  }

  Future<String> getLoginUsername() async {
    SharedPreferences prefs = await _prefs;
    return prefs.getString('username') ?? '';
  }

  Future<void> setLoginUsername(String value) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setString('username', value);
  }
}
