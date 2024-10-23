import 'dart:convert';
import 'dart:io' show Platform, File;
import 'package:flutter/material.dart';
import 'package:frontend/owner/models/store_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StoreService {
  late String serverAddress;

  // 가게 조회 api
  Future<List<StoreModel>> getStore() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/store/my';
    } else if (Platform.isIOS) {
      serverAddress = 'http://127.0.0.1:9000/api/v1/store/my';
    }

    try {
      final url = Uri.parse(serverAddress);
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final utf8Response = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(utf8Response);

        List<StoreModel> stores = [];
        for (var store in jsonResponse) {
          stores.add(StoreModel.fromJson(store));
        }

        print('조회 성공: $jsonResponse');
        return stores;
      } else {
        print('조회 실패: ${response.statusCode}');
        print('응답 본문: ${response.body}');
        return [];
      }
    } catch (e) {
      print('예외 발생: $e');
      return [];
    }
  }

  // 가게 등록 api
  Future<void> registerStore(
    String businessLicense,
    String name,
    String category,
    String info,
    String minOrderPrice,
    String fullAddress,
    String roadAddress,
    String jibunAddress,
    String postalCode,
    String latitude,
    String longitude,
    TimeOfDay openTime,
    TimeOfDay closeTime,
    File file,
    String? accessToken,
  ) async {
    final Map<String, String> categoryMapping = {
      '햄버거': 'HAMBURGER',
      '피자': 'PIZZA',
      '디저트': 'DESSERT',
      '한식': 'KOREANFOOD',
      '중식': 'CHINESEFOOD',
      '분식': 'FLOURBASEDFOOD',
      '일식': 'JAPANESEFOOD',
      '치킨': 'CHICKEN',
    };

    try {
      String serverAddress;
      if (Platform.isAndroid) {
        serverAddress = 'http://10.0.2.2:9000/api/v1/store/';
      } else if (Platform.isIOS) {
        serverAddress = 'http://127.0.0.1:9000/api/v1/store/';
      } else {
        throw Exception("Unsupported platform");
      }

      final url = Uri.parse(serverAddress);
      final storeInfo = http.MultipartRequest('POST', url);

      storeInfo.headers['Authorization'] = 'Bearer $accessToken';

      // 텍스트 데이터 추가
      storeInfo.fields['businessLicense'] = businessLicense;
      storeInfo.fields['name'] = name;
      storeInfo.fields['category'] = categoryMapping[category] ?? '';
      storeInfo.fields['info'] = info;
      storeInfo.fields['minOrderPrice'] = minOrderPrice.toString();
      storeInfo.fields['fullAddress'] = fullAddress;
      storeInfo.fields['roadAddress'] = roadAddress;
      storeInfo.fields['jibunAddress'] = jibunAddress;
      storeInfo.fields['postalCode'] = postalCode;
      storeInfo.fields['latitude'] = latitude;
      storeInfo.fields['longitude'] = longitude;
      storeInfo.fields['openTime'] = formatTimeOfDay(openTime);
      storeInfo.fields['closeTime'] = formatTimeOfDay(closeTime);

      // 이미지 파일 추가
      final imageStream = http.ByteStream(file.openRead());
      final imageLength = await file.length();

      final multipartFile = http.MultipartFile(
        'file',
        imageStream,
        imageLength,
        filename: file.path.split('/').last,
      );

      storeInfo.files.add(multipartFile);

      final response = await storeInfo.send();

      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        Get.snackbar(
          "저장완료",
          '폼 저장이 완료되었습니다!',
          backgroundColor: Colors.white,
        );

        print(storeInfo.fields);
        print('등록 성공');
      } else {
        Get.snackbar(
          "저장 완료 실패",
          '다시 작성해주세요. 오류: ${response.statusCode}',
          backgroundColor: Colors.white,
        );
        print('등록 실패 ${response.statusCode}');
        print('Response body: $responseString');
      }
    } catch (e) {
      print('Exception: ${e.toString()}');
    }
  }

  // 시간을 두 자리 형식으로 변환하는 함수
  String formatTimeOfDay(TimeOfDay time) {
    final String hour = time.hour.toString().padLeft(2, '0');
    final String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
