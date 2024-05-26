class StoreModel {
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
  final String endTime;

  StoreModel({
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
    required this.endTime,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      businessLicense: json['businessLicense'] ?? '',
      name: json['name'] ?? '',
      info: json['info'] ?? '',
      category: json['category'] ?? '',
      minOrderPrice: json['minOrderPrice'] ?? 0,
      fullAddress: json['fullAddress'] ?? '',
      roadAddress: json['roadAddress'] ?? '',
      jibunAddress: json['jibunAddress'] ?? '',
      postalCode: json['postalCode'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      openTime: json['openTime'] ?? '',
      endTime: json['endTime'] ?? '',
    );
  }
}
