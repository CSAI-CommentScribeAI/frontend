import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:frontend/owner/models/menu_model.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class userMenuService {
  String serverAddress = '';

  Future<List<AddMenuModel>> fetchMenus() async {
    List<AddMenuModel> userMenuInstance = [];
    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/1/menus';
    } else if (Platform.isIOS) {
      serverAddress = 'http://127.0.0.1:9000/api/v1/1/menus';
    }
    try {
      final url = Uri.parse(serverAddress);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final utf8Response = utf8.decode(response.bodyBytes);
        final dynamic jsonResponse = jsonDecode(utf8Response);

        if (jsonResponse is Map && jsonResponse['data'] is List) {
          final List<dynamic> userMenus = jsonResponse['data'];
          print('JSON 데이터: $userMenus');

          for (var menu in userMenus) {
            userMenuInstance.add(AddMenuModel.fromJson(menu));
          }
        }
        print('조회 성공: $userMenuInstance');
        return userMenuInstance;
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
