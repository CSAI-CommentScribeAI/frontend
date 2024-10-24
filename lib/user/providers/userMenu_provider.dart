import 'package:flutter/material.dart';
import 'package:frontend/owner/models/menu_model.dart';
import 'package:frontend/user/services/userMenu_service.dart';

class UserMenuProvider with ChangeNotifier {
  final List<AddMenuModel> _userMenuList = [];

  List<AddMenuModel> get userMenuList => _userMenuList;

  // 가게별 메뉴 전체 조회
  Future<void> fetchMenus(int storeId) async {
    List<AddMenuModel> getUserMenuList =
        await UserMenuService().fetchMenus(storeId);

    _userMenuList.clear();

    for (var userMenu in getUserMenuList) {
      _userMenuList.add(userMenu);
    }

    notifyListeners();
  }
}
