import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryService {
  late String serverAddress;

  // 배달 완료 API
  Future<List<Map<String, dynamic>>> completeDelivery(int orderId) async {
    // SharedPreferences에서 액세스 토큰을 가져옴
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    // 편지 인스턴스를 저장할 리스트를 생성
    List<Map<String, dynamic>> completeDeliveryInstance = [];

    // 현재 플랫폼에 따라 서버 주소 설정
    if (Platform.isAndroid) {
      serverAddress =
          'http://10.0.2.2:9000/api/v1/cart/orders/delivery/$orderId';
    } else if (Platform.isIOS) {
      serverAddress =
          'http://127.0.0.1:9000/api/v1/cart/orders/delivery/$orderId';
    }

    try {
      // 서버에 요청 보냄
      final url = Uri.parse(serverAddress);

      // 헤더에 액세스 토큰 추가
      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      // PUT 요청
      final response = await http.put(
        url,
        headers: headers,
      );

      // 200 : 요청 성공
      if (response.statusCode == 200) {
        // 서버 응답을 UTF-8로 디코딩
        final utf8Response = utf8.decode(response.bodyBytes);
        // 디코딩된 응답을 JSON 형태로 변환
        final dynamic jsonResponse = jsonDecode(utf8Response);

        // jsonResponse가 Map이고 orderMenus 필드가 List일 경우
        if (jsonResponse is Map && jsonResponse['orderMenus'] is List) {
          final List<dynamic> deliveries = jsonResponse['orderMenus'];

          for (var delivery in deliveries) {
            if (delivery is Map<String, dynamic>) {
              completeDeliveryInstance.add(delivery);
            }
          }

          print('배달 성공 $completeDeliveryInstance');
          Get.snackbar("성공", "배달이 완료되었습니다.", backgroundColor: Colors.white);
          return completeDeliveryInstance;
        } else {
          // 응답이 예상과 다를 경우
          print('응답이 예상과 다름: $jsonResponse');
          return [];
        }
      } else {
        // 요청 실패 시
        print('배달 실패: ${response.statusCode}');
        print('응답 본문: ${response.body}');
        Get.snackbar(
          "실패",
          "배달이 실패하였습니다.",
          backgroundColor: Colors.white,
          colorText: Colors.black,
        );
        return [];
      }
    } catch (e) {
      // 예외 발생 시
      print('예외 발생: $e');
      Get.snackbar("오류", "예외가 발생하였습니다: $e", backgroundColor: Colors.white);
      return [];
    }
  }
}
