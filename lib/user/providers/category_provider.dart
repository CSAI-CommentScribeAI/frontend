import 'package:flutter/material.dart';
import 'package:frontend/user/models/category_model.dart';
import 'package:frontend/user/services/selectCategory_service.dart';

class CategoryProvider with ChangeNotifier {
  final List<CategoryModel> _categoryList = [];

  List<CategoryModel> get categoryList => _categoryList;

  Future<void> getCategory() async {
    List<CategoryModel> getCategoryList =
        await SelectCategoryService().getCategory();

    _categoryList.clear();

    for (var category in getCategoryList) {
      _categoryList.add(category);
    }
    notifyListeners();
  }
}
