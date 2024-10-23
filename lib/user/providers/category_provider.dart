import 'package:flutter/material.dart';
import 'package:frontend/owner/models/store_model.dart';
import 'package:frontend/user/models/category_model.dart';
import 'package:frontend/user/services/selectCategory_service.dart';

class CategoryProvider with ChangeNotifier {
  final List<CategoryModel> _categoryList = [];
  final List<StoreModel> _storeList = [];

  List<CategoryModel> get categoryList => _categoryList;
  List<StoreModel> get storeList => _storeList;

  // 카테고리 가져오기
  Future<void> getCategory() async {
    List<CategoryModel> getCategoryList =
        await SelectCategoryService().getCategory();

    _categoryList.clear();

    for (var category in getCategoryList) {
      _categoryList.add(category);
    }
    notifyListeners();
  }

  // 카테고리별 가게 조회
  Future<void> getSelectCategory(String category) async {
    List<StoreModel> getStoreList =
        await SelectCategoryService().getSelectCategory(category);

    _storeList.clear();

    for (var store in getStoreList) {
      _storeList.add(store);
    }
    notifyListeners();
  }
}
