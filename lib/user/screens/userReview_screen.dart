import 'package:flutter/material.dart';
import 'package:frontend/all/widgets/userReview_widget.dart';
import 'package:frontend/owner/models/menu_model.dart';
import 'package:frontend/owner/models/store_model.dart';
import 'package:frontend/user/screens/cart_screen.dart';
import 'package:frontend/user/screens/userHome_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class UserReviewPage extends StatefulWidget {
  final StoreModel? store;
  final AddMenuModel? userMenu;
  const UserReviewPage(this.store, this.userMenu, {super.key});
  @override
  State<UserReviewPage> createState() => _UserReviewPageState();
}

class _UserReviewPageState extends State<UserReviewPage> {
  double rate = 0.0; // 선택된 날짜에 해당하는 리뷰들의 평균 별점
  bool isReplied = false; // 답글 유무
  bool isExpanded = false;
  List<Map<String, dynamic>> userReviewList = [
    {
      // 실제 위젯을 렌더링할 때 이미지가 준비되었는지 확인한 후에 위젯을 생성을 위해
      // 이미지를 미리 가져와서 사용하기보다는 이미지의 경로를 저장
      "profileImgPath": 'assets/images/profile1.png',
      "name": "민택기",
      "open_date": "2024.01.18",
      "rate": 4.5,
      "menu": "필리치즈바비큐스테이크피자",
      "review":
          "퇴근후 피자맥주가 땡겨 찾은 이곳 피자에 미치다!하프앤하프로 필리치즈바비큐스테이크피자와 맥앤치즈베이컨피자를 주문했는데요 너무맛있어서 흡입해버렸어요🥹다음에 또오고싶을정도로 추천이요!잘먹었습니다😃",
      "menuImgPath": 'assets/images/testReviewImg1.png',
      "reply": "리뷰를 남겨주셔서 감사합니다. 또 이용해주세요^^",
      "block": false, // 차단 활성화 값 변경 위해 추가
      "hide": false // 숨김 활성화 값 변경 위해 추가
    },
    {
      "profileImgPath": 'assets/images/profile2.png',
      "name": "소진수",
      "open_date": "2024.01.20",
      "rate": 4.0,
      "menu": "시칠리안 갈릭쉬림프",
      "review": "아란치니가 생각보다 히든 메뉴에요:) 술집같은 분위기인데 안주도 꽤나 맛있었어요~",
      "menuImgPath": 'assets/images/testReviewImg2.png',
      "reply": "다음에도 더 맛있는 자메이카 통다리 만들어보겠습니다!!!",
      "block": false,
      "hide": false
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserHomePage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.home,
                  size: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CartItemPage(widget.store!, widget.userMenu!),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularPercentIndicator(
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
                  circularStrokeCap: CircularStrokeCap.butt, // 원의 모양 설정
                  progressColor: const Color(0xFF7E7EB2),
                ),
                const SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // 크기가 화면 높이까지 설정되어 있어 최소롤 설정
                  children: [
                    scope('5점', 1, '23건'),
                    scope('4점', 0.8, '45건'),
                    scope('3점', 0.6, '33건'),
                    scope('2점', 0.4, '11건'),
                    scope('1점', 0.2, '3건'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 35),
            // 리뷰 수와 미답글 리뷰 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '리뷰(${userReviewList.length}건)',
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
                      '답글 리뷰만',
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
            Expanded(
              child: ListView.builder(
                itemCount: userReviewList.length, // 리뷰 수 표시
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final userReview = userReviewList[index];
                  // FutureBuilder : 이미지가 로드될 때까지 기다려 해당 이미지가 준비되면 가져오는 방식
                  return FutureBuilder(
                    future: precacheImage(
                        AssetImage(userReview["profileImgPath"]), context),
                    builder: (context, profileSnapshot) {
                      if (profileSnapshot.connectionState ==
                          ConnectionState.done) {
                        return FutureBuilder(
                          future: precacheImage(
                              AssetImage(userReview["menuImgPath"]), context),
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
                                      review: userReview,
                                      visibleTrail: false,
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
                                            Text(userReview["reply"]),
                                            const SizedBox(height: 15),
                                          ],
                                        ),
                                      )
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

  Widget scope(String point, double percent, String cases) {
    return Row(
      children: [
        Text(
          point,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        // 날짜에 해당하는 평점 rate를 가져와 rating에 집어넣어 색상 양 설정
        LinearPercentIndicator(
          width: 150.0, // 바 길이
          lineHeight: 8.0, // 바 넓이
          percent: percent, // 퍼센트
          progressColor: const Color(0xffF9BC28),
        ),
        Text(
          cases,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 8.0,
          ),
        ),
      ],
    );
  }
}
