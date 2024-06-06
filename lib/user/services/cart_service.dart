import 'dart:convert';
import 'dart:io' show Platform;
import 'package:frontend/owner/models/menu_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  String serverAddress = '';

  Future<void> putCart(
    AddMenuModel userMenu,
    int userId,
    String storeAddress,
  ) async {
    // SharedPreferences에서 액세스 토큰을 가져옴
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/cart/add';
    } else if (Platform.isIOS) {
      serverAddress = 'http://127.0.0.1:9000/api/v1/cart/add';
    }
    try {
      final url = Uri.parse(serverAddress);

      // 먼저 CartItem을 데이터베이스에 저장
      final addCartItemResponse = await http.post(url,
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'menuId': userMenu.id,
            'menuName': userMenu.name,
            'imageUrl': userMenu.imageUrl,
          }));

      if (addCartItemResponse.statusCode == 200) {
        final addToCartResponse = await http.post(url,
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({}));
      } else {
        print('담기 실패');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
