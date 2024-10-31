import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  // 주문 리뷰 요청 API
  Future<Map<String, dynamic>> getOrderReview(int orderId) async {
    // SharedPreferences에서 액세스 토큰을 가져옴
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    // 현재 플랫폼에 따라 서버 주소 설정
    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/comment/order/$orderId';
    } else if (Platform.isIOS) {
      serverAddress = 'http://127.0.0.1:9000/api/v1/comment/order/$orderId';
    }

    try {
      // 서버에 요청 보냄
      final url = Uri.parse(serverAddress);

      // 헤더에 액세스 토큰 추가
      final headers = {
        'Authorization': 'Bearer $accessToken',
      };

      // POST 요청
      final response = await http.get(
        url,
        headers: headers,
      );

      // 200 : 요청 성공
      if (response.statusCode == 200) {
        final utf8Response = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(utf8Response);
        final dataResponse = jsonResponse['data'];

        print('주문 리뷰 요청 성공: $dataResponse');

        return dataResponse;
      } else {
        // 요청 실패 시
        throw Exception(
            '주문 리뷰 요청 실패: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // 예외 발생 시
      throw Exception('예외 발생: $e');
    }
  }

  // 가게별 가게 리뷰 API
  Future<List<Map<String, dynamic>>> getStoreReview(int storeId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/comment/store/$storeId';
    } else if (Platform.isIOS) {
      serverAddress = 'http://127.0.0.1:9000/api/v1/comment/store/$storeId';
    }

    try {
      final url = Uri.parse(serverAddress);
      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      // Get 요청
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final utf8Response = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(utf8Response);
        final List<dynamic> dataResponse = jsonResponse['data'];
        final List<Map<String, dynamic>> formattedData =
            List<Map<String, dynamic>>.from(dataResponse);

        print('가게별 리뷰 조회 성공: $formattedData');
        return formattedData;
      } else {
        throw Exception('조회 실패: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('예외 발생: $e');
    }
  }

  // 사용자 리뷰 요청 API
  Future<List<Map<String, dynamic>>> getUserReview(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    String serverAddress;
    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/comment/user/$userId';
    } else if (Platform.isIOS) {
      serverAddress = 'http://127.0.0.1:9000/api/v1/comment/user/$userId';
    } else {
      throw Exception("Unsupported platform");
    }

    try {
      final url = Uri.parse(serverAddress);
      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      // Get 요청
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final utf8Response = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(utf8Response);

        // `dataResponse`를 `List<Map<String, dynamic>>` 형식으로 변환
        final List<dynamic> dataResponse = jsonResponse['data'];
        final List<Map<String, dynamic>> formattedData =
            List<Map<String, dynamic>>.from(dataResponse);

        print('사용자 리뷰 조회 성공 $formattedData');
        return formattedData;
      } else {
        throw Exception('사용자 조회 실패: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('예외 발생: $e');
    }
  }
}
