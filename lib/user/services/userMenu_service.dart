import 'dart:convert';
import 'dart:io' show Platform;
import 'package:frontend/owner/models/menu_model.dart';
import 'package:http/http.dart' as http;

class UserMenuService {
  String serverAddress = '';

  // 가게별 메뉴 전체 조회
  Future<List<AddMenuModel>> fetchMenus(int storeId) async {
    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/$storeId/menus';
    } else if (Platform.isIOS) {
      serverAddress = 'http://127.0.0.1:9000/api/v1/$storeId/menus';
    }
    try {
      final url = Uri.parse(serverAddress);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final utf8Response = utf8.decode(response.bodyBytes);
        final dynamic jsonResponse = jsonDecode(utf8Response);

        final dataResponse = jsonResponse['data'];
        List<AddMenuModel> userMenuList = [];

        for (var data in dataResponse) {
          userMenuList.add(AddMenuModel.fromJson(data));
        }

        print('가게별 메뉴 조회 성공: $dataResponse');
        return userMenuList;
      } else {
        throw Exception('조회 실패: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
