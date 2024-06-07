import 'package:http/http.dart' as http;
import 'dart:convert'; // 추가
import 'dart:io' show Platform;

class OrderService {
  late String serverAddress;

  Future<void> order(String accessToken) async {
    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/cart/orders/';
    } else if (Platform.isIOS) {
      serverAddress = 'http://127.0.0.1:9000/api/v1/cart/orders/';
    }

    final orderData = {
      "orderStatus": "REQUEST",
      "storeId": 1,
      "totalPrice": 8000,
      "userAddress": "경기도 안양시 만안구 성결대학로 53",
      "orderMenus": [
        {
          "menuId": 2,
          "imageUrl":
              'https://s3.ap-northeast-2.amazonaws.com/delivery-test-bucket-1/store/menu/menu/28049c66-32f5-452d-bdf3-3f67f30aa0ba.jpg',
          "quantity": 1,
        },
      ]
    };

    try {
      final url = Uri.parse(serverAddress);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final id = responseBody['id'];
        print('주문 성공: $id');

        // OrderDTO의 필드 값들을 출력합니다.
        print('OrderDTO 데이터:');
        print('ID: ${responseBody['id']}');
        print('Order Status: ${responseBody['orderStatus']}');
        print('Store ID: ${responseBody['storeId']}');
        print('Total Price: ${responseBody['totalPrice']}');
        print('User ID: ${responseBody['userId']}');
        print('User Address: ${responseBody['userAddress']}');
        print('Created At: ${responseBody['createdAt']}');
        print('Order Menus: ${responseBody['orderMenus']}');
      } else {
        print('주문 실패: ${response.statusCode} - ${response.body}');
        return;
      }
    } catch (e) {
      print('에러 발생: $e');
      return;
    }
  }
}
