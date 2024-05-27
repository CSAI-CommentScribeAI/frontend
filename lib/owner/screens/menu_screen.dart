import 'package:flutter/material.dart';
import 'package:frontend/owner/screens/addMenu_screen.dart';
import 'package:frontend/owner/widgets/store_widget.dart';

class MenuPage extends StatefulWidget {
  final String selectedStore;
  const MenuPage(this.selectedStore, {super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool saveColor = false;
  bool isMenuOrderByName = true; // true: 가나다 순, false: 최신 등록 순

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 사용자가 화면을 터치했을 때 포커스를 해제하는 onTap 콜백 정의
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F3FF), // 배경색 설정
        appBar: AppBar(
          actions: const [
            // 오른쪽 상단에 프로필 아이콘을 나타내는 아이콘 추가
            Padding(
              padding: EdgeInsets.only(right: 23.0),
              child: Icon(
                Icons.account_circle,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
          // 가게 이름을 표시하는 타이틀 설정
          title: Text(
            widget.selectedStore,
            style: const TextStyle(
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
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add,
                    color: Color(0xFF374AA3),
                    size: 24,
                  ),
                  const SizedBox(width: 4), // 아이콘과 텍스트 사이 간격 조절
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddMenuPage()));
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      '메뉴 추가',
                      style: TextStyle(
                        color: Color(0xFF374AA3), // 버튼 텍스트 색상
                        fontWeight: FontWeight.bold, // 버튼 텍스트 굵기
                        fontSize: 15, // 버튼 텍스트 크기
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.swap_vert,
                        color: Color(0xFF374AA3),
                        size: 24,
                      ),
                      SizedBox(
                        width: 74,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              isMenuOrderByName = !isMenuOrderByName;
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            isMenuOrderByName ? '가나다 순' : '최신 등록 순',
                            style: const TextStyle(
                              color: Color(0xFF374AA3),
                              fontWeight: FontWeight.bold,
                              fontSize: 15, // 버튼 텍스트 크기
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20), // 아이콘과 텍스트 사이 간격 조절

                  Padding(
                    padding: EdgeInsets.only(left: saveColor ? 100 : 126),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            saveColor = !saveColor;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: saveColor
                              ? const Color(0xFF374AA3).withOpacity(0.66)
                              : const Color(0xFFB3A9A9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            // 아이콘 크기 조절
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (saveColor == true)
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              saveColor = !saveColor;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: const Color(0xFFB3A9A9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Align(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  height: 150,
                  width: 380,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
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
                      ListTile(
                        // 메뉴 사진
                        leading: Image.asset(
                          "assets/images/olive.png",
                          width: 100,
                          height: 70,
                          fit: BoxFit.fill,
                        ),
                        // 메뉴 이름
                        title: const Text(
                          "황금올리브치킨",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        // 소개글과 가격
                        subtitle: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "최고의 맛과 최고 부위로 만든 치킨",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF808080),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              "20,000원",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Align(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  height: 150,
                  width: 380,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
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
                      ListTile(
                        // 메뉴 사진
                        leading: Image.asset(
                          "assets/images/jamaican.png",
                          width: 100,
                          height: 70,
                          fit: BoxFit.fill,
                        ),
                        // 메뉴 이름
                        title: const Text(
                          "자메이칸 통다리 치킨",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        // 소개글과 가격
                        subtitle: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "자메이카풍의 쫄깃한 통다리",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF808080),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              "21,500원",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Align(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  height: 150,
                  width: 380,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
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
                      ListTile(
                        // 메뉴 사진
                        leading: Image.asset(
                          "assets/images/wing.png",
                          width: 100,
                          height: 70,
                          fit: BoxFit.fill,
                        ),
                        // 메뉴 이름
                        title: const Text(
                          "바사칸 윙",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        // 소개글과 가격
                        subtitle: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "후추와 마늘의 알싸한 매운맛과 구운 소금의 단백함이 더해진 바삭한 치킨",
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFF808080)),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              "21,500원",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),

        bottomNavigationBar: BottomAppBar(
          color: const Color(0xFF374AA3),
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(), // Gridview의 스크롤 방지
            crossAxisCount: 3, // 1개의 행에 보여줄 item의 개수
            crossAxisSpacing: 10.0, // 같은 행의 iteme들 사이의 간격
            children: [
              storeItem(imgPath: 'assets/images/bottom_home.png', title: '홈'),
              storeItem(
                  imgPath: 'assets/images/bottom_store.png', title: '가게 관리'),
              storeItem(imgPath: 'assets/images/bottom_my.png', title: 'MY'),
            ],
          ),
        ),
      ),
    );
  }
}
