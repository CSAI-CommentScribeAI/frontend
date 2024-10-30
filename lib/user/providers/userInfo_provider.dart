import 'package:flutter/material.dart';
import 'package:frontend/user/services/userInfo_service.dart';

class UserInfoProvider with ChangeNotifier {
  Map<String, dynamic> _userInfo = {};

  Map<String, dynamic> get userInfo => _userInfo;

  // 유저 정보 검색
  Future<void> fetchUserInfo() async {
    Map<String, dynamic> getUserInfo = await UserInfoService().fetchUserInfo();

    _userInfo.clear();

    _userInfo = getUserInfo;
    notifyListeners();
  }
}
