import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoService {
  String serverAddress = '';

  // 유저 정보 검색
  Future<Map<String, dynamic>> fetchUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/user/info';
    } else if (Platform.isIOS) {
      serverAddress = 'http://127.0.0.1:9000/api/v1/user/info';
    }
    try {
      final url = Uri.parse(serverAddress);
      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };
      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final utf8Response = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(utf8Response);

        print('유저 정보 검색 성공: $jsonResponse');
        return jsonResponse;
      } else {
        throw Exception('조회 실패: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
