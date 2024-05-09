import 'package:flutter/material.dart';
import 'package:frontend/screens/review_screen.dart';
import 'package:frontend/widgets/store_widget.dart';
import 'package:get/get.dart';

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({super.key});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  int i = 0; // 각 객체마다 isCompleted에 접근하기 위해 선언

  List<Map<String, dynamic>> orderList = [
    {
      'title': 'BBQ 코엑스점',
      'time': '10:56',
      'information': '황금올리브 1마리 세트 + 콜라 1.5L',
      'price': 25000,
      'isCompleted': false,
    },
    {
      'title': '이남장 서초점',
      'time': '13:45',
      'information': '설렁탕(특)',
      'price': 15000,
      'isCompleted': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3FF),
      appBar: AppBar(
        actions: const [
          // 오른쪽 상단에 프로필 아이콘을 나타내는 아이콘 추가
          Padding(
            padding: EdgeInsets.only(right: 23.0),
            child: Icon(
              Icons.menu,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
        // 가게 이름을 표시하는 타이틀 설정
        title: const Text(
          '접수 관리',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true, // 타이틀을 가운데 정렬
        backgroundColor: const Color(0xFF374AA3), // 앱 바 배경색 설정
        toolbarHeight: 70, // 앱 바의 높이 설정
        leading: const Padding(
          // 왼쪽 상단에 뒤로가기 아이콘을 나타내는 아이콘 추가
          padding: EdgeInsets.only(left: 15.0),
          child: BackButton(
            color: Colors.white,
          ),
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
            Row(
              children: [
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // 주문이 들어오면 자동 완료 방식으로 하기 위해
                    // 완료버튼을 누르면(주문이 들어오는 것과 동일) 자동 주문 완료 상태 전환
                    setState(() {
                      for (i = 0; i < orderList.length; i++) {
                        orderList[i]['isCompleted'] = true;
                      }
                      // 주문 들어올 경우 스낵바 구현
                      Get.snackbar(
                        "주문 접수!!",
                        "주문이 들어왔습니다!!",
                        backgroundColor: Colors.white,
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B88C2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: const Size(70, 40),
                  ),
                  child: const Text(
                    '완료',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 주문 정보 컨테이너
            Expanded(
              child: ListView.builder(
                itemCount: orderList.length,
                itemBuilder: (context, index) {
                  final order = orderList[index];
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    order['title'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Icon(
                                    Icons.circle,
                                    color: order['isCompleted'] == true
                                        ? const Color(0xFF13D313)
                                        : const Color(0xFFB3A9A9),
                                    size: 10.0,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    '완료',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 13),

                              // 주문 시간
                              Text(
                                order['time'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 5),

                              // 주문 정보
                              Text(
                                order['information'],
                                style: const TextStyle(
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
                                  Text(
                                    '총 가격 : ${order['price']}원',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReviewPage(
                                            order['title'],
                                          ), // ReceiptPage에서는 selectedStore에 orderList의 title을 집어넣음
                                        ),
                                      );
                                    },
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
                                  ),
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
