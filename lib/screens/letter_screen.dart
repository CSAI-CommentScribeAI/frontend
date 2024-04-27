import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class LetterPage extends StatefulWidget {
  const LetterPage({super.key});

  @override
  State<LetterPage> createState() => _LetterPageState();
}

class _LetterPageState extends State<LetterPage> {
  final CarouselController controller = CarouselController();
  List<Map<String, dynamic>> templateList = [
    {
      'title': '크리스마스',
      'url': 'assets/templates/christmas.png',
    },
    {
      'title': '나뭇잎',
      'url': 'assets/templates/leaf.png',
    },
    {
      'title': '가을바람',
      'url': 'assets/templates/autumn.png',
    },
    {
      'title': '개구리',
      'url': 'assets/templates/frog.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF374AA3),
        toolbarHeight: 70,
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: BackButton(
            color: Colors.white,
          ),
        ),
        title: const Text(
          '편지 서비스',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 300.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B88C2),
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  minimumSize: const Size(80, 35),
                ),
                child: const Text(
                  '편지 내역',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              flex: 10,
              child: makeList(),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B88C2),
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                minimumSize: const Size(205, 38),
              ),
              child: const Text(
                '캐릭터 추가하기',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF374AA3),
          minimumSize: const Size(
            double.infinity,
            80,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        child: const Text(
          '템플릿 저장',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

// 편지지 템플릿 Carousel 리스트
  CarouselSlider makeList() {
    return CarouselSlider.builder(
      carouselController: controller,
      itemCount: templateList.length,
      itemBuilder: (context, index, pageViewIndex) {
        return Column(
          children: [
            Text(
              templateList[index]['title']!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 450,
              width: 320,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 4.0,
                    offset: const Offset(0, 4),
                  )
                ],
                image: DecorationImage(
                  image: AssetImage(templateList[index]['url']!),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        );
      },
      options: CarouselOptions(
        autoPlay: false, // 슬라이드 자동 방식
        enlargeCenterPage: true, // 가운데 페이지를 크게 보여줌
        viewportFraction: 0.8, // 한 번에 보여질 때 페이지 너비 비율
        aspectRatio: 1 / 1.4, // 가로 세로 비율
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
