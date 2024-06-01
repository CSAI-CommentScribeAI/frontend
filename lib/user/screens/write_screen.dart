import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:frontend/user/screens/cart_screen.dart';
import 'package:frontend/user/screens/home_screen.dart';

class writeReviewPage extends StatefulWidget {
  const writeReviewPage({super.key});

  @override
  State<writeReviewPage> createState() => _writeReviewPageState();
}

class _writeReviewPageState extends State<writeReviewPage> {
  double rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('리뷰 쓰기'),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55.0, vertical: 30),
        child: Center(
          child: Column(
            children: [
              const Text(
                '가게 이름',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              PannableRatingBar(
                rate: rating,
                items: List.generate(
                    5,
                    (index) => const RatingWidget(
                          selectedColor: Color(0xFFFFCB45),
                          unSelectedColor: Colors.grey,
                          child: Icon(
                            Icons.star,
                            size: 48,
                          ),
                        )),
                onChanged: (value) {
                  setState(() {
                    rating = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 114,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: '음식에 대한 솔직한 리뷰를 남겨주세요',
                    hintStyle: const TextStyle(
                      color: Color(0xFFD3D3D3), // 힌트 텍스트 색상
                      fontSize: 1.0, // 힌트 텍스트 크기
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5), // 배경 색상
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0), // 테두리 둥글게
                      borderSide: const BorderSide(
                        color: Color(0xFFD3D3D3), // 테두리 색상
                      ),
                    ),

                    // 입력했을 때 색상
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0), // 포커스된 테두리 둥글게
                      borderSide: const BorderSide(
                        color: Color(0xFFD3D3D3), // 포커스된 테두리 색상
                      ),
                    ),

                    // 입력하기 전 테두리
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0), // 활성화된 테두리 둥글게
                      borderSide: const BorderSide(
                        color: Color(0xFFD3D3D3), // 활성화된 테두리 색상
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0,
                    ), // 내용물 패딩
                  ),
                  maxLines: null, // 여러 줄 입력 가능
                  expands: true, // TextFormField 확장
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  side: const BorderSide(
                    color: Color(0xFF7E7EB2),
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text(
                      '사진 추가',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
