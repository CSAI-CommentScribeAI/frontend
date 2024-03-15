import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:frontend/feedback/feedback_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3FF),
      appBar: AppBar(
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
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
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
                  'assets/images/feedback.png',
                  width: 28.24,
                  height: 32,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 120,
                decoration: const BoxDecoration(
                  color: Color(0xFF374AA3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 19.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9D9D9),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        // Text의 폭을 무시한 채 화면의 가로폭에 맞추기 위해 사용
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: const Text(
                            '알림 뜰 때만 보이게',
                            textAlign: TextAlign.center, // 텍스트 중앙으로
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 19.0),

                // Align 위젯으로 중앙 배치
                child: Align(
                  child: Transform.translate(
                    offset: const Offset(0.0, 63.0), // X, Y 축으로 이동할 양을 지정
                    child: Container(
                      height: 144,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF374AA3).withOpacity(0.5),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
