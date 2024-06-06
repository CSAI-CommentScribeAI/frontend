class AddMenuModel {
  final int id;
  final int storeId;
  final String name;
  final int price;
  final String menuDetail;
  final String imageUrl;
  final String status;

  AddMenuModel({
    required this.id,
    required this.storeId,
    required this.name,
    required this.price,
    required this.menuDetail,
    required this.imageUrl,
    required this.status,
  });

  // 일반적인 키로 저장
  AddMenuModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        storeId = json['storeId'] ?? 0,
        name = json['name'] ?? '',
        price = json['price'] ?? 0,
        menuDetail = json['menuDetail'] ?? '',
        imageUrl = json['imageUrl'] ?? '',
        status = json['status'] ?? '';

  // 키 값에 따라 수정(id란 키로 저장을 했다가 menuId란 키로 바꿔서 저장)
  // 장바구니에 담을 키 값이 포스트맨 키 값과 동일하게 맞추기 위해 작성
  Map<String, dynamic> toCartMenu() {
    return {
      'menuId': id, // JSON 키를 'menuId'로 수정
      'storeId': storeId,
      'menuName': name, // JSON 키를 'menuName'으로 수정
      'menuDetail': menuDetail,
      'imageUrl': imageUrl, // JSON 키를 'imageUrl'로 수정
      'price': price,
      'status': status,
    };
  }
}
