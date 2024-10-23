class CategoryModel {
  final String category;
  final String categoryKo;

  CategoryModel({
    required this.category,
    required this.categoryKo,
  });

  CategoryModel.fromJson(Map<String, dynamic> json)
      : category = json['category'] ?? '',
        categoryKo = json['categoryKo'] ?? '';
}
