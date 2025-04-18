import 'dart:convert';
import 'dart:io' show Platform, File;
import 'package:flutter/material.dart';
import 'package:frontend/owner/screens/menu_screen.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/owner/models/menu_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuService {
  late String serverAddress;

  // 가게별 메뉴 조회 API
  Future<List<AddMenuModel>> getMenus(int storeId) async {
    // 1. 현재 플랫폼에 따라 로그인을 위한 주소를 설정합니다.
    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/$storeId/menus';
    } else if (Platform.isIOS) {
      serverAddress = 'http://127.0.0.1:9000/api/v1/$storeId/menus';
    }

    try {
      // 2. 서버에 로그인 요청을 보냅니다.
      final url = Uri.parse(serverAddress);
      final response = await http.get(url);

      // 200 : 요청 성공
      if (response.statusCode == 200) {
        // menus : 여러 객체(메뉴의 이름, 가격, 세부내역, 메뉴 이미지, 가게 Id)
        final utf8Response = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(utf8Response);
        final dataResponse = jsonResponse['data'];

        List<AddMenuModel> menuList = [];

        for (var data in dataResponse) {
          menuList.add(AddMenuModel.fromJson(data));
        }

        print('조회 성공 $dataResponse');
        return menuList;
      } else {
        throw Exception('조회 실패: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // 메뉴 등록 API
  Future<void> registerMenu(String name, String price, String menuDetail,
      File file, String status, String storeId
      // String category,
      ) async {
    final Map<String, String> statusMapping = {
      '판매중': 'SALE',
      '품절': 'SOLD',
      '숨김': 'HIDING',
    };

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    try {
      String serverAddress;

      if (Platform.isAndroid) {
        serverAddress = 'http://10.0.2.2:9000/api/v1/$storeId/menu/';
      } else if (Platform.isIOS) {
        serverAddress = 'http://127.0.0.1:9000/api/v1/$storeId/menu/';
      } else {
        throw Exception("Unsupported platform");
      }

      final url = Uri.parse(serverAddress);
      final menuInfo = http.MultipartRequest('POST', url);

      menuInfo.headers['Authorization'] = 'Bearer $accessToken';

      // 텍스트 데이터 추가
      menuInfo.fields['name'] = name;
      menuInfo.fields['price'] = price;
      menuInfo.fields['menuDetail'] = menuDetail;
      menuInfo.fields['status'] = statusMapping[status] ?? '';

      // 이미지 파일 추가
      final imageStream = http.ByteStream(file.openRead());
      final imageLength = await file.length();

      final multipartFile = http.MultipartFile(
        'file',
        imageStream,
        imageLength,
        filename: file.path.split('/').last,
      );

      menuInfo.files.add(multipartFile);

      final response = await menuInfo.send();

      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        Get.snackbar(
          "저장완료",
          '폼 저장이 완료되었습니다!',
          backgroundColor: Colors.white,
        );

        print(menuInfo.fields);
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
}
