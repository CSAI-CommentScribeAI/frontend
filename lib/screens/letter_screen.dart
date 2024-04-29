import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LetterPage extends StatefulWidget {
  const LetterPage({super.key});

  @override
  State<LetterPage> createState() => _LetterPageState();
}

class _LetterPageState extends State<LetterPage> {
  bool isBottomShowed = false; // 아이콘 하단바 보여주기
  CarouselController controller = CarouselController();
  int currentPageIndex = 0; // 중앙 페이지의 인덱스를 추적하기 위한 변수
  bool isCurrent = false;

  List<Widget> overlayWidgets = [];

  List<Map<String, dynamic>> templateList = [
    {
      'title': '크리스마스',
      'url': 'assets/templates/christmas.png',
    },
    {
      'title': '나뭇잎',
      'url': 'assets/templates/leaf.png',
    },
    {
      'title': '가을바람',
      'url': 'assets/templates/autumn.png',
    },
    {
      'title': '개구리',
      'url': 'assets/templates/frog.png',
    },
  ];

  List<Map<String, dynamic>> iconList = [
    {'url': 'assets/characters/christmasBall.png'},
    {'url': 'assets/characters/christmasGift.png'},
    {'url': 'assets/characters/christmasPenguin.png'},
    {'url': 'assets/characters/christmasPlants.png'},
    {'url': 'assets/characters/christmasStocking.png'},
    {'url': 'assets/characters/christmasTree.png'},
    {'url': 'assets/characters/gingerbreadMan.png'},
    {'url': 'assets/characters/rainbow.png'},
    {'url': 'assets/characters/santaClausBag.png'},
    {'url': 'assets/characters/snowflake.png'},
    {'url': 'assets/characters/sun.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3FF),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFF374AA3),
        toolbarHeight: 70,
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: BackButton(
            color: Colors.white,
          ),
        ),
        title: const Text(
          '편지 서비스',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 편지내역 버튼
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 300.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B88C2),
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  minimumSize: const Size(80, 35),
                ),
                child: const Text(
                  '편지 내역',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 템플릿 리스트
            Expanded(
              child: makeList(),
            ),

            // 캐릭터 추가 버튼
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isBottomShowed = !isBottomShowed;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B88C2),
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                minimumSize: const Size(205, 38),
              ),
              child: const Text(
                '캐릭터 추가하기',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
      bottomNavigationBar: isBottomShowed
          ? BottomAppBar(
              color: const Color(0xFFE8E8FF),
              height: 130,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        '캐릭터 추가',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.add_circle),
                      )
                    ],
                  ),
                  Stack(
                    children: [
                      SingleChildScrollView(
                        child: SizedBox(
                          height: 55,
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                            ),
                            itemCount: iconList.length,
                            itemBuilder: (context, index) {
                              return Draggable<Map<String, dynamic>>(
                                data: iconList[index],
                                feedback: Material(
                                  elevation: 4.0,
                                  child: Image.asset(
                                    iconList[index]['url'],
                                    height: 100,
                                  ),
                                ),
                                child: Image.asset(
                                  iconList[index]['url'],
                                  height: 100,
                                ),
                                onDragEnd: (dragDetails) {
                                  setState(() {
                                    overlayWidgets.add(
                                      Positioned(
                                        left: dragDetails.offset.dx - 73,
                                        top: dragDetails.offset.dy - 255,
                                        child: Image.asset(
                                          iconList[index]['url'],
                                          height: 100,
                                        ),
                                      ),
                                    );
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      ...overlayWidgets,
                    ],
                  ),
                ],
              ),
            )
          : ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF374AA3),
                minimumSize: const Size(
                  double.infinity,
                  80,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              child: const Text(
                '템플릿 저장',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }

  // 편지지 템플릿 Carousel 리스트
  CarouselSlider makeList() {
    return CarouselSlider.builder(
      carouselController: controller,
      itemCount: templateList.length,
      itemBuilder: (context, index, pageViewIndex) {
        return DragTarget<String>(
          onWillAccept: (data) => true, // 모든 데이터를 받아들임
          onAccept: (data) {},
          builder: (context, candidateData, rejectedData) {
            return Column(
              children: [
                Text(
                  templateList[index]['title']!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Stack(
                  children: [
                    Container(
                      height: 450,
                      width: 320,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 4.0,
                            offset: const Offset(0, 4),
                          )
                        ],
                        image: DecorationImage(
                          image: AssetImage(templateList[index]['url']!),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    ...overlayWidgets,
                  ],
                ),
              ],
            );
          },
        );
      },
      options: CarouselOptions(
        autoPlay: false,
        enlargeCenterPage: true,
        viewportFraction: 1,
        aspectRatio: 1 / 1.4,
        scrollDirection: Axis.horizontal,
        // 페이지를 넘길 때마다 중앙 페이지 인덱스를 알기 위해 currentCenterPageIndex에 저장
        onPageChanged: (index, reason) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
    );
  }
}
