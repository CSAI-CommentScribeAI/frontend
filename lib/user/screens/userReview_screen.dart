import 'package:flutter/material.dart';
import 'package:frontend/user/screens/cart_screen.dart';
import 'package:frontend/user/screens/home_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class UserReviewPage extends StatelessWidget {
  const UserReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const userHomePage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.home,
                  size: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartPage(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            radius: 60.0, // 반지름
            animation: true, // 애니메이션 활성화
            animationDuration: 1200, // 애니메이션 지속 시간 설정
            lineWidth: 12.0, // 두께
            percent: 0.9, // 퍼센트 %
            center: const Text(
              "4.5",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 20.0,
              ),
            ),
            circularStrokeCap: CircularStrokeCap.butt, // 원의 모양 설정
            progressColor: const Color(0xFF7E7EB2),
          ),
          const SizedBox(width: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // 크기가 화면 높이까지 설정되어 있어 최소롤 설정
            children: [
              scope('5점', 1, '23건'),
              scope('4점', 0.8, '45건'),
              scope('3점', 0.6, '33건'),
              scope('2점', 0.4, '11건'),
              scope('1점', 0.2, '3건'),
            ],
          ),
        ],
      ),
    );
  }

  Widget scope(String point, double percent, String cases) {
    return Row(
      children: [
        Text(
          point,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        // 날짜에 해당하는 평점 rate를 가져와 rating에 집어넣어 색상 양 설정
        LinearPercentIndicator(
          width: 150.0, // 바 길이
          lineHeight: 8.0, // 바 넓이
          percent: percent, // 퍼센트
          progressColor: const Color(0xffF9BC28),
        ),
        Text(
          cases,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 8.0,
          ),
        ),
      ],
    );
  }
}
