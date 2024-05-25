import 'dart:convert';
import 'dart:io' show Platform, File;
import 'package:flutter/material.dart';
import 'package:frontend/owner/models/store_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class StoreService {
  late String serverAddress;

  // 가게 조회 api
  Future<List<StoreModel>> getStore(
    String accessToken,
  ) async {
    List<StoreModel> storeInstance = [];
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
        // 등록된 가게 정보를 stores에 저장
        final List<dynamic> stores = jsonDecode(response.body);

        // 리스트만큼 StoreModel에 객체 json에 집어넣어서 값 저장

        for (var store in stores) {
          storeInstance.add(StoreModel.fromJson(store));
        }

        print('조회 성공 $storeInstance');
        return storeInstance;
      } else {
        print('조회 실패');
        return [];
      }
    } catch (e) {
      print(e.toString());
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
      GlobalKey<FormState> formKey,
      String accessToken) async {
    try {
      if (Platform.isAndroid) {
        serverAddress = 'http://10.0.2.2:9000/api/v1/store/';
      } else if (Platform.isIOS) {
        serverAddress = 'http://127.0.0.1:9000/api/v1/store/';
      }

      final url = Uri.parse(serverAddress);
      final storeInfo = http.MultipartRequest('POST', url);

      storeInfo.headers['Authorization'] = 'Bearer $accessToken';

      // 텍스트 데이터 추가
      storeInfo.fields['businessLicense'] = businessLicense;
      storeInfo.fields['name'] = name;
      storeInfo.fields['category'] = category;
      storeInfo.fields['info'] = info;
      storeInfo.fields['minOrderPrice'] = minOrderPrice.toString();
      storeInfo.fields['fullAddress'] = fullAddress;
      storeInfo.fields['roadAddress'] = roadAddress;
      storeInfo.fields['jibunAddress'] = jibunAddress;
      storeInfo.fields['postalCode'] = postalCode;
      storeInfo.fields['latitude'] = latitude;
      storeInfo.fields['longitude'] = longitude;
      storeInfo.fields['openTime'] = '${openTime.hour}:${openTime.minute}';
      storeInfo.fields['closeTime'] = '${closeTime.hour}:${closeTime.minute}';
      storeInfo.fields['file'] = file.toString();

      // 이미지 파일 추가
      final imageStream = http.ByteStream(file.openRead());
      final imageLength = await file.length();

      final multipartFile = http.MultipartFile(
        'logo',
        imageStream,
        imageLength,
        filename: file.path.split('/').last,
      );

      storeInfo.files.add(multipartFile);

      final response = await storeInfo.send();
      if (response.statusCode == 200) {
        // 설정한 유효성에 맞으면 true를 리턴
        if (formKey.currentState!.validate()) {
          // validation 이 성공하면 폼 저장
          formKey.currentState!.save();

          // 스낵바를 보여줌
          Get.snackbar(
            "저장완료",
            '폼 저장이 완료되었습니다!',
            backgroundColor: Colors.white,
          );
        }

        print(storeInfo.fields);
        print('등록 성공');
      } else {
        Get.snackbar(
          "저장 완료 실패",
          '다시 작성해주세요.',
          backgroundColor: Colors.white,
        );
        print('등록 실패 ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
