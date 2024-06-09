import 'package:flutter/material.dart';
import 'package:frontend/all/widgets/userReview_widget.dart';
import 'package:frontend/owner/screens/filtering_screen.dart';
import 'package:frontend/owner/screens/reply_screen.dart';
import 'package:frontend/user/services/review_service.dart';

class OrderReviewPage extends StatefulWidget {
  const OrderReviewPage({super.key});

  @override
  State<OrderReviewPage> createState() => _OrderReviewPageState();
}

class _OrderReviewPageState extends State<OrderReviewPage> {
  double rate = 0.0; // 선택된 날짜에 해당하는 리뷰들의 평균 별점
  bool isExpanded = false;
  late int reviewNum;
  bool isReplied = false; // 답글 유무

  // 답글 작성 유형 리스트
  List<Map<String, dynamic>> writeList = [
    {
      "title": "직접 작성",
      "style": const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      "writingImgPath": "assets/images/handWriting.png"
    },
    {
      "title": "AI 작성",
      "style": const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      "writingImgPath": "assets/images/AIWriting.png",
    }
  ];

  List<Map<String, dynamic>> reviewList = [
    {
      // 실제 위젯을 렌더링할 때 이미지가 준비되었는지 확인한 후에 위젯을 생성을 위해
      // 이미지를 미리 가져와서 사용하기보다는 이미지의 경로를 저장
      "profileImgPath": 'assets/images/profile1.png',
      "name": "민택기",
      "open_date": "2024.01.18",
      "rate": 4.5,
      "menu": "황금 올리브 치킨",
      "review":
          "추운날 늦은밤까지 맛있게 요리해 주셔서 감사합니다 너무 맛있어요. 기름기 없이 촉촉하게여 먹기에 좋았어요. 감사해요.",
      "menuImgPath": 'assets/images/chicken.png',
      "reply": "리뷰를 남겨주셔서 감사합니다. 또 이용해주세요^^",
      "block": false, // 차단 활성화 값 변경 위해 추가
      "hide": false // 숨김 활성화 값 변경 위해 추가
    },
  ];

