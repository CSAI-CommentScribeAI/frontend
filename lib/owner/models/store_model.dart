class StoreModel {
  final int id;
  final String businessLicense;
  final String name;
  final String info;
  final String category;
  final int minOrderPrice;
  final String fullAddress;
  final String roadAddress;
  final String jibunAddress;
  final String postalCode;
  final double latitude;
  final double longitude;
  final String openTime;
  final String closeTime;
  final String storeImageUrl;

  StoreModel({
    required this.id,
    required this.businessLicense,
    required this.name,
    required this.info,
    required this.category,
    required this.minOrderPrice,
    required this.fullAddress,
    required this.roadAddress,
    required this.jibunAddress,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.openTime,
    required this.closeTime,
    required this.storeImageUrl,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] ?? 0,
      businessLicense: json['businessLicense'] ?? '',
      name: json['name'] ?? '',
      info: json['info'] ?? '',
      category: json['category'] ?? '',
      minOrderPrice: json['minOrderPrice'] ?? 0,
      fullAddress: json['storeAddress']?['fullAddress'] ??
          '', // fullAddress가 객체 storeAdress 안에 위치(storeAddress : {fullAddress: '주소 값'})
      roadAddress:
          json['storeAddress']?['roadAddress'] ?? '', // roadAddress도 동일
      jibunAddress:
          json['storeAddress']?['jibunAddress'] ?? '', // jibunAddress도 동일
      postalCode: json['storeAddress']?['postalCode'] ?? '',
      latitude: (json['storeAddress']?['latitude'] ?? 0.0).toDouble(),
      longitude: (json['storeAddress']?['longitude'] ?? 0.0).toDouble(),
      openTime: json['openTime'] ?? '',
      closeTime: json['closeTime'] ?? '',
      storeImageUrl: json['storeImageUrl'] ?? '',
    );
  }
}
