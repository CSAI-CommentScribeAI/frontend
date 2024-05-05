import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';

class LetterPage extends StatefulWidget {
  const LetterPage({super.key});

  @override
  State<LetterPage> createState() => _LetterPageState();
}

class _LetterPageState extends State<LetterPage> {
  late ScrollController scrollController;
  bool charactersOpened = false;
  bool isCompleted = true; // 수정 완료 활성화 여부
  CarouselController controller = CarouselController();
  int currentPageIndex = 0;
  List<Widget> overlayWidgets = [];

  int startIndex = 0;
  int endIndex = 7;

  List<Map<String, dynamic>> templateList = [
    {'title': '크리스마스', 'url': 'assets/templates/christmas.png'},
    {'title': '나뭇잎', 'url': 'assets/templates/leaf.png'},
    {'title': '가을바람', 'url': 'assets/templates/autumn.png'},
    {'title': '개구리', 'url': 'assets/templates/frog.png'},
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
    {'url': 'assets/characters/chick.png'},
    {'url': 'assets/characters/flower.png'},
    {'url': 'assets/characters/smile.png'},
  ];

  List<Map<String, dynamic>> nextIconList = [];

  void loadNextIcons() {
    setState(() {
      // index 7번 뒤로 이동
      startIndex += 7;
      endIndex += 7;
      if (endIndex > iconList.length) {
        // endIndex가 iconList의 길이를 초과하면
        endIndex = iconList.length; // endIndex를 iconList의 길이로 설정하여 초과하지 않도록 보정
        startIndex = endIndex - 7; // startIndex도 맞춰서 수정
      }
    });
  }

  // 이전 버튼 콜백 함수
  void loadPreviousIcons() {
    setState(() {
      // 7개를 보여주기 때문에 index 7번 앞으로 이동
      startIndex -= 7;
      endIndex -= 7;
      if (startIndex < 0) {
        // startIndex가 음수가 되면
        startIndex = 0; // startIndex를 0으로 설정하여 음수가 되지 않도록 보정
        endIndex = startIndex + 7; // endIndex도 맞춰서 수정
      }
    });
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

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
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 300.0),

              // 수정, 완료 버튼
              child: isCompleted
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isCompleted = !isCompleted;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B88C2),
                        elevation: 3.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minimumSize: const Size(50, 30),
                      ),
                      child: const Text(
                        '수정',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isCompleted = !isCompleted;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B88C2),
                        elevation: 3.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minimumSize: const Size(50, 30),
                      ),
                      child: const Text(
                        '완료',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
            ),
            const SizedBox(height: 12),

            // 편지 템플릿
            Flexible(
              child: makeList(),
            ),

            isCompleted
                ? const SizedBox(height: 0)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 캐릭터, 글씨체 버튼
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            charactersOpened = !charactersOpened;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: charactersOpened
                              ? const Color(0xFF7B88C2)
                              : const Color(0xFFD9D9D9),
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          minimumSize: const Size(120, 40),
                        ),
                        child: const Text(
                          '캐릭터',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            charactersOpened = !charactersOpened;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD9D9D9),
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          minimumSize: const Size(120, 40),
                        ),
                        child: const Text(
                          '글씨체',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 15),
          ],
        ),
      ),

      // 하단바
      bottomNavigationBar: isCompleted
          ? ElevatedButton(
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
                '출력하기',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : charactersOpened
              ? BottomAppBar(
                  color: const Color(0xFFE8E8FF),
                  height: 130,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 캐릭터 추가 버튼
                          Row(
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
                              ),
                            ],
                          ),

                          // 캐릭터 이동 버튼
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  loadPreviousIcons();
                                },
                                icon: const Icon(Icons.arrow_back_ios),
                              ),
                              IconButton(
                                onPressed: () {
                                  loadNextIcons();
                                },
                                icon: const Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          SizedBox(
                            height: 55,
                            child: Row(
                              children: iconList
                                  // iconList의 startIndex부터 endIndex까지의 아이콘 이미지를 가져옴
                                  .sublist(startIndex, endIndex)
                                  .map(
                                    (icon) => Draggable<Map<String, dynamic>>(
                                      // Draggable 위젯에서 가져올 아이콘 지정
                                      data: icon,

                                      // 드래그 동안 화면에 나타날 아이콘 지정
                                      feedback: Image.asset(
                                        icon['url'],
                                        height: 53,
                                        width: 53,
                                      ),

                                      // 캐릭터 박스에 있는 아이콘 지정
                                      child: Image.asset(
                                        icon['url'],
                                        height: 53,
                                        width: 53,
                                      ),

                                      // 드래그가 완료될 때의 콜백 함수
                                      // 오버레이 위젯에 추가될 위치를 계산하고, 그 위치에 이미지 위젯을 추가
                                      onDragEnd: (details) {
                                        setState(() {
                                          RenderBox overlay = Overlay.of(
                                                  context) // 다른 위젯 위에 겹쳐질 위젯 구현
                                              .context
                                              .findRenderObject() as RenderBox;
                                          final relative =
                                              overlay.globalToLocal(details
                                                  .offset); // 드래그한 위치를 상대적인 좌표로 변환
                                          overlayWidgets.add(
                                            Positioned(
                                              // 드롭할 위치 지정
                                              left: relative.dx - 55,
                                              top: relative.dy - 230,
                                              child: Image.asset(
                                                icon['url'],
                                                height: 53,
                                                width: 53,
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          ...overlayWidgets,
                        ],
                      ),
                    ],
                  ),
                )
              : null,
    );
  }

  CarouselSlider makeList() {
    return CarouselSlider.builder(
      carouselController: controller,
      itemCount: templateList.length,
      itemBuilder: (context, index, pageViewIndex) {
        return DragTarget<String>(
          onWillAccept: (data) => true,
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
        onPageChanged: (index, reason) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
    );
  }
}
