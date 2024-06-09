import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReplyService {
  late String serverAddress;

  // AI 답글 작성 API
  Future<String> writeAIReply(int reviewId) async {
    // SharedPreferences에서 액세스 토큰을 가져옴
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    // 현재 플랫폼에 따라 서버 주소 설정
    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/comment/reply/ai/$reviewId';
    } else if (Platform.isIOS) {
      serverAddress = 'http://127.0.0.1:9000/api/v1/comment/reply/ai/$reviewId';
    }

    try {
      // 서버에 요청 보냄
      final url = Uri.parse(serverAddress);

      // 헤더에 액세스 토큰 추가
      final headers = {
        'Authorization': 'Bearer $accessToken',
      };

      // POST 요청
      final response = await http.post(
        url,
        headers: headers,
      );

      // 200 : 요청 성공
      if (response.statusCode == 200) {
        final utf8Response = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(utf8Response);

        final String AIReply = jsonResponse['data'];
        print('AI 답글 작성 성공: $AIReply');
        // Get.snackbar(
        //   "성공",
        //   "답글 작성 성공하였습니다.",
        //   backgroundColor: Colors.white,
        // );
        return AIReply;
      } else {
        // 요청 실패 시
        print('답글 작성 실패: ${response.statusCode}');
        // Get.snackbar(
        //   "실패",
        //   "리뷰 작성 실패하였습니다.",
        //   backgroundColor: Colors.white,
        // );
        print('응답 본문: ${response.body}');
        return '';
      }
    } catch (e) {
      // 예외 발생 시
      print('예외 발생: $e');
      return '';
    }
  }

  // 답글 등록 API
  Future<void> resisterReply(int reviewId, String reply) async {
    // SharedPreferences에서 액세스 토큰을 가져옴
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    // 현재 플랫폼에 따라 서버 주소 설정
    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/comment/reply/$reviewId';
    } else if (Platform.isIOS) {
      serverAddress = 'http://127.0.0.1:9000/api/v1/comment/reply/$reviewId';
    }

    try {
      // 서버에 요청 보냄
      final url = Uri.parse(serverAddress);

      // 헤더에 액세스 토큰 추가
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      // POST 요청
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({'comment': reply}),
      );

      // 200 : 요청 성공
      if (response.statusCode == 200) {
        print('리뷰 답글 등록 성공');
      } else {
        // 요청 실패 시
        print('리뷰 답글 등록 실패: ${response.statusCode}');

        print('응답 본문: ${response.body}');
      }
    } catch (e) {
      print('예외 발생: $e');
    }
  }
}
