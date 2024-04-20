import 'package:flutter/material.dart';
import 'package:frontend/widgets/circle_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewPage extends StatefulWidget {
  final String selectedStore;
  const ReviewPage(this.selectedStore, {super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  String selectedDate = ''; // 선택된 날짜
  double rate = 0.0; // 선택된 날짜에 해당하는 리뷰들의 평균 별점

  List<Map<String, dynamic>> dateList = [
    {
      "date": "2024. 01. 16 ~ 2024. 01. 23",
      "style": const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      "showCircle": false,
      "rate": 4.8,
    },
    {
      "date": "2024. 01. 24 ~ 2024. 01. 30",
      "style": const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      "showCircle": false,
      "rate": 4.3,
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
    },
    {
      "profileImgPath": 'assets/images/profile2.png',
      "name": "소진수",
      "open_date": "2024.01.20",
      "rate": 4.0,
      "menu": "자메이카 통다리 치킨",
      "review": "너무 맛있어요. 기름기 없이 촉촉하게여 먹기에 좋았어요. 살도 진짜 부드러워요. 감사합니다.",
      "menuImgPath": 'assets/images/jamaica.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    bool isExpanded = false;

    // 날짜 선택하는 바텀시트 호출 함수
    void chooseDate() async {
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
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(31.0),

                      // 하단모달 타이틀 & 종료
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '날짜 선택',
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

                    // 날짜 선택 리스트
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: SingleChildScrollView(
                          physics: const ScrollPhysics(),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: dateList.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider();
                            },
                            itemBuilder: (BuildContext context, int index) {
                              final date = dateList[index]; // date는 객체가 됨
                              return ListTile(
                                onTap: () {
                                  bottomState(() {
                                    setState(() {
                                      for (int i = 0;
                                          i < dateList.length;
                                          i++) {
                                        if (i == index) {
                                          dateList[i]["showCircle"] =
                                              !dateList[i]["showCircle"];
                                          if (dateList[i]["showCircle"] ==
                                              true) {
                                            selectedDate = date["date"];
                                            rate = date["rate"];
                                          } else {
                                            selectedDate = '';
                                          }
                                        } else {
                                          dateList[i]["showCircle"] =
                                              false; // 다시 눌렀을 때 false가 가능하지게
                                        }
                                      }
                                    });
                                  });
                                },
                                title: Text(
                                  date["date"],
                                  style: date["style"],
                                ),
                                trailing: date["showCircle"]
                                    ? const Circle(Color(0xFF7B88C2), 10.0)
                                    : null,
                              );
                            },
                          ),
                        ),
                      ),
                    )
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
        title: Text(
          widget.selectedStore,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 23.0),
            child: Icon(
              Icons.tune,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: const Color(0xFF374AA3),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 27.0),
        child: Column(
          children: [
            // 1주 날짜
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  selectedDate.isNotEmpty ? selectedDate : '해당 날짜',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                      print(isExpanded);

                      // true일 경우에만 하단 모달시트 보여짐
                      if (isExpanded == true) {
                        chooseDate();
                      }
                    });
                  },
                  // 확장 유무에 따라 아이콘 변경
                  child: isExpanded
                      ? const Icon(Icons.expand_less)
                      : const Icon(Icons.expand_more),
                ),
              ],
            ),
            const SizedBox(height: 35),

            // 평점과 별점
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  rate.toString(),
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),

                // 날짜에 해당하는 평점 rate를 가져와 rating에 집어넣어 색상 양 설정
                RatingBarIndicator(
                  rating: rate,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                )
              ],
            ),
            const SizedBox(height: 35),

            // 리뷰 수와 미답글 리뷰 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '리뷰(${reviewList.length}건)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: true,
                      activeColor: const Color(0xFF374AA3).withOpacity(0.66),
                      onChanged: (value) {},
                    ),
                    const Text(
                      '미답글 리뷰만',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),

            // 경계선
            Container(
              width: double.infinity,
              height: 1,
              decoration: BoxDecoration(
                color: const Color(0xFF808080).withOpacity(0.7),
              ),
            ),
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
                                    ListTile(
                                      // 프로필(ClipRect 함수를 사용해 둥근 정사각형으로 구현)
                                      leading: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.asset(
                                          review["profileImgPath"],
                                        ),
                                      ),

                                      // 이름
                                      title: Text(
                                        review["name"],
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),

                                      // 리뷰 등록일과 별점
                                      subtitle: Row(
                                        children: [
                                          Text(review["open_date"]),
                                          const SizedBox(width: 8.0),
                                          RatingBarIndicator(
                                            rating: review["rate"],
                                            itemSize: 20.0,
                                            itemBuilder: (context, index) {
                                              return const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              );
                                            },
                                          ),
                                        ],
                                      ),

                                      // 더보기란(위치를 title과 같은 행으로 배치하기 위해 isThreeLine을 true로 설정)
                                      trailing: const Icon(Icons.more_vert),
                                      isThreeLine: true,
                                    ),
                                    const SizedBox(height: 5),

                                    // 리뷰 글
                                    ListTile(
                                      // 주문 메뉴 이름
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: Text(
                                          review["menu"],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF000000)
                                                .withOpacity(0.6),
                                          ),
                                        ),
                                      ),

                                      // 리뷰 댓글
                                      subtitle: Text(
                                        review["review"],
                                        style: TextStyle(
                                          color: const Color(0xFF000000)
                                              .withOpacity(0.6),
                                        ),
                                      ),

                                      // 주문 메뉴 사진
                                      trailing: Container(
                                        width: 64,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.25),
                                              blurRadius: 4,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Image.asset(
                                            review["menuImgPath"],
                                            width: 64,
                                            height: 70,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    // 답글 달기 버튼
                                    ElevatedButton(
                                      onPressed: () {},
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
