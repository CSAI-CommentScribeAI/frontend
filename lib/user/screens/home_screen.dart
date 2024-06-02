import 'package:flutter/material.dart';

class userHomePage extends StatefulWidget {
  const userHomePage({super.key});

  @override
  State<userHomePage> createState() => _userHomePageState();
}

class _userHomePageState extends State<userHomePage> {
  final List<Map<String, String>> menuItems = [
    {'image': 'assets/images/hamburger.png', 'name': '햄버거'},
    {'image': 'assets/images/chicken1.png', 'name': '치킨'},
    {'image': 'assets/images/pizza.png', 'name': '피자'},
    {'image': 'assets/images/koreanfood.png', 'name': '한식'},
    {'image': 'assets/images/deliverylogo.png', 'name': 'CSAI'},
    {'image': 'assets/images/japanesefood.png', 'name': '일식'},
    {'image': 'assets/images/koreanstreetfood.png', 'name': '분식'},
    {'image': 'assets/images/chinesefood.png', 'name': '중식'},
    {'image': 'assets/images/dessert.png', 'name': '디저트'},
  ];

  List<Map<String, String>> filteredMenuItems = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredMenuItems = menuItems;
  }

  void filterSearchResults(String query) {
    List<Map<String, String>> dummySearchList = [];
    dummySearchList.addAll(menuItems);
    if (query.isNotEmpty) {
      List<Map<String, String>> dummyListData = [];
      for (var item in dummySearchList) {
        if (item['name']!.contains(query)) {
          dummyListData.add(item);
        }
      }
      setState(() {
        filteredMenuItems = dummyListData;
      });
      return;
    } else {
      setState(() {
        filteredMenuItems = menuItems;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3FF),
      appBar: AppBar(
        automaticallyImplyLeading: false, // 페이지 이동 시 자동으로 생긴 뒤로가기 버튼 숨김
        backgroundColor: const Color(0xFF374AA3),

        // 배달앱 이름
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: '서울특별시 서초구 강남대로 311',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        centerTitle: false,
        actions: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Image.asset(
                  'assets/images/bottom_my.png',
                  width: 28.24,
                  height: 32,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Icon(
                  Icons.shopping_cart,
                  size: 32, // 아이콘 크기 설정
                  color: Colors.white, // 아이콘 색상 설정
                ),
              ),
            ),
            onTap: () {
              // 여기에 원하는 onTap 동작을 추가하세요.
              print('Shopping cart icon tapped');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Center(
          child: Column(
            children: [
              // 첫 번째 박스
              Container(
                width: 400,
                height: 88,
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.only(bottom: 16.0), // 박스들 사이 간격
                decoration: BoxDecoration(
                  color: const Color(0xFFAEAEE5).withOpacity(0.25),
                  borderRadius: BorderRadius.circular(15.0), // 박스 둥근 비율
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '오늘의 배달 Tip',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Image.asset(
                            'assets/images/light.png',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '오늘의 배달팁 알려주세요',
                      style: TextStyle(
                        color: Color(0xFFC6C2C2),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              // 두 번째 박스
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 19.0),
                child: Container(
                  padding: const EdgeInsets.only(left: 14),
                  width: 400,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF374AA3).withOpacity(0.5),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 4.0),
                            child: Icon(
                              Icons.search,
                              color: Color(0xFFC6C2C2),
                              size: 14,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                filterSearchResults(value);
                              },
                              controller: searchController,
                              decoration: const InputDecoration(
                                hintText: '뭐든 다 좋아 다 나와라!!!',
                                hintStyle: TextStyle(
                                  color: Color(0xFFC6C2C2),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 13),
              Container(
                // 세 번째 박스
                height: 127,
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  color: Color(0xffAEAEE5),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'CSAI 회원이라면 놓칠 수 없지!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'CSAI만의 ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 11,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '무료 배달',
                                    style: TextStyle(
                                      color: Colors.red, // 여기에 원하는 색상으로 변경
                                      fontSize: 11,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' 멤버십!!!',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 11,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 69),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Image.asset(
                        'assets/images/free.png',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // 음식 메뉴
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19.0),
                  child: GridView.count(
                    crossAxisCount: 3, // 3 x 3
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: List.generate(menuItems.length, (index) {
                      bool isDeliveryLogo = menuItems[index]['image'] ==
                          'assets/images/deliverylogo.png';
                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF374AA3).withOpacity(0.5),
                              blurRadius: 4,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              menuItems[index]['image']!,
                              height: isDeliveryLogo ? 108 : 50,
                              width: isDeliveryLogo ? 108 : 50,
                            ),
                            if (!isDeliveryLogo) ...[
                              const SizedBox(height: 10),
                              Text(
                                menuItems[index]['name']!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
