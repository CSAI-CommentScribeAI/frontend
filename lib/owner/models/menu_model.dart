class MenuModel {
  final String name;
  final int price;
  final String menuDetail;
  final String menuFile;
  final String storeId;

  MenuModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        price = json['price'],
        menuDetail = json['menuDetail'],
        menuFile = json['menuFile'],
        storeId = json['storeId'];
}
