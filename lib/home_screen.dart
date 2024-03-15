import 'package:flutter/material.dart';
import 'package:frontend/feedback/feedback_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
            180.0), // 상단바나 하단바의 높이를 변경하거나 다른 사용자 지정 위젯의 선호되는 크기를 지정
        child: AppBar(
          backgroundColor: const Color(0xFF374AA3),
          title: const Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              'CSAI 사장님',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: false, // title 왼쪽 정렬
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  // 뒤로가기 할 수 있게 페이지 이동
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeedbackPage(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Image.asset(
                    'assets/images/feedback.png', // 이미지 경로 설정
                    width: 28.24, // 이미지의 너비 설정
                    height: 32, // 이미지의 높이 설정
                    color: Colors.white, // 이미지의 색상 설정
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
