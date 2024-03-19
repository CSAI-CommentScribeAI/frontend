import 'package:flutter/material.dart';
import 'package:frontend/widgets/menuItem_widget.dart';
import 'package:frontend/feedback/feedback_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool light = false;
  bool isExpanded = false;

  List<Map<String, dynamic>> storeList = [
    {
      "title": "BBQ 코엑스점",
      "style": const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      "showCircle": false,
    },
    {
      "title": "이남장 서초점",
      "style": const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      "showCircle": false,
    },
  ];

  Widget circle() {
    return Padding(
      padding: const EdgeInsets.only(right: 21.0),
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: const Color(0xFF7B88C2),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  void chooseStore(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (BuildContext context) {
        // showModalBottomSheet 위젯에서 setState 처리할 때 사용
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter bottomState) {
            // StateSetter bottomState 이름은 바꾸셔서 사용하실 수 있습니다.
            // 예를 들어, myState, subState 같이요!

            // 모달 내부 영역
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(31.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '보유가게',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  // 보유 가게 리스트
                  // Column 위젯의 높이가 자식 위젯들의 높이보다 작아서 발생을 막기 위해 사용(Expanded)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      // Listview를 쓸 때 자주 발생하는 오류를 막기 위해 singlechildscrollview 함수 사용
                      // Column 자체를 스크롤하게끔 하는 코드 (SingleChildScrollView)
                      child: SingleChildScrollView(
                        physics: const ScrollPhysics(),
                        child: Column(
                          children: [
                            ListView.separated(
                              shrinkWrap: true, // child 크기만큼만 높이를 정해줌
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: storeList.length,
                              itemBuilder: (BuildContext context, int index) {
                                final store = storeList[index];
                                return ListTile(
                                  onTap: () {
                                    // bottomState만 적용하면 bottomSheet 값은 즉시 반영되지만 parent 값은 변경되지 않음
                                    // 그래서 꼭 setState()를 같이 추가해주어야 함
                                    bottomState(() {
                                      setState(() {
                                        // 선택한 가게의 인덱스를 받아 index(선택 가게 인덱스)와 i값이 일치하면 true
                                        // 나머지 가게는 false
                                        for (int i = 0;
                                            i < storeList.length;
                                            i++) {
                                          if (i == index) {
                                            storeList[i]["showCircle"] = true;
                                          } else {
                                            storeList[i]["showCircle"] = false;
                                          }
                                        }
                                      });
                                    });
                                  },
                                  title: Text(
                                    store["title"],
                                    style: store["style"],
                                  ),
                                  trailing:
                                      store["showCircle"] ? circle() : null,
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const Divider();
                              },
                            ),
                            Transform.translate(
                              offset: const Offset(0, -10.0),
                              child: Container(
                                alignment: Alignment.center,
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.add),
                                  label: const Text(
                                    '가게 등록',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF7B88C2),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    shadowColor: Colors.white.withOpacity(0.25),
                                    elevation: 10.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // 가게 등록 버튼
                ],
              ),
            );
          },
        );
      },
    );
    setState(() {
      light = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF374AA3),

        // 배달앱 이름
        title: const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            'CSAI 사장님',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: false,

        // 피드백 아이콘
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FeedbackPage(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Image.asset(
                  'assets/images/feedback.png',
                  width: 28.24,
                  height: 32,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 120,
                decoration: const BoxDecoration(
                  color: Color(0xFF374AA3),
                ),
              ),
              // 알림창
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 19.0),
                child: Container(
                  width: double.infinity,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9D9D9),
                  ),
                  child: const Text(
                    '알림 뜰 때만 보이게',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              // 보유 가게 박스
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 19.0),
                child: Align(
                  child: Transform.translate(
                    offset: const Offset(0.0, 63.0),
                    child: Container(
                      height: 144,
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
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 23.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          '보유 가게',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            chooseStore(context);
                                          },
                                          child: const Icon(Icons.expand_less),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      '보유하신 가게 전체 확인 가능합니다',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFFC6C2C2),
                                      ),
                                    ),
                                  ],
                                ),
                                Transform.scale(
                                  scale: 1.2,
                                  child: Switch(
                                    value: light,
                                    activeColor: const Color(0xFFD6D6F8),
                                    onChanged: (bool value) {
                                      setState(() {
                                        light = value;
                                        if (light) {
                                          chooseStore(context);
                                        }
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              '가게별 시간 설정',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 82),

          // 전체 메뉴
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 19.0),
            child: Container(
              padding: const EdgeInsets.all(22.0),
              width: double.infinity,
              height: 215,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '전체 메뉴',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 21),

                  // overflow 방비
                  Flexible(
                    // 전체 메뉴 리스트(Gridview)
                    child: GridView.count(
                      crossAxisCount: 4, // 1개의 행에 보여줄 item의 개수
                      crossAxisSpacing: 20.0, // 같은 행의 iteme들 사이의 간격
                      children: [
                        menuItem(
                            imgPath: 'assets/images/status.png', title: '전체현황'),
                        menuItem(
                            imgPath: 'assets/images/store.png', title: '가게관리'),
                        menuItem(
                            imgPath: 'assets/images/menu.png', title: '메뉴관리'),
                        menuItem(
                            imgPath: 'assets/images/receipt.png',
                            title: '접수관리'),
                        menuItem(
                            imgPath: 'assets/images/review.png', title: '리뷰관리'),
                        menuItem(
                            imgPath: 'assets/images/connexion.png',
                            title: '단골고객'),
                        menuItem(
                            imgPath: 'assets/images/feedback2.png',
                            title: '피드백'),
                        menuItem(
                            imgPath: 'assets/images/black.png', title: '블랙리스트'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
