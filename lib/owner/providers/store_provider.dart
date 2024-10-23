import 'package:flutter/material.dart';
import 'package:frontend/owner/models/store_model.dart';
import 'package:frontend/owner/services/store_service.dart';

class StoreProvider with ChangeNotifier {
  final List<StoreModel> _storeList = [];

  List<StoreModel> get storeList => _storeList;

  Future<void> getStore() async {
    try {
      List<StoreModel> getStoreList = await StoreService().getStore();

      for (var getStore in getStoreList) {
        _storeList.add(getStore);
      }
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
