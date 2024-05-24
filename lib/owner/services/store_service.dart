import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/owner/models/store_model.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StoreService {
  Future<List<StoreModel>> getStore(String accessToken) async {
    late String serverAddress;

    try {
      if (Platform.isAndroid) {
        serverAddress = 'http://10.0.2.2:9000/api/v1/store/my';
      } else if (Platform.isIOS) {
        serverAddress = 'http://127.0.0.1:9000/api/v1/store/my';
      }

      final url = Uri.parse(serverAddress);
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      List<StoreModel> storeInstance = [];

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
}
