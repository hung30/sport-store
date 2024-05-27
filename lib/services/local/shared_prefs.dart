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
    print('object $data');

    List<dynamic> jsonData = jsonDecode(data);
    List<Map<String, dynamic>> maps = jsonData.cast<Map<String, dynamic>>();

    return maps.map((e) => UserModel.fromJson(e)).toList();
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
