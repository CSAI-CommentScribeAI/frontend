import 'package:cart_stepper/cart_stepper.dart';
import 'package:flutter/material.dart';
import 'package:frontend/user/services/cart_service.dart';
import 'package:intl/intl.dart';

class CartItemPage extends StatefulWidget {
  const CartItemPage({super.key});

  @override
  State<CartItemPage> createState() => _CartItemPageState();
}

class _CartItemPageState extends State<CartItemPage> {
  int counterLimit = 1;
  var f = NumberFormat('###,###,###,###');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: const BackButton(
          color: Colors.white,
        ),
        title: const Text(
          '장바구니',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF374AA3),
        actions: const [
          // 홈 화면으로 이동
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.home,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 24.0),
        child: FutureBuilder(
          future: CartService().getCart(),
          builder: (context, snapshot) {
            // 데이터가 로드되는 동안 로딩 스피너 표시
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );

              // 데이터 로드 중 에러 발생 시 오류 메세지 표시
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );

              // 데이터가 없거나 빈 리스트일 경우 '등록된 가게가 없습니다' 메시지 표시
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('등록된 장바구니가 없습니다.'),
              );

              // 데이터가 성공적으로 로드될 경우 가게 목록 표시
            } else {
              return ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  final carts = snapshot.data![index];
                  return Stack(
                    // Stack 위젯을 사용해 위에 덮어있는 위젯을 중앙하단으로 조정
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      SizedBox(
                        height: 230, // 275,
                        child: Card(
                          color: Colors.white,
                          shadowColor: const Color(0xFF374AA3),
                          elevation: 3.0, // 그림자 설정
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  // 주문 가게 이름
                                  children: [
                                    // 추후에 구현 예정
                                    // Text(
                                    //   carts.menuName,
                                    //   style: const TextStyle(
                                    //     fontSize: 16,
                                    //     color: Color(0xFF808080),
                                    //   ),
                                    // ),

                                    // 삭제 버튼
                                    // IconButton(
                                    //   onPressed: () {},
                                    //   icon: const Icon(
                                    //     Icons.delete,
                                    //     color: Color(0xFF7E7EB2),
                                    //   ),
                                    // ),
                                  ],
                                ),

                                // 주문 메뉴 이름
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      carts.menuName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Color(0xFF7E7EB2),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // 주문 가격과 수량
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.network(
                                        carts.imageUrl,
                                        width: 120,
                                        alignment: Alignment.topLeft,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text('${carts.price}원'),
                                        const SizedBox(width: 10),

                                        // 수량 증가/감소 버튼
                                        CartStepperInt(
                                          value: counterLimit,
                                          style: const CartStepperStyle(
                                            activeBackgroundColor:
                                                Color(0xFF7E7EB2),
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
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => UserMenuPage(category: category),
                            //   ),
                            // );
                          },
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
                },
              );
            }
          },
        ),
      ),
    );
  }
}
