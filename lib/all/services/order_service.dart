import 'dart:convert';
import 'dart:io' show Platform;
import 'package:frontend/user/models/order_model.dart';
import 'package:get/get_connect.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderService {
  String serverAddress = '';
  int? currentStoreId; // 현재 장바구니에 담긴 가게 ID를 저장

  // 주문
  Future<void> order(
    String? orderStatus,
    int? storeId,
    int? totalPrice,
    Map<String, dynamic>? cartInfo,
    List<Map<String, dynamic>>? orderMenus,
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
            'userId': cartInfo!['userId'],
            'userAddress': cartInfo['userAddress'],
            'orderMenus': orderMenus,
          }));

      if (response.statusCode == 200) {
        print('주문 성공: ${response.body}');
      } else {
        print('주문 실패: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('예외 발생: ${e.toString()}');
    }
  }

  Future<List<OrderModel>> getOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    List<OrderModel> orderInstance = [];

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
        final dynamic jsonResponse = jsonDecode(utf8Response);

        final List<dynamic> orders = jsonResponse;
        print('JSON 데이터: $orders');

        for (var order in orders) {
          orderInstance.add(OrderModel.fromJson(order));
        }

        print('조회 성공: $orderInstance');
        return orderInstance;
      } else {
        print('조회 실패');
        return [];
      }
    } catch (e) {
      print(
        e.toString(),
      );
      return [];
    }
  }

  // 사장님 주문 조회 API
  Future<List<OrderModel>> getUserOrders(int storeId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    List<OrderModel> userOrdersInstance = [];

    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/cart/orders/$storeId';
    } else if (Platform.isIOS) {
      serverAddress = 'http://127.0.0.1:9000/api/v1/cart/orders/$storeId';
    }
    try {
      final url = Uri.parse(serverAddress);
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final utf8Response = utf8.decode(response.bodyBytes);
        final dynamic jsonResponse = jsonDecode(utf8Response);

        final List<dynamic> orders = jsonResponse;
        print('주문 JSON 데이터: $orders');

        for (var order in orders) {
          userOrdersInstance.add(OrderModel.fromJson(order));
        }

        print('주문 조회 성공: $userOrdersInstance');
        return userOrdersInstance;
      } else {
        print('주문 조회 실패');
        return [];
      }
    } catch (e) {
      print(
        e.toString(),
      );
      return [];
    }
  }
}
