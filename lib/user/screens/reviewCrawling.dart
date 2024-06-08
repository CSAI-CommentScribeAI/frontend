import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewCrawlingPage extends StatefulWidget {
  const ReviewCrawlingPage({super.key});

  @override
  State<ReviewCrawlingPage> createState() => _ReviewCrawlingPageState();
}

class _ReviewCrawlingPageState extends State<ReviewCrawlingPage> {
  final List<Map<String, dynamic>> deliveryApps = [
    {
      'name': '쿠팡이츠',
      'image': 'assets/images/coupangeats.png',
      'rating': 4.5,
    },
    {
      'name': '배달의민족',
      'image': 'assets/images/baemin.png',
      'rating': 4.2,
    },
    {
      'name': '요기요',
      'image': 'assets/images/yogiyo.png',
      'rating': 4.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 23.0),
            child: Icon(
              Icons.home,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 23.0),
            child: Icon(
              Icons.shopping_cart,
              size: 30,
              color: Colors.black,
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: const Color(0xFFF3F3FF),
        toolbarHeight: 70,
        leading: const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: BackButton(
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: deliveryApps.map((app) => buildReviewSection(app)).toList(),
          // 리스트의 각 요소를 map 메서드를 통해 순회
          // map 메서드는 이터레이터를 반환하기 때문에, 이를 리스트로 변환하기 위해 toList() 메서드를 호출
          // 이터레이터 = 프로그래밍에서 데이터의 집합체(컬렉션)를 순회(traverse)하는 객체
        ),
      ),
    );
  }

  Widget buildReviewSection(Map<String, dynamic> app) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 26.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                app['name'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 10),
              ClipRRect(
                // 둥근 정도 조절
                borderRadius: BorderRadius.circular(5.0),
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset(
                    app['image'],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          // RatingBar.builder 위젯을 사용하여 사용자에게 별점을 매길 수 있는 인터페이스 제공
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${app['rating']}',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 10), // 가로 간격을 10으로 수정
              RatingBar.builder(
                // 초기 별점 값을 설정, 여기서는 app['rating'] 값으로 설정
                initialRating: app['rating'],
                minRating: 1,
                // 별점 표시 방향을 설정
                direction: Axis.horizontal,
                // 반 별점을 허용할지 설정
                allowHalfRating: true,
                // 별의 총 개수를 설정
                itemCount: 5,
                // 각 별 사이의 간격을 설정
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                // 별의 모양과 색상을 설정, 여기서는 노란색 별 아이콘을 사용
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                // 사용자가 별점을 업데이트할 때 호출되는 콜백 함수
                onRatingUpdate: (rating) {
                  // setState를 호출하여 app['rating'] 값을 업데이트
                  setState(() {
                    app['rating'] = rating;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 80),
          const Text(
            '종합적인 리뷰 내용',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
