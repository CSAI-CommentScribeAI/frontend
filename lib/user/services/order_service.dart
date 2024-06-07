import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderService {
  String serverAddress = '';
  int? currentStoreId; // 현재 장바구니에 담긴 가게 ID를 저장

  // 주문 api
  Future<void> order(
    String orderStatus,
    int storeId,
    int totalPrice,
    Map<String, dynamic> cartInfo,
    List<Map<String, dynamic>> orderMenus,
  ) async {
    // SharedPreferences에서 액세스 토큰을 가져옴
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/cart/orders/';
    } else if (Platform.isIOS) {
      serverAddress = 'http://127.0.0.1:9000/api/v1/cart/orders/';
    }

    try {
      final url = Uri.parse(serverAddress);

      final response = await http.post(url,
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'orderStatus': orderStatus,
            'storeId': storeId,
            'totalPrice': totalPrice,
            'userId': cartInfo['userId'],
            'userAddress': cartInfo['userAddress'],
            'orderMenus': orderMenus,
          }));

      if (response.statusCode == 200) {
        print('주문 성공');
      } else {
        print('주문 실패');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('예외 발생: ${e.toString()}');
    }
  }
}
