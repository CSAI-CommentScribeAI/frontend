import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:frontend/owner/services/letter_service.dart';

class LetterPage extends StatefulWidget {
  final String accessToken;
  const LetterPage({required this.accessToken, super.key});

  @override
  State<LetterPage> createState() => _LetterPageState();
}

class _LetterPageState extends State<LetterPage> {
  bool characterOpened = false;
  bool fontOpened = false;
  bool isCompleted = true; // 수정 완료 활성화 여부
  CarouselController controller = CarouselController();
  int currentPageIndex = 0;

  String selectedFont = 'Roboto';
  TextEditingController letterController = TextEditingController();

  String fullLetterContent = '';
  List<Widget> overlayWidgets = [];
  int startIndex = 0;
  int endIndex = 6;

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

  List<String> fontList = [
    'PyeongChangPeace',
    'KyoboHandwriting2023wsa',
    'EF_jejudoldam',
    'YClover',
    'DungGeunMo',
    'Adultkid',
  ];

  String letterContent = '';
  // 서버에서 불러온 편지들을 저장할 리스트
  String letters = '';

  @override
  void initState() {
    super.initState(); // 부모 클래스의 initState 메서드를 호출하여 초기화 수행
    fetchLetters(); // 위젯이 처음 생성될 때 서버에서 편지들을 불러오는 메서드 호출
  }

// 서버에서 편지를 불러오는 메서드
  Future<String> fetchLetters() async {
    // LetterService 클래스의 getLetter 메서드를 호출하여 편지들을 불러오고, 그 결과를 기다림
    String fetchedLetters = await LetterService().getLetter();

    // 불러온 편지들로 상태를 업데이트하여, 위젯 트리를 다시 빌드
    setState(() {
      letters = fetchedLetters; // 불러온 편지들을 letters 리스트에 할당
    });
    return letters;
  }

  @override
  void initState() {
    super.initState();
    fetchLetterContent(); // fetchLetterContent() 메서드를 호출하여 편지 내용을 가져옵니다.
  }

  void fetchLetterContent() async {
    String content = await LetterService().getLetter(widget.accessToken, 3);
    setState(() {
      fullLetterContent = content;
    });
    startTyping();
  }

  void startTyping() async {
    // 비동기 메서드로, async 키워드를 사용
    for (int i = 0; i < fullLetterContent.length; i++) {
      // fullLetterContent의 길이만큼 반복, 루프의 각 반복마다 한 글자씩 letterContent에 추가
      await Future.delayed(const Duration(milliseconds: 100), () {
        // 100밀리초씩 지연
        // Future.delayed는 지정된 시간 동안 대기하는 Future를 반환
        // 텍스트가 한 글자씩 천천히 추가되는 효과
        setState(() {
          letterContent += fullLetterContent[i];
          // letterContent에 fullLetterContent의 한 글자씩 추가
          letterController.text = letterContent;
          // letterController.text에 업데이트된 letterContent를 설정 -> 텍스트 필드의 내용을 업데이트
        });
      });
    }
  }

  void loadNextIcons() {
    setState(() {
      // index 7번 뒤로 이동
      startIndex += 6;
      endIndex += 6;
      if (endIndex > iconList.length) {
        // endIndex가 iconList의 길이를 초과하면
        endIndex = iconList.length; // endIndex를 iconList의 길이로 설정하여 초과하지 않도록 보정
        startIndex = endIndex - 6; // startIndex도 맞춰서 수정
      }
    });
  }

  // 이전 버튼 콜백 함수
  void loadPreviousIcons() {
    setState(() {
      // 7개를 보여주기 때문에 index 7번 앞으로 이동
      startIndex -= 6;
      endIndex -= 6;
      if (startIndex < 0) {
        // startIndex가 음수가 되면
        startIndex = 0; // startIndex를 0으로 설정하여 음수가 되지 않도록 보정
        endIndex = startIndex + 6; // endIndex도 맞춰서 수정
      }
    });
  }

  // 캐릭터 선택 박스 콜백 함수
  BottomAppBar openCharacter() {
    return BottomAppBar(
      color: const Color(0xFFE8E8FF),
      height: 130,
      child: Builder(
        builder: (context) {
          return Column(
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
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                    context,
                                  ).context.findRenderObject() as RenderBox;
                                  final relative =
                                      overlay.globalToLocal(details.offset);
                                  overlayWidgets.add(
                                    Positioned(
                                      left: relative.dx - 55,
                                      top: relative.dy - 230,
                                      child: Image.asset(
                                        icon['url'],
                                        height: 45,
                                        width: 45,
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
          );
        },
      ),
    );
  }

  // 폰트 선택 박스 콜백 함수
  BottomAppBar openFont() {
    return BottomAppBar(
      color: const Color(0xFFE8E8FF),
      height: 130,
      child: Builder(
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '글씨체',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          fontOpened = false; // 하단바 나가기
                        });
                      },
                      child: const Text(
                        '완료',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: CupertinoPicker(
                  itemExtent: 50.0, // 각 아이템의 높이 설정
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedFont = fontList[index];
                    });
                  },
                  children: fontList.map((String font) {
                    return Center(
                      child: Text(
                        font,
                        style: TextStyle(fontFamily: font),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
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
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 캐릭터, 글씨체 버튼
                      // ElevatedButton(
                      //   onPressed: () {
                      //     setState(() {
                      //       characterOpened = !characterOpened;
                      //       fontOpened = false; // 캐릭터 버튼 눌렀을 때 글씨체 선택 창 닫기
                      //     });
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: characterOpened
                      //         ? const Color(0xFF7B88C2)
                      //         : const Color(0xFFD9D9D9),
                      //     elevation: 3.0,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //     minimumSize: const Size(100, 30),
                      //   ),
                      //   child: const Text(
                      //     '캐릭터',
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     setState(() {
                      //       fontOpened = !fontOpened;
                      //       characterOpened = false; // 글씨체 버튼 눌렀을 때 캐릭터 창 닫기
                      //     });
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: fontOpened
                      //         ? const Color(0xFF7B88C2)
                      //         : const Color(0xFFD9D9D9),
                      //     elevation: 3.0,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //     minimumSize: const Size(100, 30),
                      //   ),
                      //   child: const Text(
                      //     '글씨체',
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
            const SizedBox(height: 15),
          ],
        ),
      ),

      // 하단바
      bottomNavigationBar: isCompleted
          ? ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
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
          : characterOpened
              ? openCharacter()
              : fontOpened
                  ? openFont()
                  : null,
    );
  }

  CarouselSlider makeList() {
    return CarouselSlider.builder(
      carouselController: controller,
      itemCount: templateList.length,
      itemBuilder: (context, index, pageViewIndex) {
        return DragTarget<String>(
          onWillAcceptWithDetails: (data) => true,
          onAcceptWithDetails: (data) {},
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
                      height: 500,
                      width: 320,
                      decoration: BoxDecoration(
                        color: Colors.brown,
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 40.0),
                        child: TextFormField(
                          controller: letterController,
                          readOnly: isCompleted ? true : false,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onSaved: (value) {
                            setState(() {
                              letterContent = value.toString();
                            });
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none, // underline 제거
                          ),
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: selectedFont,
                          ),
                          maxLines: null, // 다중 라인을 지원하기 위해 null로 설정
                          expands: true, // Container의 크기에 따라 확장
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
