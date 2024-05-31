import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserMenuselectPage extends StatefulWidget {
  const UserMenuselectPage({super.key});

  @override
  State<UserMenuselectPage> createState() => _UserMenuselectPageState();
}

class _UserMenuselectPageState extends State<UserMenuselectPage> {
  bool isRecommendSelected = true; // 추천, 전체 메뉴 선택 여부

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3FF),
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
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Hero(
              tag: 'selectMenu',
              child: Container(
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
                      borderRadius: BorderRadius.circular(15.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
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
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '최소 주문 16,000원',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF808080),
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.star,
                                    color: Color(0xFFDFB300), size: 15),
                                SizedBox(width: 4),
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
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        '리뷰 93개',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite),
                        color: Colors.red,
                        iconSize: 30,
                        onPressed: () {},
                      ),
                      const SizedBox(width: 2),
                      const Text(
                        '966',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Text(
                        '최소주문',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF808080),
                        ),
                      ),
                      SizedBox(
                        width: 42,
                      ),
                      Text(
                        '17,000원',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Text(
                        '가게설명',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF808080),
                        ),
                      ),
                      SizedBox(
                        width: 42,
                      ),
                      Text(
                        '피자에 미쳐버린 당신을 위해~~',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Text(
                        '가게주소',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF808080),
                        ),
                      ),
                      SizedBox(
                        width: 42,
                      ),
                      Text(
                        '서울특별시 서초구 서초대로50길 63 2층 202호',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isRecommendSelected = true;
                        });
                      },
                      child: Text(
                        '추천메뉴',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: isRecommendSelected
                              ? Colors.black
                              : const Color(0xFF808080),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isRecommendSelected = false;
                        });
                      },
                      child: Text(
                        '전체메뉴',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: isRecommendSelected
                              ? const Color(0xFF808080)
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Stack(
                  // Stack 위젯은 자식 위젯들을 서로 겹쳐놓는 데 사용
                  children: [
                    // Align 위젯: 자식 위젯을 특정 위치에 정렬하는 위젯
                    Align(
                      // alignment 속성: isRecommendSelected 변수에 따라 정렬 위치를 결정
                      alignment: isRecommendSelected
                          ? Alignment.centerLeft // 추천메뉴가 선택되었을 때 왼쪽 정렬
                          : Alignment.centerRight, // 전체메뉴가 선택되었을 때 오른쪽 정렬
                      child: Container(
                        // width: 화면 너비의 절반에서 20픽셀을 뺀 값
                        width: MediaQuery.of(context).size.width * 0.5 - 20,
                        height: 2,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                isRecommendSelected
                    ? recommendMenuSection()
                    : allMenuSection(), // 추천 메뉴 위젯, 전체 메뉴 위젯 호출
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget recommendMenuSection() {
    // 추천 메뉴 섹션
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: const Text(
        '추천 메뉴 섹션입니다.',
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  Widget allMenuSection() {
    // 전체 메뉴 섹션
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: const Text(
        '전체 메뉴 섹션입니다.',
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}
