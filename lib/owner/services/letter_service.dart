import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LetterService {
  late String serverAddress;

  // 편지 불러오기 API
  Future<Map<String, dynamic>> getLetter(int orderId) async {
    // SharedPreferences에서 액세스 토큰을 가져옴
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    // 현재 플랫폼에 따라 서버 주소 설정
    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/cart/orders/letter/$orderId';
    } else if (Platform.isIOS) {
      serverAddress =
          'http://127.0.0.1:9000/api/v1/cart/orders/letter/$orderId';
    }

    try {
      // 서버에 요청 보냄
      final url = Uri.parse(serverAddress);

      // 헤더에 액세스 토큰 추가
      final headers = {'Authorization': 'Bearer $accessToken'};

      // GET 요청
      final response = await http.get(url, headers: headers);

      // 200 : 요청 성공
      if (response.statusCode == 200) {
        // 서버 응답을 UTF-8로 디코딩
        final utf8Response = utf8.decode(response.bodyBytes);
        // 디코딩된 응답을 JSON 형태로 변환
        final jsonResponse = jsonDecode(utf8Response);

        print('편지 불러오기 성공 $jsonResponse');
        return jsonResponse;
      } else {
        // 요청 실패 시
        throw Exception(
            '편지 불러오기 실패: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // 예외 발생 시
      throw Exception('예외 발생: $e');
    }
  }

  // 주문 수락 후 편지 작성 후 저장 API
  Future<bool> saveLetter(int orderId) async {
    // SharedPreferences에서 액세스 토큰을 가져옴
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    // 현재 플랫폼에 따라 서버 주소 설정
    if (Platform.isAndroid) {
      serverAddress =
          'http://10.0.2.2:9000/api/v1/cart/orders/place/$orderId?approve=true';
    } else if (Platform.isIOS) {
      serverAddress =
          'http://127.0.0.1:9000/api/v1/cart/orders/place/$orderId?approve=true';
    }

    try {
      // 서버에 요청 보냄
      final url = Uri.parse(serverAddress);

      // 헤더에 액세스 토큰 추가
      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      // POST 요청
      final response = await http.post(
        url,
        headers: headers,
      );

      // 200 : 요청 성공
      if (response.statusCode == 200) {
        print('편지 저장 성공');
        Get.snackbar(
          "성공",
          "편지 저장 성공하였습니다.",
          backgroundColor: Colors.white,
        );
        return true;
      } else {
        // 요청 실패 시
        print('편지 저장 실패: ${response.statusCode}');
        Get.snackbar(
          "실패",
          "편지 저장이 실패하였습니다.",
          backgroundColor: Colors.white,
        );
        print('응답 본문: ${response.body}');
        return false;
      }
    } catch (e) {
      // 예외 발생 시
      print('예외 발생: $e');
      return false;
    }
  }
}
