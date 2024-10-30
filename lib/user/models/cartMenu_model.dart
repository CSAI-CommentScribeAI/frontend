class CartMenuModel {
  final int menuId;
  final String menuName;
  final String imageUrl;
  final int price;

  CartMenuModel({
    required this.menuId,
    required this.menuName,
    required this.imageUrl,
    required this.price,
  });

  CartMenuModel.fromJson(Map<String, dynamic> json)
      : menuId = json['menuId'] ?? 0, // JSON 키를 'menuId'로 수정
        menuName = json['menuName'] ?? '', // JSON 키를 'menuName'으로 수정
        imageUrl = json['imageUrl'] ?? '', // JSON 키를 'imageUrl'로 수정
        price = json['price'] ?? 0;
}
