import 'package:flutter/material.dart';
import 'package:frontend/owner/charts/feedback_chart.dart';
import 'package:frontend/owner/models/store_model.dart';
import 'package:frontend/owner/providers/store_provider.dart';
import 'package:frontend/owner/screens/feedback_screen.dart';
import 'package:frontend/owner/screens/menu_screen.dart';
import 'package:frontend/owner/screens/orderDetail_screen.dart';
import 'package:frontend/owner/screens/register_store.dart';
import 'package:frontend/owner/screens/receipt_screen.dart';
import 'package:frontend/owner/screens/review_screen.dart';
import 'package:frontend/owner/screens/store_screen.dart';
import 'package:frontend/owner/widgets/circle_widget.dart';
import 'package:frontend/owner/widgets/current_widget.dart';
import 'package:frontend/owner/widgets/menuItem_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int storeId = 0; // 주문내역에 사용할 가게 아이디
  late int storeIndex; // 가게 관리나 메뉴 관리 때 사용할 인덱스
  bool light = true;
  bool isExpanded = false; // 확장 유무(Expaned_less,more)
  String selectedStore = ''; // 선택한 가게의 이름을 저장할 변수
  bool titleOpacity = false; // 가게명 투명도
  bool thisColor = true; // 선택되었을 때 원 색깔
  bool lastColor = false;

  int storeNum = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<List<StoreModel>> getStoresData() async {
    return Provider.of<StoreProvider>(context, listen: false).storeList;
  }

  Future<void> chooseStore(BuildContext context) async {
    // showModalBottomSheet가 반환하는 Future<bool>을 받아옴
    final refresh = await showModalBottomSheet<bool>(
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
                              isExpanded = false;
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
                      child: FutureBuilder<List<StoreModel>>(
                        // getStore() 메서드를 호출해서 데이터를 가져옴
                        future: getStoresData(),
                        builder: (context, snapshot) {
                          // 데이터가 로드되는 동안 로딩 스피너 표시
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );

                            // 데이터 로드 중 에러 발생 시 오류 메세지 표시
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );

                            // 데이터가 없거나 빈 리스트일 경우 '등록된 가게가 없습니다' 메시지 표시
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('등록된 가게가 없습니다.'),
                            );

                            // 데이터가 성공적으로 로드될 경우 가게 목록 표시
                          } else {
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),

                              // snapshot.data: getStore에서 리턴한 리스트
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                final store =
                                    snapshot.data![index]; // 현재 인덱스의 가게 데이터
                                return ListTile(
                                  onTap: () async {
                                    setState(() {
                                      selectedStore = store.name;
                                      storeIndex = index;
                                      storeId =
                                          store.id; // id값이 storeId에 실시간 저장
                                      isExpanded = false;
                                    });

                                    print('선택된 가게 이름: ${store.name}');
                                    print('선택된 가게 아이디: ${store.id}');

                                    Navigator.pop(context);
                                  },
                                  title: Text(
                                    store.name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                              // trailing에서 showCircle 구현하기
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const Divider();
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final refreshResult = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RegisterStorePage(selectedStore)),
                        );
                        if (context.mounted) {
                          Navigator.pop(context, refreshResult);
                        }
                      },
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
            );
          },
        );
      },
    );
    // refresh가 true일 경우 상태를 갱신하여 새로고침
    if (refresh == true) {
      setState(() {});
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
                                              onTap: () async {
                                                // 호출되고 나서 모달시트가 호출
                                                // async-await를 하지 않으면 호출되기 전에 모달시트가 보여져 가게 목록이 띄워지지 않을 수 있음
                                                await Provider.of<
                                                            StoreProvider>(
                                                        context,
                                                        listen: false)
                                                    .getStores(); // 가게 조회 호출

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
                          physics: const ScrollPhysics(), // Gridview의 스크롤 방지
                          crossAxisCount: 3, // 1개의 행에 보여줄 item의 개수
                          crossAxisSpacing: 10.0, // 같은 행의 iteme들 사이의 간격
                          childAspectRatio: 1.5, // Gridview 위젯 높이 조절
                          children: [
                            GestureDetector(
                              onTap: () {
                                print('가게 아이디 : $storeId');

                                if (selectedStore.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OrderDetailPage(storeId),
                                    ),
                                  );
                                }
                              },
                              child: menuItem(
                                  imgPath: 'assets/images/status.png',
                                  title: '주문내역'),
                            ),
                            GestureDetector(
                              onTap: () {
                                // 가게 선택하지 않을 경우 못 들어가게 설정
                                if (selectedStore.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StorePage(
                                        storeId: storeId,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: menuItem(
                                  imgPath: 'assets/images/store.png',
                                  title: '가게관리'),
                            ),
                            GestureDetector(
                              onTap: () {
                                print('storeId: $storeId');
                                // 가게 선택하지 않을 경우 못 들어가게 설정
                                if (selectedStore.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MenuPage(
                                        storeId,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: menuItem(
                                  imgPath: 'assets/images/menu.png',
                                  title: '메뉴관리'),
                            ),
                            GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReceiptPage(storeId),
                                  ),
                                );
                              },
                              child: menuItem(
                                  imgPath: 'assets/images/receipt.png',
                                  title: '접수관리'),
                            ),
                            GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ReviewPage(selectedStore),
                                  ),
                                );
                              },
                              child: menuItem(
                                  imgPath: 'assets/images/review.png',
                                  title: '리뷰관리'),
                            ),
                            GestureDetector(
                              onTap: () {
                                // 가게 선택하지 않을 경우 못 들어가게 설정
                                if (selectedStore.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FeedbackPage(selectedStore),
                                    ),
                                  );
                                }
                              },
                              child: menuItem(
                                  imgPath: 'assets/images/feedback2.png',
                                  title: '피드백'),
                            ),
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
