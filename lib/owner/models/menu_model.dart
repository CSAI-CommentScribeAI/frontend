class AddMenuModel {
  final String name;
  final int price;
  final String menuDetail;
  final String imageUrl;
  final String status;

  AddMenuModel({
    required this.name,
    required this.price,
    required this.menuDetail,
    required this.imageUrl,
    required this.status,
  });

  AddMenuModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        price = json['price'] ?? '',
        menuDetail = json['menuDetail'] ?? '',
        imageUrl = json['imageUrl'] ?? '',
        status = json['status'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'menuDetail': menuDetail,
      'imageUrl': imageUrl,
      'status': status,
    };
  }
}
