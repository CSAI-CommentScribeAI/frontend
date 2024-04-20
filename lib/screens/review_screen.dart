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

  @override
  Widget build(BuildContext context) {
    bool isExpanded = false;

    // 날짜 선택하는 바텀시트 호출 함수
    void chooseDate() {
      showModalBottomSheet(
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
          ],
        ),
      ),
    );
  }
}
