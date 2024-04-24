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
                menuItem('신고'),
                const PopupMenuDivider(),
                menuItem('차단'),
                const PopupMenuDivider(),
                menuItem('숨김'),
              ];
            },
            child: const Icon(Icons.more_vert_rounded),
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
PopupMenuItem<MenuItem> menuItem(String text) {
  return PopupMenuItem<MenuItem>(
    enabled: true, // 팝업메뉴 호출(ex: onTap()) 가능
    onTap: () {},
    value: MenuItem.menuItem1,
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
