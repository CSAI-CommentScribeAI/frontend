import 'package:flutter/material.dart';
import 'package:frontend/owner/models/store_model.dart';
import 'package:frontend/owner/services/store_service.dart';

class StoreProvider with ChangeNotifier {
  StoreModel? _store;
  final List<StoreModel> _storeList = [];

  StoreModel? get store => _store;
  List<StoreModel> get storeList => _storeList;

  Future<void> getStores() async {
    try {
      List<StoreModel> getStoreList = await StoreService().getStores();

      _storeList.clear();

      for (var getStore in getStoreList) {
        _storeList.add(getStore);
      }
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getStore(int storeId) async {
    try {
      StoreModel getStore = await StoreService().getStore(storeId);

      _store = getStore;

      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
