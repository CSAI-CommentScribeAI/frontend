import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/owner/models/store_model.dart';
import 'package:frontend/owner/screens/filtering_screen.dart';
import 'package:frontend/owner/services/store_service.dart';
import 'package:frontend/owner/widgets/circle_widget.dart';
import 'package:frontend/user/services/reply_service.dart';
import 'package:frontend/user/services/review_service.dart';

class ReviewPage extends StatefulWidget {
  final String selectedStore;

  const ReviewPage(this.selectedStore, {super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  String selectedDate = ''; // 선택된 날짜
  double rate = 0.0; // 선택된 날짜에 해당하는 리뷰들의 평균 별점
  bool isExpanded = false;
  late int reviewNum;
  bool isReplied = false; // 답글 유무
  late Future<List<dynamic>> review;
  int storeId = 0;
  int reviewCount = 0; // 리뷰 개수를 저장할 변수

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

  List<Map<String, dynamic>> reviewList = [];

  @override
  void initState() {
    super.initState();
    review = _getReviews();
  }

  Future<List<dynamic>> _getReviews() async {
    // int storeId = await getStoreId();
    List<dynamic> reviewList = await ReviewService().getStoreReview(storeId);
    setState(() {
      reviewCount = reviewList.length; // 리뷰 개수를 상태 변수에 저장
    });
    return reviewList;
  }

  // Future<int> getStoreId() async {
  //   List<StoreModel> storeList = await StoreService().getStore();
  //   int? id;

  //   for (var store in storeList) {
  //     id = store.id;
  //   }

  //   // orderId가 null일 경우 예외 처리
  //   if (id == null) {
  //     throw Exception("No orders found");
  //   }

  //   return id;
  // }

  // 날짜 선택하는 바텀시트 호출 함수
  void chooseDate(BuildContext context) async {
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
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                          itemBuilder: (BuildContext context, int index) {
                            final date = dateList[index]; // date는 객체가 됨
                            return ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                bottomState(() {
                                  setState(() {
                                    for (int i = 0; i < dateList.length; i++) {
                                      if (i == index) {
                                        dateList[i]["showCircle"] =
                                            !dateList[i]["showCircle"];
                                        if (dateList[i]["showCircle"] == true) {
                                          selectedDate = date["date"];
                                          rate = date["rate"];
                                        } else {
                                          selectedDate = '';
                                          rate = 0.0;
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
                                  ReplyService().writeAIReply(1);
                                }
                                // Navigator.pop을 호출하여 바텀시트를 닫은 후
                                Navigator.pop(context);
                                // 그 후에 Navigator.push를 호출하여 새 페이지로 이동
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => const ReplyPage(
                                //         // reviewNum로 객체 review 접근
                                //         // index가 n인 reviewNum을 여기로 가져오면 n번째 reviewList 정보를 가지고 있는 고객 리뷰로 연결
                                //         // 예시 : 1번째 답글 버튼을 가져와서 reviewNum가 1이기 때문에 reviewList[1]인 객체 정보를 가져옴
                                //         // review: reviewList[reviewNum],
                                //         // reviewList: reviewList,

                                //         ),
                                //   ),
                                // );
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
        title: Text(
          widget.selectedStore,
          style: const TextStyle(
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
                      isExpanded =
                          !isExpanded; // 확장되어 있을 때는 축소하고, 축소되어 있을 때는 확장

                      // true일 경우에만 하단 모달시트 보여짐
                      if (isExpanded == true) {
                        chooseDate(context);
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
                  '리뷰($reviewCount건)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
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
              ],
            ),
            const SizedBox(height: 10),

            // 경계선
            Container(
              width: double.infinity,
              height: 1,
              decoration: BoxDecoration(
                color: const Color(0xFF808080).withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              // 자식 위젯을 사용 가능한 공간을 채우도록 확장
              child: FutureBuilder<List<dynamic>>(
                future: review, // 빌더가 대기할 비동기 연산 (future) 입니다.
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // 연결 상태가 진행 중일 때, 로딩 인디케이터 표시
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    // 에러가 발생했을 때, 에러 메시지 표시
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // 데이터가 없거나 비어있을 때, "등록된 리뷰가 없습니다" 메시지를 표시
                    return const Center(
                      child: Text('등록된 리뷰가 없습니다'),
                    );
                  } else {
                    // 데이터가 있을 때, 리뷰를 표시하기 위해 ListView 생성
                    return ListView.builder(
                      itemCount: snapshot.data!.length, // 리스트의 항목 수 설정
                      itemBuilder: (context, index) {
                        final review =
                            snapshot.data![index]; // 현재 인덱스의 리뷰 데이터를 가져옴
                        return ListTile(
                          // 각 리뷰에 대한 ListTile을 생성합니다.
                          title: Row(
                            children: [
                              Text(
                                review['nickName'], // 리뷰 작성자의 닉네임을 표시
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              RatingBarIndicator(
                                rating:
                                    review['rating'].toDouble(), // 리뷰 평점을 표시
                                itemSize: 20,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                review['rating'].toString(), // 리뷰 평점
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(), // PopupMenuButton을 오른쪽에 배치
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  // 메뉴 항목 선택 시의 동작을 정의
                                  switch (value) {
                                    case '신고':
                                      break;
                                    case '차단':
                                      break;
                                    case '숨김':
                                      break;
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return {'신고', '차단', '숨김'}
                                      .map((String choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          choice,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList();
                                },
                                icon: const Icon(Icons.more_vert),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review['comment'], // 리뷰 코멘트를 표시
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black54),
                              ),
                              const SizedBox(height: 5),
                              for (var menuItem in review['menuList'])
                                Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black54, width: 1.5),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    menuItem.toString(), // 메뉴 항목 표시
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isExpanded = !isExpanded;
                                    if (isExpanded == true) {
                                      chooseWrite(
                                          context); // '답글 달기' 버튼을 클릭했을 때의 동작을 정의합니다.
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: const Color((0xFF374AA3)),
                                  fixedSize: const Size(380, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                child: const Text(
                                  '답글 달기', // 버튼 텍스트를 정의합니다.
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )
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
