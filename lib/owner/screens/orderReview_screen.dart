import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:frontend/user/services/reply_service.dart';
import 'package:frontend/user/services/review_service.dart';

class OrderReviewPage extends StatefulWidget {
  final int storeId;
  final int orderId;
  const OrderReviewPage(
      {required this.storeId, required this.orderId, super.key});

  @override
  State<OrderReviewPage> createState() => _OrderReviewPageState();
}

class _OrderReviewPageState extends State<OrderReviewPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController replyController = TextEditingController();

  double rate = 0.0; // 선택된 날짜에 해당하는 리뷰들의 평균 별점
  bool isVisible = true;
  bool registerColor = false;

  late int reviewNum;
  bool isReplied = false; // 답글 유무
  String reply = ''; // 등록한 답글
  String profileLink =
      'https://cdata2.tsherpa.co.kr/tsherpa/ssam_channel/resource/channel/images/content_img/img_profile_01.png';

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

  Map<String, dynamic> reviewer = {
    // 실제 위젯을 렌더링할 때 이미지가 준비되었는지 확인한 후에 위젯을 생성을 위해
    // 이미지를 미리 가져와서 사용하기보다는 이미지의 경로를 저장
    "profileImgPath": 'assets/images/profile1.png',
    "name": "민택기",
    "block": false, // 차단 활성화 값 변경 위해 추가
    "hide": false // 숨김 활성화 값 변경 위해 추가
  };

  // 답글 페이지로 보낼 새로운 주문 아이디 생성
  Future<int> getOrderId() async {
    Map<String, dynamic> orders =
        await ReviewService().getOrderReview(widget.orderId);
    int? orderId;

    orderId = orders['orderId'];

    // orderId가 null일 경우 예외 처리
    if (orderId == null) {
      throw Exception("No orders found");
    }

    return orderId;
  }

  Future<Map<String, dynamic>> futureOrderReview() async {
    try {
      return ReviewService().getOrderReview(await getOrderId());
    } catch (e) {
      print('오류 발생: $e');
      return {};
    }
  }

  // 리뷰 아이디 가져오는 함수
  Future<int> getReviewId() async {
    Map<String, dynamic> reviewMap =
        await ReviewService().getOrderReview(widget.orderId);
    int? reviewId;

    reviewId = reviewMap['orderId'];

    if (reviewId == null) {
      throw Exception("No review found");
    }

    return reviewId;
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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     // Homepage에서 가져온 selectedStord를 Filteringpage에서도 사용
                //     builder: (context) => FilteringPage(
                //       // selectedStore: widget.selectedStore,
                //       reviewList: reviewList,
                //     ),
                //   ),
                // );
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
              child: FutureBuilder(
                future: futureOrderReview(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.hasError}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('작성된 리뷰가 없습니다'),
                    );
                  } else {
                    final orderReview = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Image.network(profileLink),
                          title: Text(reviewer['name']),
                          subtitle: const Text('2024.06.11'),
                        ),
                        const SizedBox(height: 5),

                        // 리뷰 평점
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: orderReview['rating'],
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemSize: 20,
                            ),
                            const SizedBox(width: 10),
                            Text('${orderReview['rating']}'),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // 리뷰
                        Container(
                          width: double.infinity,
                          height: 100,
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Colors.black,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(orderReview['comment']),
                        ),
                        const SizedBox(height: 50),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Form(
                            key: formKey,
                            child: TextFormField(
                              // 사용자가 입력하거나 포커스를 이동할 때 즉시 유효성 검사가 수행되고 오류 메시지가 표시
                              // 입력 시 에러메시지 사라짐
                              controller: replyController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              maxLength: 500,
                              keyboardType: TextInputType.text,
                              maxLines: 5,
                              onSaved: (val) {
                                setState(() {
                                  replyController.text =
                                      val ?? ''; // val이 null일 경우 빈 문자열로 초기화
                                });
                              },
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return '1자 이상 입력해주세요';
                                }
                                return null;
                              },

                              // onChanged: (val) {
                              //   setState(() {
                              //     // 텍스트필드에 입력했을 때 register 값 true로 변환
                              //     // 입력값이 비어있는지 확인하여 registerColor 값을 조정(비어있으면 false, 비어있지 않으면 true)
                              //     registerColor = val.isNotEmpty;
                              //   });
                              // },

                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: const Color(0xFF808080)
                                        .withOpacity(0.7),
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF374AA3),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // 답글 달기 버튼
                        isVisible
                            ? Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    int reviewId = await getReviewId();
                                    String AIReply = await ReplyService()
                                        .writeAIReply(reviewId);
                                    setState(() {
                                      replyController.text = AIReply;
                                      isVisible = false;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                          const Color((0xFF374AA3)),
                                      fixedSize: const Size(380, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      )),
                                  child: const Text(
                                    'AI로 답글 달기',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      // 답글 등록 버튼
      bottomNavigationBar: ElevatedButton(
        onPressed: () async {
          // formKey.currentState!.validate()와 formKey.currentState!.save()를
          // 올바른 순서로 호출하여 reply 값이 저장된 후에 서버로 요청
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();

            try {
              await ReplyService()
                  .resisterReply(await getReviewId(), replyController.text);
              Navigator.pop(context);
              print(replyController.text);
            } catch (e) {
              print('예외 발생: ${e.toString()}');
            }
          }

          print(replyController.text);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF274AA3),
          minimumSize: const Size(double.infinity, 80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        child: const Text(
          '답글 등록',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
