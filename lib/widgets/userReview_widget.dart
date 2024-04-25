import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class UserReview extends StatefulWidget {
  // ReviewPage에서 index로 reviewList의 하나의 객체마다 접근을 하고
  // Listview.builder에서 사용해야하기 때문에 객체 review를 받아야 함
  // 리스트 받으면 아래의 코드에서 리스트안의 객체를 받아야하는 코드를 구현해야 함
  final Map<String, dynamic> review;
  const UserReview({required this.review, super.key});

  @override
  State<UserReview> createState() => _UserReviewState();
}

enum MenuItem { menuItem1, menuItem2, menuItem3 }

class _UserReviewState extends State<UserReview> {
  bool selected = false; // 신고 선택 여부(신고하기 버튼에 사용)

  List texts = [
    {
      "value": false,
      "title": "욕설/생명경시/혐오/차별적 표헌",
    },
    {
      "value": false,
      "title": "불쾌한 표현",
    },
    {
      "value": false,
      "title": "개인정보 노출 리뷰",
    },
    {"value": false, "title": "도배성 댓글"},
    {
      "value": false,
      "title": "매장과 관련 없는 댓글",
    },
  ];

  // 팝업메뉴 아이템 눌렀을 때 각각 수행하는 함수
  void handleMenuItem(BuildContext context, MenuItem item) {
    // 신고 팝업창
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: [
            Column(
              children: [
                StatefulBuilder(
                  builder: (context, setState) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30.0,
                        horizontal: 8.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // 종료 버튼
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.close),
                          ),

                          // 체크박스 신고 리스트
                          Column(
                            children: List.generate(
                              texts.length,
                              (index) => CheckboxListTile(
                                value: texts[index]["value"],
                                onChanged: (value) {
                                  setState(() {
                                    // 다른 체크박스를 선택할 때 먼저 모든 value 키 값에 false를 설정한 후
                                    // 그 다음에 선택된 체크박스 value 키 값을 선택한 값을 업데이트해 true로 설정
                                    for (var elements in texts) {
                                      // 모든 value값에 false로 설정
                                      elements["value"] = false;
                                    }
                                    // 선택된 체크박스의 value 값을 선택한 값(value)으로 업데이트
                                    texts[index]["value"] = value;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero, // 체크박스 주위의 여백
                                title: Text(texts[index]["title"]),
                                activeColor: const Color(0xFF374AA3),
                                checkColor: Colors.white,
                                checkboxShape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              // Column 위젯은 Widget의 리스트를 요구
                              // 따라서 toList() 메서드를 사용하여 List<CheckboxListTile>을 Widget의 리스트로 변환
                            ).toList(),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // 신고하기 버튼
                SizedBox(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF374AA3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      '신고하기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          // 프로필(ClipRect 함수를 사용해 둥근 정사각형으로 구현)
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              widget.review["profileImgPath"],
            ),
          ),

          // 이름
          title: Text(
            widget.review["name"],
            style: const TextStyle(
              fontSize: 20,
            ),
          ),

          // 리뷰 등록일과 별점
          subtitle: Row(
            children: [
              Text(widget.review["open_date"]),
              const SizedBox(width: 8.0),
              RatingBarIndicator(
                rating: widget.review["rate"],
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
          trailing: PopupMenuButton<MenuItem>(
            color: const Color(0xFF7783C2),
            itemBuilder: (BuildContext context) {
              return [
                menuItem('신고', MenuItem.menuItem1),
                const PopupMenuDivider(),
                menuItem('차단', MenuItem.menuItem2),
                const PopupMenuDivider(),
                menuItem('숨김', MenuItem.menuItem3),
              ];
            },
            child: const Icon(Icons.more_vert_rounded),
            onSelected: (value) {
              handleMenuItem(context, value);
            },
          ),

          isThreeLine: true,
        ),
        const SizedBox(height: 5),

        // 리뷰 글
        ListTile(
          // 주문 메뉴 이름
          title: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              widget.review["menu"],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF000000).withOpacity(0.6),
              ),
            ),
          ),

          // 리뷰 댓글
          subtitle: Text(
            widget.review["review"],
            style: TextStyle(
              color: const Color(0xFF000000).withOpacity(0.6),
            ),
          ),

          // 주문 메뉴 사진
          trailing: Container(
            width: 64,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                widget.review["menuImgPath"],
                width: 64,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 팝업메뉴
PopupMenuItem<MenuItem> menuItem(String text, MenuItem item) {
  return PopupMenuItem<MenuItem>(
    enabled: true, // 팝업메뉴 호출(ex: onTap()) 가능
    value: item,
    height: 30,
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
