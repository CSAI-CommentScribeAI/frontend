// 하나의 가게 정보가 들어가있는 객체 형식의 클래스
import 'dart:io';

class StoreModel {
  final String businessLicense,
      name,
      info,
      category,
      minOrderPrice,
      fullAddress;
  final File logo;

  StoreModel.fromJson(Map<String, dynamic> json)
      : businessLicense = json['businessLicense'],
        name = json['name'],
        info = json['info'],
        category = json['category'],
        minOrderPrice = json['minOrderPrice'],
        fullAddress = json['fullAddress'],
        logo = json['logo'];
}
