class SelectCategoryModel {
  final String category;
  final double rating;
  final int minOrder; // 최소 주문 필드 추가
  final String name; // 가게 이름

  SelectCategoryModel({
    required this.category,
    required this.rating,
    required this.minOrder, // 최소 주문 필드 추가
    required this.name, // 최소 주문 필드 추가
  });

  factory SelectCategoryModel.fromJson(Map<String, dynamic> json) {
    return SelectCategoryModel(
      category: json['category'] ?? '',
      rating: (json['rating'] is double
              ? json['rating']
              : double.tryParse(json['rating']?.toString() ?? '0.0')) ??
          0.0,
      minOrder: json['minOrder'] ?? 0, // JSON 데이터에서 최소 주문 필드 추출
      name: json['name'] ?? '',
    );
  }
}