  // 답글 작성법 선택하는 바텀시트 호출 함수
  void chooseWrite(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          // 상태 관리
          builder: (BuildContext context, StateSetter bottomState) {
            // StateSetter : 상태 변경 콜백 함수
            return SizedBox(
              height: 250,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 31.0, left: 31.0, right: 31.0),

                    // 하단모달 타이틀 & 종료
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '답글 유형',
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
                              isExpanded = true;
                            });
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),

                  // 작성법 선택 리스트
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SingleChildScrollView(
                        physics: const ScrollPhysics(),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: writeList.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                          itemBuilder: (BuildContext context, int index) {
                            final write = writeList[index];
                            return ListTile(
                              onTap: () {
                                if (index == 1) {
                                  ReviewService().writeReply(1);
                                }
                                // Navigator.pop을 호출하여 바텀시트를 닫은 후
                                Navigator.pop(context);
                                // 그 후에 Navigator.push를 호출하여 새 페이지로 이동
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReplyPage(
                                      // reviewNum로 객체 review 접근
                                      // index가 n인 reviewNum을 여기로 가져오면 n번째 reviewList 정보를 가지고 있는 고객 리뷰로 연결
                                      // 예시 : 1번째 답글 버튼을 가져와서 reviewNum가 1이기 때문에 reviewList[1]인 객체 정보를 가져옴
                                      review: reviewList[reviewNum],
                                      reviewList: reviewList,
                                    ),
                                  ),
                                );
                                bottomState(() {
                                  setState(() {});
                                });
                              },
                              title: Text(
                                write["title"],
                                style: write["style"],
                              ),
                              trailing: Image.asset(write["writingImgPath"]),
                            );
                          },
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
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3FF),
      appBar: AppBar(
        toolbarHeight: 70,
        // 기존 제공하는 뒤로가기 버튼 색상 변경
        leading: const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: BackButton(
            color: Colors.white,
          ),
        ),
        title: const Text(
          '주문 리뷰',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 23.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // Homepage에서 가져온 selectedStord를 Filteringpage에서도 사용
                    builder: (context) => FilteringPage(
                      // selectedStore: widget.selectedStore,
                      reviewList: reviewList,
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.tune,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
        backgroundColor: const Color(0xFF374AA3),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 27.0),
        child: Column(
          children: [
            // 미답글 리뷰 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Checkbox(
                  value: isReplied,
                  activeColor: const Color(0xFF374AA3).withOpacity(0.66),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                  onChanged: (value) {
                    setState(() {
                      isReplied = !isReplied;
                    });
                  },
                ),
                const SizedBox(width: 5),
                const Text(
                  '미답글 리뷰만',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: reviewList.length,
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final review = reviewList[index];
                  // FutureBuilder : 이미지가 로드될 때까지 기다려 해당 이미지가 준비되면 가져오는 방식
                  return FutureBuilder(
                    future: precacheImage(
                        AssetImage(review["profileImgPath"]), context),
                    builder: (context, profileSnapshot) {
                      if (profileSnapshot.connectionState ==
                          ConnectionState.done) {
                        return FutureBuilder(
                          future: precacheImage(
                              AssetImage(review["menuImgPath"]), context),
                          builder: (context, menuSnapshot) {
                            if (menuSnapshot.connectionState ==
                                ConnectionState.done) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 25),
                                child: Column(
                                  children: [
                                    // 고객 리뷰
                                    // reviewList[index](객체 review)를 전달
                                    UserReview(
                                      review: review,
                                      visibleTrail: true,
                                    ),
                                    const SizedBox(height: 20),

                                    // 답글 달기 버튼
                                    // 아마도 작성 유형이나 답글 등록 버튼 누를 때 isReplied 값 상태 변경할 예정
                                    if (isReplied)
                                      // 답글이 생성되었을 때
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.only(
                                            right: 20.0, bottom: 10.0),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: Column(
                                          children: [
                                            // 사장님 프로필과 등록 날짜
                                            ListTile(
                                              leading: const CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    'assets/images/sajang.png'),
                                              ),
                                              title: Text(
                                                '사장님',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                ),
                                              ),
                                              subtitle: Text(
                                                '2024.01.19',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                ),
                                              ),
                                            ),

                                            // 답글
                                            Text(review["reply"]),
                                            const SizedBox(height: 15),

                                            // 수정과 삭제 버튼
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                edTextBtn(
                                                  text: '수정',
                                                  color:
                                                      const Color(0xFF374AA3),
                                                ),
                                                const SizedBox(width: 8),
                                                edTextBtn(
                                                  text: '삭제',
                                                  color:
                                                      const Color(0xFFFF0000),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    else
                                      // 답글 생성이 되지 않았을 때
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            isExpanded = !isExpanded;

                                            if (isExpanded == true) {
                                              chooseWrite(context);
                                            }
                                          });

                                          // 답글 달기 버튼을 눌렀을 때 몇번째 답글 버튼인지를 결정하는 index를 가져와서 reviewNum에 저장
                                          reviewNum = index;
                                        },
                                        style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor:
                                                const Color((0xFF374AA3)),
                                            fixedSize: const Size(350, 40),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            )),
                                        child: const Text(
                                          '답글 달기',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            } else {
                              return const SizedBox(
                                height: 48,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          },
                        );
                      } // 가져오는 것을 대기하고 있을 때 로딩 인디케이터로 로딩 중 표시
                      else {
                        return const SizedBox(
                          height: 48,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget edTextBtn({
  required String text,
  required Color color,
}) {
  return TextButton(
    onPressed: () {},
    style: TextButton.styleFrom(
      minimumSize: Size.zero,
      padding: const EdgeInsets.all(3.0),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    child: Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 14,
        decoration: TextDecoration.underline,
        decorationColor: color,
      ),
    ),
  );
}
