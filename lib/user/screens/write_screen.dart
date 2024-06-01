import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:frontend/user/screens/cart_screen.dart';
import 'package:frontend/user/screens/complete_screen.dart';
import 'package:frontend/user/screens/home_screen.dart';

class writeReviewPage extends StatefulWidget {
  final String store;
  const writeReviewPage(this.store, {super.key});

  @override
  State<writeReviewPage> createState() => _writeReviewPageState();
}

class _writeReviewPageState extends State<writeReviewPage> {
  double rating = 0.0;
  TextEditingController reviewController = TextEditingController();

  // 별점을 설정하고 리뷰를 작성하면 등록버튼 활성화 위해 isWritten이 true로 반환
  bool get isWritten {
    return rating > 0 && reviewController.text.isNotEmpty;
  }

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
              // 가게 이름
              Text(
                widget.store,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // 별점
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

              // 리뷰 작성 필드
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
                  onChanged: (value) {
                    setState(() {
                      // 입력한 값 실시간으로 변화
                      reviewController.text = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 18),

              // 사진 추가 버튼
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

      // 등록하기 버튼
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          // 주문 내역 페이지로 넘어간 뒤에 다시 리뷰작성 페이지로 못 넘어가게 해야됨
          // 리뷰쓰기 버튼 비활성화(작성한 리뷰)
          // 별점과 리뷰 작성해야만 버튼 활성화
          isWritten
              // 특정 화면으로 이동하고 기존 화면은 모두 제거
              ? Navigator.pushAndRemoveUntil(
                  context,
                  downToUpRoute(),
                  (route) => false,
                )
              : null;
        }, // 결제 화면으로 이동
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isWritten ? const Color(0xFF274AA3) : const Color(0xFFD9D9D9),
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadiusDirectional.zero,
          ),
          minimumSize: const Size(double.infinity, 70),
        ),
        child: const Text(
          '등록하기',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  // 아래에서 위로 페이지 이동하는 애니메이션 함수
  Route downToUpRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => CompletePage(
          isWritten: isWritten), // 오른쪽에 있는 isWritten : 위의 isWritte의 값

      // 페이지 전환 애니메이션 정의(child: 전환될 페이지)
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0); // 시작점 지정(화면의 아래쪽 의미)
        const end = Offset.zero; // 원래 위치(화면의 제자리) 지정
        const curve = Curves.ease; // 부드러운 속도 변화

        // 시작과 끝을 정의(부드럽게 페이지 이동)
        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        // 위에서 지정했던 애니메이션을 적용하는 위젯
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
