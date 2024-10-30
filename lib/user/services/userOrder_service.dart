import 'dart:convert';
import 'dart:io' show Platform;
import 'package:frontend/user/models/order_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserOrderService {
  String serverAddress = '';

  // 주문 조회(고객)
  Future<List<OrderModel>> getOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/cart/orders/user/';
    } else if (Platform.isIOS) {
      serverAddress = 'http://127.0.0.1:9000/api/v1/cart/orders/user/';
    }
    try {
      final url = Uri.parse(serverAddress);
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $accessToken',
      });

      if (response.statusCode == 200) {
        final utf8Response = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(utf8Response);

        List<OrderModel> userOrderList = [];
        for (var userOrder in jsonResponse) {
          userOrderList.add(OrderModel.fromJson(userOrder));
        }

        print('주문 조회 성공: $jsonResponse');
        return userOrderList;
      } else {
        throw Exception('주문 조회 실패');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
