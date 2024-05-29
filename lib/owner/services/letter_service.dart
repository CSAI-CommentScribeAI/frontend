import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class LetterService {
  late String serverAddress;

  Future<void> saveLetter(bool approve, String accessToken, int orderId) async {
    if (Platform.isAndroid) {
      serverAddress =
          'http://10.0.2.2:9000/api/v1/cart/orders/place/$orderId?approve=$approve';
    } else if (Platform.isIOS) {
      serverAddress =
          'http://127.0.0.1:9000/api/v1/cart/orders/place/$orderId?approve=$approve';
    }

    try {
      final url = Uri.parse(serverAddress);
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('저장 성공');
      } else {
        print('저장 실패: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('예외 발생: ${e.toString()}');
    }
  }

  Future<String> getLetter(String accessToken, int orderId) async {
    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/cart/orders/letter/$orderId';
    } else if (Platform.isIOS) {
      serverAddress =
          'http://127.0.0.1:9000/api/v1/cart/orders/letter/$orderId';
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
        final uf8Response = utf8.decode(response.bodyBytes);
        final dynamic jsonResponse = jsonDecode(uf8Response);
        final String messageContent = jsonResponse['messageContent'];
        print('편지 가져오기 성공: $messageContent');
        return messageContent;
      } else {
        print('편지 가져오기 실패');
        return '';
      }
    } catch (e) {
      print(e.toString());
      return '';
    }
  }
}
