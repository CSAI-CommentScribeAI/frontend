// 하나의 가게 정보가 들어가있는 객체 형식의 클래스
class StoreModel {
  final int id;
  final String name;
  final String address;

  StoreModel({required this.id, required this.name, required this.address});

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
    );
  }
}
