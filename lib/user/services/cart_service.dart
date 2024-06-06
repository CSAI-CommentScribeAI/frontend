import 'dart:convert';
import 'dart:io' show Platform;
import 'package:frontend/owner/models/menu_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  String serverAddress = '';
  int? currentStoreId; // 현재 장바구니에 담긴 가게 ID를 저장

  Future<void> putCart(
    AddMenuModel userMenu,
  ) async {
    // SharedPreferences에서 액세스 토큰을 가져옴
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/cart/add';
    } else if (Platform.isIOS) {
      serverAddress = 'http://127.0.0.1:9000/api/v1/cart/add';
    }

    if (currentStoreId == null) {
      currentStoreId = userMenu.storeId; // 장바구니가 비어있으면 현재 가게 ID를 설정
    } else if (currentStoreId != userMenu.storeId) {
      throw Exception('다른 가게의 메뉴를 추가할 수 없습니다.'); // 다른 가게의 메뉴를 추가하려고 하면 예외 발생
    }

    try {
      final url = Uri.parse(serverAddress);

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userMenu),
      );

      if (response.statusCode == 200) {
        print('담기 성공');
      } else {
        throw Exception('담기 실패');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
