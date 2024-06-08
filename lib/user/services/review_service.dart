import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/user/models/order_model.dart';

class ReviewService {
  late String serverAddress;

  // 리뷰 작성 API
  Future<bool> writeReview(Map<String, dynamic> reviewData, int orderId) async {
    // SharedPreferences에서 액세스 토큰을 가져옴
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    // 현재 플랫폼에 따라 서버 주소 설정
    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/comment/$orderId';
    } else if (Platform.isIOS) {
      serverAddress = 'http://127.0.0.1:9000/api/v1/comment/$orderId';
    }

    try {
      // 서버에 요청 보냄
      final url = Uri.parse(serverAddress);

      // 헤더에 액세스 토큰 추가
      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      // JSON 데이터 변환
      final body = jsonEncode(reviewData);

      // POST 요청
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      // 200 : 요청 성공
      if (response.statusCode == 200) {
        print('리뷰 작성 성공');
        Get.snackbar(
          "성공",
          "리뷰 작성 성공하였습니다.",
          backgroundColor: Colors.white,
        );
        return true;
      } else {
        // 요청 실패 시
        print('리뷰 작성 실패: ${response.statusCode}');
        Get.snackbar(
          "실패",
          "리뷰 작성 실패하였습니다.",
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
