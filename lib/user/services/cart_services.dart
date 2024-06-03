import 'dart:convert';
import 'dart:io' show Platform;
import 'package:frontend/owner/models/menu_model.dart';
import 'package:http/http.dart' as http;

class CartService {
  String serverAddress = '';

  Future<void> putCart(int menuId, AddMenuModel userMenu, int storeId,
      String storeName, String accessToken) async {
    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/cart/add';
    } else if (Platform.isIOS) {
      serverAddress = 'http://127.0.0.1:9000/api/v1/cart/add';
    }
    try {
      final url = Uri.parse(serverAddress);
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode({
            'menuId': menuId,
            'userMenu': userMenu,
            'storeId': storeId,
            'storeName': storeName,
          }));

      if (response.statusCode == 200) {
        print('담기 성공');
      } else {
        print('담기 실패');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
