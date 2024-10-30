import 'dart:convert';
import 'dart:io' show Platform;
import 'package:frontend/owner/models/store_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserStoreService {
  String serverAddress = '';

  // 가게 여러건 조회 API
  Future<List<StoreModel>> getManyStores() async {
    List<StoreModel> userStoreInstance = []; // 모든 가게를 저장할 리스트

    // SharedPreferences에서 토큰을 가져옵니다.
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/store/';
    } else if (Platform.isIOS) {
      serverAddress = 'http://127.0.0.1:9000/api/v1/store/';
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
        final utf8Response =
            utf8.decode(response.bodyBytes); // 응답 데이터를 UTF-8로 디코딩
        final dynamic jsonResponse = jsonDecode(utf8Response);

        // JSON 응답이 Map 형식이고 'data' 필드가 Map이며 'content' 필드가 List일 경우
        if (jsonResponse is Map &&
            jsonResponse['data'] is Map &&
            jsonResponse['data']['content'] is List) {
          // content 필드의 리스트를 userStores에 저장
          final List<dynamic> userStores = jsonResponse['data']['content'];
          print('JSON 데이터: $userStores');

          // 리스트 길이만큼 반복해 하나의 리스트를 userStoreInstance에 추가
          for (var userStore in userStores) {
            userStoreInstance.add(StoreModel.fromJson(userStore));
          }

          print('조회 성공: $userStoreInstance');
          return userStoreInstance;
        } else {
          print('부적절한 응답 형식: $jsonResponse');
          return [];
        }
      } else {
        print('조회 실패: ${response.statusCode}');
        print('응답 본문: ${response.body}');
        return [];
      }
    } catch (e) {
      print('예외 발생: $e');
      return [];
    }
  }

  // 가게 조회
  Future<Map<String, dynamic>> getStore(int storeId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/store/$storeId';
    } else if (Platform.isIOS) {
      serverAddress = 'http://127.0.0.1:9000/api/v1/store/$storeId';
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
        final jsonResponse = jsonDecode(utf8Response);
        final dataResponse = jsonResponse['data'];

        Map<String, dynamic> store = dataResponse;

        print('가게 조회 성공: $dataResponse');
        return store;
      } else {
        throw Exception(
            '가게 조회 실패코드 - 응답 본문: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('예외 발생: $e');
    }
  }
}
