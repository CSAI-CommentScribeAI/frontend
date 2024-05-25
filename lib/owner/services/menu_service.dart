import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:frontend/owner/models/menu_model.dart';

class MenuService {
  late String serverAddress;

  // 메뉴 조회 API
  Future<List<MenuModel>> getMenu(String storeId) async {
    List<MenuModel> menuInstance = [];

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
        print('메뉴 조회 성공');
        // menus : 여러 객체(메뉴의 이름, 가격, 세부내역, 메뉴 이미지, 가게 Id)
        final List<dynamic> menus = jsonDecode(response.body);

        for (var menu in menus) {
          menuInstance.add(MenuModel.fromJson(menu));
        }
        return menuInstance;
      } else {
        print('메뉴 조회 실패: ${response.statusCode}');
        throw Exception('Failed to load menu');
      }
    } catch (e) {
      print('알 수 없는 오류: $e');
      throw Exception('Unknown error');
    }
  }
}
