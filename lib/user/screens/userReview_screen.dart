import 'package:flutter/material.dart';
import 'package:frontend/all/widgets/userReview_widget.dart';
import 'package:frontend/all/providers/review_provider.dart';
import 'package:frontend/user/screens/cart_screen.dart';
import 'package:frontend/user/screens/userHome_screen.dart';
import 'package:frontend/all/services/review_service.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class UserReviewPage extends StatefulWidget {
  final int storeId;
  const UserReviewPage({required this.storeId, super.key});
  @override
  State<UserReviewPage> createState() => _UserReviewPageState();
}

class _UserReviewPageState extends State<UserReviewPage> {
  double rate = 0.0; // 선택된 날짜에 해당하는 리뷰들의 평균 별점
  bool isReplied = false; // 답글 유무
  bool isExpanded = false;
  List<Map<String, dynamic>> storeReviewList = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<ReviewProvider>(context, listen: false)
          .getStoreReview(widget.storeId);

      setState(() {
        storeReviewList =
            Provider.of<ReviewProvider>(context, listen: false).storeReviewList;
      });
    });
  }

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
                        builder: (context) => const CartItemPage(),
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
                  '리뷰(${storeReviewList.length}건)',
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

            // 리뷰
            FutureBuilder(
                future: ReviewService().getStoreReview(widget.storeId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('등록된 장바구니가 없습니다.');
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length, // 리뷰 수 표시
                        physics: const ScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          final userReview = snapshot.data![index];
                          // FutureBuilder : 이미지가 로드될 때까지 기다려 해당 이미지가 준비되면 가져오는 방식
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
                                if (userReview['replies']?.isNotEmpty ?? false)
                                  // 답글이 생성되었을 때
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(
                                        right: 20.0, bottom: 10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5.0),
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
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                            ),
                                          ),
                                          subtitle: Text(
                                            '2024.01.19',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                })
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
