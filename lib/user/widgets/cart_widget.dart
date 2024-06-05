import 'package:flutter/material.dart';
import 'package:cart_stepper/cart_stepper.dart';
import 'package:frontend/owner/models/menu_model.dart';
import 'package:intl/intl.dart';

class CartWidget extends StatefulWidget {
  final AddMenuModel userMenu;
  const CartWidget(this.userMenu, {super.key});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  int counterLimit = 1;
  var f = NumberFormat('###,###,###,###'); // 숫자 세자리마다 콤마 넣는 코드

  @override
  Widget build(BuildContext context) {
    return Stack(
      // Stack 위젯을 사용해 위에 덮어있는 위젯을 중앙하단으로 조정
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        SizedBox(
          height: 275,
          child: Card(
            color: Colors.white,
            shadowColor: const Color(0xFF374AA3),
            elevation: 3.0, // 그림자 설정
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // 주문 가게 이름
                    children: [
                      const Text(
                        '가게 이름',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF808080),
                        ),
                      ),

                      // 삭제 버튼
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.delete,
                          color: Color(0xFF7E7EB2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 주문 메뉴 이름
                  Text(
                    widget.userMenu.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // 주문 내용
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            '⋅ 가격: ${f.format(widget.userMenu.price)}원\n⋅ 주문날짜: 2024.04.25 11:43',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF808080),
                            ),
                          ),
                          const SizedBox(height: 47),
                          Row(
                            children: [
                              Text('${f.format(widget.userMenu.price)}원'),
                              const SizedBox(width: 10),

                              // 수량 증가/감소 버튼
                              CartStepperInt(
                                value: counterLimit,
                                style: const CartStepperStyle(
                                  activeBackgroundColor: Color(0xFF7E7EB2),
                                  radius: Radius.circular(5.0),
                                ),
                                size: 25,
                                didChangeCount: (count) {
                                  // 수량이 0으로 감소하지 못하게하고 버튼도 사라지지 않게 구현
                                  if (count < 1) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    return;
                                  }
                                  setState(() {
                                    counterLimit = count;
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                      // 주문 메뉴 사진
                      Image.network(
                        widget.userMenu.imageUrl,
                        width: 120,
                        height: 120,
                        alignment: Alignment.topRight,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // 더 담기 버튼
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5.0,
            vertical: 1.0,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF3F3FF),
              shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.zero,
                  bottomLeft: Radius.circular(5.0),
                  bottomRight: Radius.circular(5.0),
                ),
              ),
              // elevation: 4.0,
            ),
            onPressed: () {},
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                SizedBox(width: 5),
                Text(
                  '더 담으러 가기',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
