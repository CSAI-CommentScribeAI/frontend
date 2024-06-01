import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserMenuSelectPage extends StatefulWidget {
  const UserMenuSelectPage({super.key});

  @override
  State<UserMenuSelectPage> createState() => _UserMenuSelectPageState();
}

void showReviewsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
          padding: const EdgeInsets.all(30.0),
          height: 270,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '리뷰 유형',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
            // 여기에 리뷰 목록을 추가하세요.
            Row(
              children: [
                const Text(
                  '우리 배달앱 리뷰보기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 184),
                ClipRRect(
                  // 둥근 정도 조절
                  borderRadius: BorderRadius.circular(5.0),
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset(
                      'assets/images/mydelivery.png',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 21),
            const Divider(), // 구분선 생성
            const SizedBox(height: 21),
            Row(
              children: [
                const Text(
                  '우리 배달앱 리뷰보기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 180),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset(
                      'assets/images/maindelivery.png',
                    ),
                  ),
                ),
              ],
            ),
          ]));
    },
  );
}

class _UserMenuSelectPageState extends State<UserMenuSelectPage> {
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
                      TextButton(
                        onPressed: () {
                          showReviewsBottomSheet(context);
                        },
                        child: const Text(
                          '리뷰 93개',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
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
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: 0, left: 10), // 텍스트와 구분선 사이 간격 조정
                child: Text(
                  '전체 메뉴',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const Divider(), // 구분선
            allMenuSection(), // 전체 메뉴 위젯 호출
          ],
        ),
      ),
    );
  }

  Widget allMenuSection() {
    // 전체 메뉴 섹션
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                // 첫 번째 메뉴
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '페퍼로니 알리오올리오',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '20,000원',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '토마토 소스 위에 페퍼로니를 크리스피하게 굽고, 버진 올리브유와 편마늘, 페퍼론치노의 조화',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF808080),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // 여기에 원하는 동작을 추가하세요.
                          },
                          child: Image.asset(
                            'assets/images/goodjob.png',
                            width: 24, // 이미지 크기 조정
                            height: 24,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '211명',
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
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset(
                    'assets/images/menupizza.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20), // 메뉴 간의 간격
          const Divider(), // 구분선 추가
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                // 두 번째 메뉴
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '시칠리안 갈릭쉬림프',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '19,900원',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '매콤한 살사 소스와 도톰한 새우와 베이컨, 마늘을 곁들인 뒤 루꼴라와 샤워크림으로 마무리',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF808080),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // 여기에 원하는 동작을 추가하세요.
                          },
                          child: Image.asset(
                            'assets/images/goodjob.png',
                            width: 24, // 이미지 크기 조정
                            height: 24,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '189명',
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
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset(
                    'assets/images/menushrimp.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
