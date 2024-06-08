// orderMenus안의 정보들
class OrderMenu {
  final int menuId;
  final String menuName;
  final String imageUrl;
  final int quantity;

  OrderMenu({
    required this.menuId,
    required this.menuName,
    required this.imageUrl,
    required this.quantity,
  });

  factory OrderMenu.fromJson(Map<String, dynamic> json) {
    return OrderMenu(
      menuId: json['menuId'] ?? 0,
      menuName: json['menuName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuId': menuId,
      'menuName': menuName,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }
}
