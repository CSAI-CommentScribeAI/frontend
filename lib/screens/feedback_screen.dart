import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage(selectedStore, {super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackeState();
}

class _FeedbackeState extends State<FeedbackPage> {
  String selectedDate = ''; // 선택된 날짜
  double rate = 0.0; // 선택된 날짜에 해당하는 리뷰들의 평균 별점

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F3FF),
        appBar: AppBar(
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 23.0),
              child: Icon(
                Icons.account_circle,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
          title: const Text(
            '주간 피드백',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF374AA3),
          toolbarHeight: 70,
          leading: const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: BackButton(
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              color: const Color(0xFFD8D8FF),
              height: MediaQuery.of(context).size.height / 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () {},
                      ),
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          '12월 1주차',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularPercentIndicator(
                            radius: 60.0, // 반지름
                            animation: true, // 애니메이션 활성화
                            animationDuration: 1200, // 애니메이션 지속 시간 설정
                            lineWidth: 12.0, // 두께
                            percent: 1, // 퍼센트 %
                            center: const Text(
                              "4.5",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 20.0,
                              ),
                            ),
                            circularStrokeCap:
                                CircularStrokeCap.butt, // 원의 모양 설정
                            progressColor: const Color(0xFF7E7EB2)),
                        // 진행 바 색상
                      ),
                      Column(
                        children: [
                          Text(
                            rate.toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      // 날짜에 해당하는 평점 rate를 가져와 rating에 집어넣어 색상 양 설정
                      RatingBarIndicator(
                        rating: rate,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              color: const Color(0xFFF3F3FF),
              height: MediaQuery.of(context).size.height * 2 / 4,
            ),
          ],
        ),
      ),
    );
  }
}
