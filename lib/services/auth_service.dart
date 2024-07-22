import 'package:guard_client/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import 'dart:convert';

class AuthService {
  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.accessTokenKey, token);
  }

  Future<void> saveUserDetail(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        AppConstants.userDetailKey, jsonEncode(user.toJson()));
    print('user detail saved');
    print(user.toJson());
  }

  Future<UserModel?> getUserDetail() async {
    final prefs = await SharedPreferences.getInstance();
    final userDetail = await prefs.getString(AppConstants.userDetailKey);
    if (userDetail != null) {
      return UserModel.fromJson(jsonDecode(userDetail));
    }
    return null;
  }

  Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.refreshTokenKey, token);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.refreshTokenKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.accessTokenKey);
    await prefs.remove(AppConstants.refreshTokenKey);
  }

  Future<bool> isAccessTokenValid() async {
    final token = await getAccessToken();
    if (token == null) return false;
    return true;
  }
}
