import 'package:flutter/material.dart';
import 'package:frontend/user/services/userStore_service.dart';

class UserStoreProvider with ChangeNotifier {
  Map<String, dynamic> _store = {};

  Map<String, dynamic> get store => _store;

  // 가게 조회
  Future<void> getStore(int storeId) async {
    try {
      Map<String, dynamic> getStore =
          await UserStoreService().getStore(storeId);

      _store = getStore;

      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
