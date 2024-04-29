import 'package:flutter/material.dart';
import 'package:frontend/widgets/store_widget.dart';

class ReceiptPage extends StatelessWidget {
  const ReceiptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF374AA3),
        toolbarHeight: 70,
        title: const Text(
          '주문 접수',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 23.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 완료된 주문 정보 갯수
            const Text(
              '완료(2)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // 주문 정보 컨테이너
            Expanded(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 165,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              offset: const Offset(0, 4),
                              blurRadius: 4.0,
                            ),
                          ],
                        ),

                        // 주문 정보
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 가게 이름과 완료 상태
                              const Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '가게 이름',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Icon(
                                    Icons.circle,
                                    size: 10.0,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '완료',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 13),

                              // 주문 시간
                              const Text(
                                '주문 시간',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 5),

                              // 주문 정보
                              const Text(
                                '주문 정보',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // 총 가격과 리뷰 보기 버튼
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '총 가격 : 가격',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      minimumSize: Size.zero,
                                      padding: EdgeInsets.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: const Row(
                                      children: [
                                        Text(
                                          '리뷰 보기',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(width: 11),
                                        Icon(Icons.arrow_forward_ios),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF374AA3),
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(), // Gridview의 스크롤 방지
          crossAxisCount: 5, // 1개의 행에 보여줄 item의 개수
          crossAxisSpacing: 10.0, // 같은 행의 iteme들 사이의 간격
          children: [
            storeItem(imgPath: 'assets/images/bottom_home.png', title: '홈'),
            storeItem(
                imgPath: 'assets/images/bottom_store.png', title: '가게 관리'),
            storeItem(imgPath: 'assets/images/bottom_menu.png', title: '메뉴 관리'),
            storeItem(
                imgPath: 'assets/images/bottom_review.png', title: '리뷰 관리'),
            storeItem(imgPath: 'assets/images/bottom_my.png', title: 'MY'),
          ],
        ),
      ),
    );
  }
}
