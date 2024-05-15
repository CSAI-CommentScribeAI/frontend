import 'package:flutter/material.dart';
import 'package:frontend/owner/widgets/userReview_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';

class FeedbackPage extends StatefulWidget {
  final dynamic selectedStore;
  const FeedbackPage(this.selectedStore, {super.key});

  // ReviewPage에서 index로 reviewList의 하나의 객체마다 접근을 하고
  // Listview.builder에서 사용해야하기 때문에 객체 review를 받아야 함
  // 리스트 받으면 아래의 코드에서 리스트안의 객체를 받아야하는 코드를 구현해야 함
  @override
  State<FeedbackPage> createState() => _FeedbackeState();
}

class _FeedbackeState extends State<FeedbackPage> {
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
    {
      "profileImgPath": 'assets/images/profile2.png',
      "name": "소진수",
      "open_date": "2024.01.20",
      "rate": 4.0,
      "menu": "자메이카 통다리 치킨",
      "review": "너무 맛있어요. 기름기 없이 촉촉하게여 먹기에 좋았어요. 살도 진짜 부드러워요. 감사합니다.",
      "menuImgPath": 'assets/images/jamaica.png',
      "reply": "다음에도 더 맛있는 자메이카 통다리 만들어보겠습니다!!!",
      "block": false,
      "hide": false
    },
  ];

  List<Map<String, String>> feedbackList = [
    {
      // 실제 위젯을 렌더링할 때 이미지가 준비되었는지 확인한 후에 위젯을 생성을 위해
      // 이미지를 미리 가져와서 사용하기보다는 이미지의 경로를 저장
      "good":
          "추운날 늦은밤까지 맛있게 요리해 주셔서 감사합니다 너무 맛있어요. 기름기 없이 촉촉하게여 먹기에 좋았어요. 감사해요.",
      "bad":
          "치킨을 전달할 때 치킨 상자가 차가웠다는 점과 딱딱하게 굳어있다는 점은 배달 과정에서 보온을 충분히 하지 못했음을 의미합니다. 보온용 패키지를 사용하거나 배달 과정을 계선하여 피자가 고객에게 전달될 때까지 따듯함을 유지할 필요가 있습니다."
    },
    {
      // 실제 위젯을 렌더링할 때 이미지가 준비되었는지 확인한 후에 위젯을 생성을 위해
      // 이미지를 미리 가져와서 사용하기보다는 이미지의 경로를 저장
      "good":
          "추운날 늦은밤까지 맛있게 요리해 주셔서 감사합니다 너무 맛있어요. 기름기 없이 촉촉하게여 먹기에 좋았어요. 감사해요.",
      "bad":
          "치킨을 전달할 때 치킨 상자가 차가웠다는 점과 딱딱하게 굳어있다는 점은 배달 과정에서 보온을 충분히 하지 못했음을 의미합니다. 보온용 패키지를 사용하거나 배달 과정을 계선하여 피자가 고객에게 전달될 때까지 따듯함을 유지할 필요가 있습니다."
    },
  ];

  String selectedDate = ''; // 선택된 날짜
  double rate = 0.0; // 선택된 날짜에 해당하는 리뷰들의 평균 별점
  int currentWeek = 1; // 현재 주차
  bool isExpanded = false;
  int expandedReviewIndex = -1; // 확장된 리뷰의 인덱스를 저장하는 변수입니다. 초기값은 -1로 설정합니다.

  void goToPreviousWeek() {
    setState(() {
      if (currentWeek > 1) {
        currentWeek--;
      }
    });
  }

  void goToNextWeek() {
    setState(() {
      if (currentWeek < 4) {
        currentWeek++;
      }
    });
  }

  Widget storeItem({required String imgPath, required String title}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          imgPath,
          width: 30,
          height: 30,
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F3FF),
        appBar: AppBar(
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 23.0),
              child: Icon(
                Icons.account_circle,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
          title: const Text(
            '주간 피드백',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF374AA3),
          toolbarHeight: 70,
          leading: const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: BackButton(
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              color: const Color(0xFFD8D8FF),
              height: MediaQuery.of(context).size.height / 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: goToPreviousWeek,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          '12월 $currentWeek주차',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: goToNextWeek,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularPercentIndicator(
                            radius: 60.0, // 반지름
                            animation: true, // 애니메이션 활성화
                            animationDuration: 1200, // 애니메이션 지속 시간 설정
                            lineWidth: 12.0, // 두께
                            percent: 0.9, // 퍼센트 %
                            center: const Text(
                              "4.5",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 20.0,
                              ),
                            ),
                            circularStrokeCap:
                                CircularStrokeCap.butt, // 원의 모양 설정
                            progressColor: const Color(0xFF7E7EB2)),
                        // 진행 바
                      ),
                      const SizedBox(width: 15),
                      Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                '5점',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              // 날짜에 해당하는 평점 rate를 가져와 rating에 집어넣어 색상 양 설정
                              LinearPercentIndicator(
                                width: 150.0, // 바 길이
                                lineHeight: 8.0, // 바 넓이
                                percent: 1, // 퍼센트
                                progressColor: const Color(0xffF9BC28),
                              ),
                              const Text(
                                "124건",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 8.0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                '4점',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              // 날짜에 해당하는 평점 rate를 가져와 rating에 집어넣어 색상 양 설정
                              LinearPercentIndicator(
                                width: 150.0, // 바 길이
                                lineHeight: 8.0, // 바 넓이
                                percent: 0.8, // 퍼센트
                                progressColor: const Color(0xffF9BC28),
                              ),
                              const Text(
                                "96건",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 8.0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                '3점',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              // 날짜에 해당하는 평점 rate를 가져와 rating에 집어넣어 색상 양 설정
                              LinearPercentIndicator(
                                width: 150.0, // 바 길이
                                lineHeight: 8.0, // 바 넓이
                                percent: 0.6, // 퍼센트
                                progressColor: const Color(0xffF9BC28),
                              ),
                              const Text(
                                "68건",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 8.0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                '2점',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              // 날짜에 해당하는 평점 rate를 가져와 rating에 집어넣어 색상 양 설정
                              LinearPercentIndicator(
                                width: 150.0, // 바 길이
                                lineHeight: 8.0, // 바 넓이
                                percent: 0.4, // 퍼센트
                                progressColor: const Color(0xffF9BC28),
                              ),
                              const Text(
                                "21건",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 8.0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                '1점',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              // 날짜에 해당하는 평점 rate를 가져와 rating에 집어넣어 색상 양 설정
                              LinearPercentIndicator(
                                width: 150.0, // 바 길이
                                lineHeight: 8.0, // 바 넓이
                                percent: 0.2, // 퍼센트
                                progressColor: const Color(0xffF9BC28),
                              ),
                              const Text(
                                "13건",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 8.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              color: const Color(0xFFF3F3FF),
              height: MediaQuery.of(context).size.height * 2 / 4,

              // 고객 리뷰
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Expanded(
                    child: ListView.builder(
                  itemCount: reviewList.length * 2, // 구분선을 위한 아이템 개수 추가
                  itemBuilder: (context, index) {
                    if (index.isOdd) {
                      // 홀수 인덱스일 경우 구분선을 추가
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: SizedBox(
                          height: 1,
                          width: double.infinity, // 너비를 전체로 설정
                          child: Container(
                            color: const Color(0xFF808080).withOpacity(0.7),
                          ),
                        ),
                      );
                    } else {
                      // 짝수 인덱스일 경우 리뷰 리스트를 추가합
                      int reviewIndex = index ~/ 2; // 리뷰 인덱스 계산
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                // 클릭된 리뷰의 확장 상태를 토글
                                expandedReviewIndex =
                                    expandedReviewIndex == reviewIndex
                                        ? -1 // 이미 확장된 리뷰를 다시 클릭하면 축소
                                        : reviewIndex; // 그렇지 않으면 리뷰를 확장
                              });
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: UserReview(
                                    review: reviewList[reviewIndex],
                                    visibleTrail: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (expandedReviewIndex ==
                              reviewIndex) // 해당 리뷰가 확장된 상태인 경우에만 피드백을 표시
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 25),
                              child: SizedBox(
                                height: 160,
                                width: 350,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(), // 스크롤 방지
                                  itemCount: 2, // 좋은 점과 나쁜 점 두 가지를 표시해야 합니다.
                                  itemBuilder: (context, feedbackIndex) {
                                    return ListTile(
                                      // 프로필 이미지와 피드백 텍스트를 표시
                                      leading: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.asset(
                                          feedbackIndex ==
                                                  0 // 좋은 피드백을 나타내는 항목이면 해당 조건이 참
                                              ? 'assets/images/good.png'
                                              : 'assets/images/bad.png',
                                        ),
                                      ),
                                      // 피드백 텍스트
                                      title: Text(
                                        feedbackIndex ==
                                                0 // 좋은 피드백을 나타내는 항목이면 해당 조건이 참
                                            ? feedbackList[reviewIndex]
                                                    ['good'] ??
                                                ''
                                            : feedbackList[reviewIndex]
                                                    ['bad'] ??
                                                '',
                                        style: const TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                        ],
                      );
                    }
                  },
                )),
              ),
            ),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 104,
          child: BottomAppBar(
            color: const Color(0xFF374AA3),
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(), // Gridview의 스크롤 방지
              crossAxisCount: 3, // 1개의 행에 보여줄 item의 개수
              crossAxisSpacing: 10.0, // 같은 행의 iteme들 사이의 간격
              children: [
                storeItem(imgPath: 'assets/images/bottom_home.png', title: '홈'),
                storeItem(
                    imgPath: 'assets/images/bottom_review.png', title: '리뷰 관리'),
                storeItem(imgPath: 'assets/images/bottom_my.png', title: 'MY'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
