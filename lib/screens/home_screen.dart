import 'package:flutter/material.dart';
import 'package:frontend/charts/feedback_chart.dart';
import 'package:frontend/screens/Menu_screen.dart';
import 'package:frontend/screens/feedback_screen.dart';
import 'package:frontend/screens/receipt_screen.dart';
import 'package:frontend/screens/review_screen.dart';
import 'package:frontend/screens/store_screen.dart';
import 'package:frontend/widgets/circle_widget.dart';
import 'package:frontend/widgets/current_widget.dart';
import 'package:frontend/widgets/menuItem_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool light = true;
  bool isExpanded = false; // 확장 유무(Expaned_less,more)
  String selectedStore = ''; // 선택한 가게의 이름을 저장할 변수
  bool titleOpacity = false; // 가게명 투명도
  bool thisColor = true; // 선택되었을 때 원 색깔
  bool lastColor = false;

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
                            setState(() {
                              isExpanded =
                                  true; // 닫기 버튼 눌렀을 때 isExpanded를 true로 변경
                            });
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
                                    // 가게 선택 후 바텀시트 닫기
                                    Navigator.pop(context);
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
                                            // 선택한 가게의 showCircle을 현재 상태의 반대로 설정
                                            storeList[i]["showCircle"] =
                                                !storeList[i]["showCircle"];
                                            // 만약 선택한 가게의 showCircle이 true라면 선택한 가게의 이름을 저장
                                            if (storeList[i]["showCircle"] ==
                                                true) {
                                              selectedStore = store["title"];
                                            } else {
                                              selectedStore =
                                                  ''; // showCircle이 false이면 선택한 가게가 없으므로 ''로 초기화
                                            }
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
                                  trailing: store["showCircle"]
                                      ? const Circle(Color(0xFF7B88C2), 10.0)
                                      : null,
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const Divider();
                              },
                            ),
                            const SizedBox(height: 15),
                            Container(
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    setState(() {
      // 보유 가게 목록이 확장되었는지를 나타내는 상태를 저장
      // 작성해야만 expand_less,more 변경
      isExpanded = !isExpanded;
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
              // 가게 선택하지 않을 경우 못 들어가게 설정
              selectedStore.isNotEmpty
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            // selectedStore에 들어간 가게 이름이 가게 관리 페이지 타이틀에 들어가게 설정
                            FeedbackPage(selectedStore),
                      ),
                    )
                  : '';
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

      // 새로고침
      body: RefreshIndicator(
        onRefresh: () async {
          // 여기에 새로고침 동작을 추가
          // 잠시 대기하는 가짜 비동기 작업 예시
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(), // 스크롤이 상단에 도달할 시 바운스 효과 제거
          child: Column(
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
                          height: 150,
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
                                  vertical: 20.0,
                                  horizontal: 23.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            // 선택한 가게의 이름을 보여줌
                                            Text(
                                              selectedStore.isNotEmpty
                                                  ? selectedStore
                                                  : '보유 가게',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,

                                                // titleOpacity가 true(투명)일 때 grey 색으로
                                                color: titleOpacity
                                                    ? const Color(0xFFC6C2C2)
                                                    : Colors.black,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            // expand_less,more
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isExpanded =
                                                      !isExpanded; // 확장되어 있을 때는 축소하고, 축소되어 있을 때는 확장

                                                  // true일 경우에만 하단 모달시트 보여짐
                                                  if (isExpanded == true) {
                                                    chooseStore(context);
                                                  }
                                                });
                                              },
                                              // 확장 유무에 따라 아이콘 변경
                                              child: isExpanded
                                                  ? const Icon(
                                                      Icons.expand_less)
                                                  : const Icon(
                                                      Icons.expand_more),
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
                                            titleOpacity =
                                                !titleOpacity; // 누를 때마다 titleOpacity 상태 변경
                                          });
                                        },
                                      ),
                                    ),
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
                  height: 225,
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

                      // overflow 방지
                      Flexible(
                        // 전체 메뉴 리스트(Gridview)
                        child: GridView.count(
                          physics:
                              const NeverScrollableScrollPhysics(), // Gridview의 스크롤 방지
                          crossAxisCount: 4, // 1개의 행에 보여줄 item의 개수
                          crossAxisSpacing: 10.0, // 같은 행의 iteme들 사이의 간격
                          children: [
                            menuItem(
                                imgPath: 'assets/images/status.png',
                                title: '전체현황'),
                            GestureDetector(
                              onTap: () {
                                // 가게 선택하지 않을 경우 못 들어가게 설정
                                selectedStore.isNotEmpty
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              // selectedStore에 들어간 가게 이름이 가게 관리 페이지 타이틀에 들어가게 설정
                                              StorePage(selectedStore),
                                        ),
                                      )
                                    : '';
                              },
                              child: menuItem(
                                  imgPath: 'assets/images/store.png',
                                  title: '가게관리'),
                            ),
                            GestureDetector(
                              onTap: () {
                                // 가게 선택하지 않을 경우 못 들어가게 설정
                                selectedStore.isNotEmpty
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              // selectedStore에 들어간 가게 이름이 가게 관리 페이지 타이틀에 들어가게 설정
                                              MenuPage(selectedStore),
                                        ),
                                      )
                                    : '';
                              },
                              child: menuItem(
                                  imgPath: 'assets/images/menu.png',
                                  title: '메뉴관리'),
                            ),
                            menuItem(
                                imgPath: 'assets/images/receipt.png',
                                title: '접수관리'),
                            GestureDetector(
                              onTap: () {
                                // 가게 선택하지 않을 경우 못 들어가게 설정
                                selectedStore.isNotEmpty
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              // selectedStore에 들어간 가게 이름이 가게 관리 페이지 타이틀에 들어가게 설정
                                              ReviewPage(selectedStore),
                                        ),
                                      )
                                    : '';
                              },
                              child: menuItem(
                                  imgPath: 'assets/images/review.png',
                                  title: '리뷰관리'),
                            ),
                            menuItem(
                                imgPath: 'assets/images/connexion.png',
                                title: '단골고객'),
                            GestureDetector(
                              onTap: () {
                                // 가게 선택하지 않을 경우 못 들어가게 설정
                                selectedStore.isNotEmpty
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              // selectedStore에 들어간 가게 이름이 가게 관리 페이지 타이틀에 들어가게 설정
                                              FeedbackPage(selectedStore),
                                        ),
                                      )
                                    : '';
                              },
                              child: menuItem(
                                  imgPath: 'assets/images/feedback2.png',
                                  title: '피드백'),
                            ),
                            menuItem(
                                imgPath: 'assets/images/black.png',
                                title: '블랙리스트'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // 메뉴 접수 현황
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 19.0),
                child: Container(
                  width: double.infinity,
                  height: 210,
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
                  child: Padding(
                    padding: const EdgeInsets.all(22.0), // 내부 padding 전체 22로 설정
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '메뉴 접수 현황',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 접수 현황표
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CurrentCircle(
                                Color(0xFF374AA3), Color(0xFF9A9AE5), '11'),
                            CurrentCircle(
                                Color(0xFF7E7EB2), Color(0xFFD8D8FF), '5'),
                            CurrentCircle(
                                Color(0xFF13D313), Color(0xFFBFE8BF), '6'),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // 현황 표 타이틀
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Transform.translate(
                              offset: const Offset(-3, 0),
                              child: const Row(
                                children: [
                                  Circle(Color(0xFF374AA3), 0),
                                  SizedBox(width: 8),
                                  Text(
                                    '접수중',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(-5, 0),
                              child: const Row(
                                children: [
                                  Circle(Color(0xFF7B88C2), 0),
                                  SizedBox(width: 8),
                                  Text(
                                    '배달중',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(-3, 0),
                              child: const Row(
                                children: [
                                  Circle(Color(0xFF13D313), 0),
                                  SizedBox(width: 8),
                                  Text(
                                    '완료',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // 주간 피드백
              Padding(
                padding: const EdgeInsets.only(
                    left: 19.0, right: 19.0, bottom: 30.0),
                child: Container(
                  width: double.infinity,
                  height: 420,
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
                  child: Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '주간피드백',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Circle(
                                            thisColor
                                                ? const Color(0xFF7B88C2)
                                                : const Color(0xFFC7C7C7),
                                            0),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              // 이번주 버튼을 눌렀을 때 저번주 버튼이 비활성화
                                              thisColor = true;
                                              lastColor = false;
                                            });
                                          },
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                          child: Text(
                                            '이번주',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: thisColor
                                                  ? const Color(0xFF7B88C2)
                                                  : const Color(0xFFC7C7C7),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Circle(
                                        lastColor
                                            ? const Color(0xFF7B88C2)
                                            : const Color(0xFFC7C7C7),
                                        0),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          lastColor = true;
                                          thisColor = false;
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        '저번주',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: lastColor
                                              ? const Color(0xFF7B88C2)
                                              : const Color(0xFFC7C7C7),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // thisColor가 true일 경우 isWeekData에 true를 저장
                        // 반대로 false일 경우 isWeekData에 false를 저장
                        FeedbackChart(isWeekData: thisColor),
                      ],
                    ),
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
