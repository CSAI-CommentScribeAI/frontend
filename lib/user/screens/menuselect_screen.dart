import 'package:flutter/material.dart';

class userMenuPage extends StatefulWidget {
  const userMenuPage({super.key});

  @override
  State<userMenuPage> createState() => _userMenuPageState();
}

class _userMenuPageState extends State<userMenuPage> {
  int selectedButtonIndex = -1;

  void handleButtonSelection(int index) {
    setState(() {
      selectedButtonIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 사용자가 화면을 터치했을 때 포커스를 해제하는 onTap 콜백 정의
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F3FF),
        appBar: AppBar(
          actions: const [
            // 오른쪽 상단에 프로필 아이콘을 나타내는 아이콘 추가
            Padding(
              padding: EdgeInsets.only(right: 23.0),
              child: Icon(
                Icons.shopping_cart,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
          // 가게 이름을 표시하는 타이틀 설정
          title: const Text(
            'CSAI 배달',
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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal, // 버튼 가로 스크롤
                child: Row(
                  children: [
                    SizedBox(
                      // 버튼 1
                      width: 55,
                      height: 28,
                      child: TextButton(
                        onPressed: () {
                          handleButtonSelection(0);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: selectedButtonIndex == 0
                              ? const Color(0xFF7E7EB2)
                              : const Color(0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          // 박스 데코레이션 추가
                          side:
                              BorderSide(color: Colors.white.withOpacity(0.25)),
                        ),
                        child: const Text(
                          '추천순',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 9), // 버튼 사이의 간격
                    SizedBox(
                      // 버튼 2
                      width: 68,
                      height: 28,
                      child: TextButton(
                        onPressed: () {
                          handleButtonSelection(1);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: selectedButtonIndex == 1
                              ? const Color(0xFF7E7EB2)
                              : const Color(0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          // 박스 데코레이션 추가
                          side:
                              BorderSide(color: Colors.white.withOpacity(0.25)),
                        ),
                        child: const Text(
                          '주문많은순',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 9), // 버튼 사이의 간격
                    SizedBox(
                      // 버튼 3
                      width: 60,
                      height: 28,
                      child: TextButton(
                        onPressed: () {
                          handleButtonSelection(2);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: selectedButtonIndex == 2
                              ? const Color(0xFF7E7EB2)
                              : const Color(0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          // 박스 데코레이션 추가
                          side:
                              BorderSide(color: Colors.white.withOpacity(0.25)),
                        ),
                        child: const Text(
                          '가까운순',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 9), // 버튼 사이의 간격
                    SizedBox(
                      // 버튼 4
                      width: 68,
                      height: 28,
                      child: TextButton(
                        onPressed: () {
                          handleButtonSelection(3);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: selectedButtonIndex == 3
                              ? const Color(0xFF7E7EB2)
                              : const Color(0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          // 박스 데코레이션 추가
                          side:
                              BorderSide(color: Colors.white.withOpacity(0.25)),
                        ),
                        child: const Text(
                          '별점많은순',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 9), // 버튼 사이의 간격
                    SizedBox(
                      // 버튼 5
                      width: 68,
                      height: 28,
                      child: TextButton(
                        onPressed: () {
                          handleButtonSelection(4);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: selectedButtonIndex == 4
                              ? const Color(0xFF7E7EB2)
                              : const Color(0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          // 박스 데코레이션 추가
                          side:
                              BorderSide(color: Colors.white.withOpacity(0.25)),
                        ),
                        child: const Text(
                          '신규매장순',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 9), // 버튼 사이의 간격
                    SizedBox(
                      // 버튼 6
                      width: 70,
                      height: 28,
                      child: TextButton(
                        onPressed: () {
                          handleButtonSelection(5);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: selectedButtonIndex == 5
                              ? const Color(0xFF7E7EB2)
                              : const Color(0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          side:
                              BorderSide(color: Colors.white.withOpacity(0.25)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '필터순',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(width: 4), // 텍스트와 아이콘 사이의 간격
                            Icon(
                              Icons.filter_alt,
                              color: Colors.white,
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                height: 132,
                padding: const EdgeInsets.only(right: 20.0),
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
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0), // 둥근 정도
                      child: SizedBox(
                        width:
                            MediaQuery.of(context).size.width / 3, // 가로 너비의 1/3
                        height: 132,
                        child: Image.asset(
                          'assets/images/pizzalogo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '피자에 미치다 교대역점',
                              style: TextStyle(
                                fontSize: 22, // 폰트 크기
                                fontWeight: FontWeight.bold, // 폰트 굵기
                                color: Colors.black, // 폰트 색상
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '최소 주문 16,000원',
                              style: TextStyle(
                                fontSize: 12, // 폰트 크기
                                color: Color(0xFF808080), // 폰트 색상
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.star,
                                    color: Color(0xFFDFB300), size: 15),
                                SizedBox(width: 4), // 별점과 숫자 간의 간격
                                Text(
                                  '4.75',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                height: 132,
                padding: const EdgeInsets.only(right: 20.0),
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
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0), // 둥근 정도
                      child: SizedBox(
                        width:
                            MediaQuery.of(context).size.width / 3, // 가로 너비의 1/3
                        height: 132,
                        child: Image.asset(
                          'assets/images/pizzalogo1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '도치 피자 강남점',
                              style: TextStyle(
                                fontSize: 22, // 폰트 크기
                                fontWeight: FontWeight.bold, // 폰트 굵기
                                color: Colors.black, // 폰트 색상
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '최소 주문 14,000원',
                              style: TextStyle(
                                fontSize: 12, // 폰트 크기
                                color: Color(0xFF808080), // 폰트 색상
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.star,
                                    color: Color(0xFFDFB300), size: 15),
                                SizedBox(width: 4), // 별점과 숫자 간의 간격
                                Text(
                                  '4.39',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
