// 별점 때 가져올 카테고리별 가게 조회용 모델
class SelectCategoryModel {
  final String category;
  final String name;
  final int minOrderPrice; // 최소 주문 필드 추가
  final double rating;
  final String storeImageUrl;

  SelectCategoryModel({
    required this.category,
    required this.name,
    required this.minOrderPrice, // 최소 주문 필드 추가
    required this.rating, // 최소 주문 필드 추가
    required this.storeImageUrl,
  });

  factory SelectCategoryModel.fromJson(Map<String, dynamic> json) {
    return SelectCategoryModel(
      category: json['category'] ?? '',
      name: json['name'] ?? '',
      minOrderPrice: json['minOrderPrice'] ?? 0, // JSON 데이터에서 최소 주문 필드 추출
      rating: (json['rating'] is double
              ? json['rating']
              : double.tryParse(json['rating']?.toString() ?? '0.0')) ??
          0.0,
      storeImageUrl: json['storeImageUrl'] ?? '',
    );
  }
}
