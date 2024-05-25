import 'dart:io';

import 'package:flutter/material.dart';

class StoreModel {
  final String businessLicense,
      name,
      info,
      category,
      minOrderPrice,
      fullAddress,
      roadAddress,
      jibunAddress,
      postalCode,
      latitude,
      longitude,
      openTime,
      endTime;

  StoreModel(
      {required this.businessLicense,
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
      required this.endTime});

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
        businessLicense: json['businessLicense'],
        name: json['name'],
        info: json['info'],
        category: json['category'],
        minOrderPrice: json['minOrderPrice'],
        fullAddress: json['fullAddress'],
        roadAddress: json['roadAddress'],
        jibunAddress: json['jibunAddress'],
        postalCode: json['postalCode'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        openTime: json['openTime'],
        endTime: json['endTime']);
  }
}
