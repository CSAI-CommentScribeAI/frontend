import 'package:flutter/material.dart';
import 'package:frontend/owner/models/menu_model.dart';
import 'package:frontend/owner/services/menu_service.dart';

class MenuProvider with ChangeNotifier {
  final List<AddMenuModel> _menuList = [];

  List<AddMenuModel> get menuList => _menuList;

  // 가게별 메뉴 조회
  Future<void> getMenus(int storeId) async {
    List<AddMenuModel> getMenuList = await MenuService().getMenus(storeId);

    _menuList.clear();

    for (var menu in getMenuList) {
      _menuList.add(menu);
    }
    notifyListeners();
  }
}
