import 'package:flutter/material.dart';
import 'package:frontend/all/services/order_service.dart';
import 'package:frontend/owner/screens/letter_screen.dart';
import 'package:frontend/owner/screens/orderReview_screen.dart';
import 'package:frontend/owner/services/delivery_service.dart';
import 'package:frontend/owner/services/letter_service.dart';
import 'package:frontend/owner/widgets/store_widget.dart';
import 'package:frontend/user/models/order_model.dart';
import 'package:frontend/user/services/review_service.dart';

class ReceiptPage extends StatefulWidget {
  final int storeId;
  const ReceiptPage(this.storeId, {super.key});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  int i = 0; // 각 객체마다 isCompleted에 접근하기 위해 선언
  // int orderId = 0;
  bool isExpanded = false;
  int selectedButtonIndex = -1;
  bool isOrderAccepted = false; // 주문이 수락되었는지 여부 확인

  // // 주문 상태 객체
  // // FutureBuilder의 snapshot.data와 같이 있으면 UI 적용이 안됨
  // // 주문이 2개일때는 다 편지작성이 가능하기 때문에 하나만 되게 구현해야함
  // Map<String, dynamic> orderStatus = {
  //   'isAccepted': null,
  //   'isPrinted': null,
  //   'isDelivered': null,
  //   'isCompleted': null,
  // };

  void handleButtonSelection(int index) {
    setState(() {
      selectedButtonIndex = index;
    });
  }

  // // 주문을 수락하는 메서드
  // void acceptOrder(int index, int orderId) async {
  //   setState(() {
  //     orderStatus['isAccepted'] = true;
  //   });

  //   bool isSaved = await LetterService().saveLetter(orderId);

  //   if (isSaved) {
  //     // 3초 후에 상태를 '배차 / 출력' 버튼으로 변경
  //     Future.delayed(const Duration(seconds: 3), () {
  //       setState(() {
  //         orderStatus['isPrinted'] = true; // 배차 혹은 출력 상태로 활성화
  //       });
  //     });
  //   } else {
  //     setState(() {
  //       orderStatus['isAccepted'] = false;
  //     });
  //   }
  // }

  // // 배차 혹은 출력시키는 메서드
  // void acceptDelivery(int index) async {
  //   setState(() {
  //     orderStatus['isDelivered'] = true; // 배달 중 상태로 활성화
  //   });

  //   // 주문을 완료 상태로 설정하는 메서드
  //   void completeOrder(int index) {
  //     setState(() {
  //       orderStatus['isAccepted'] = true;
  //       orderStatus['isPrinted'] = false;
  //       orderStatus['isDelivered'] = false;
  //       orderStatus['isCompleted'] = true; // 주문을 완료 상태로 설정
  //     });
  //   }

  //   Future.delayed(const Duration(seconds: 1), () {
  //     setState(() {
  //       // 배차 혹은 출력 상태는 비활성화, 완료 중 상태로 활성화
  //       orderStatus['isPrinted'] = false;
  //       orderStatus['isCompleted'] = true;
  //     });
  //   });
  // }

  // 거절 버튼 누를 시 작용하는 Bottomsheet
  void _showRejectBottomSheet(int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // bottomState는 하단 시트 내에서 상태를 업데이트하는 데 사용되는 함수 = 즉시 업데이트 가능
          builder: (BuildContext context, StateSetter bottomState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(31.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '거절 사유',
                            style: TextStyle(
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

                    // 텍스트 버튼
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 145,
                          height: 40,
                          child: TextButton(
                            onPressed: () {
                              bottomState(() {
                                handleButtonSelection(0);
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: selectedButtonIndex == 0
                                  ? const Color(0xFF7B88C2)
                                  : const Color(0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              // 박스 데코레이션 추가
                              side: BorderSide(
                                  color: Colors.white.withOpacity(0.25)),
                              // 그림자 추가
                              shadowColor: Colors.black,
                              elevation: 5,
                            ),
                            child: const Text(
                              '가게 사정',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 25),
                        Padding(
                          padding: const EdgeInsets.only(left: 31.0),
                          child: SizedBox(
                            width: 145,
                            height: 40,
                            child: TextButton(
                              onPressed: () {
                                bottomState(() {
                                  handleButtonSelection(1);
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: selectedButtonIndex == 1
                                    ? const Color(0xFF7B88C2)
                                    : const Color(
                                        0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                // 박스 데코레이션 추가
                                side: BorderSide(
                                    color: Colors.white.withOpacity(0.25)),
                                // 그림자 추가
                                shadowColor: Colors.black,
                                elevation: 5,
                              ),
                              child: const Text(
                                '조리 지연',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    // 텍스트 버튼
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 145,
                          height: 40,
                          child: TextButton(
                            onPressed: () {
                              bottomState(() {
                                handleButtonSelection(2);
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: selectedButtonIndex == 2
                                  ? const Color(0xFF7B88C2)
                                  : const Color(0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              // 박스 데코레이션 추가
                              side: BorderSide(
                                  color: Colors.white.withOpacity(0.25)),
                              // 그림자 추가
                              shadowColor: Colors.black,
                              elevation: 5,
                            ),
                            child: const Text(
                              '재료 소진',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 25),
                        Padding(
                          padding: const EdgeInsets.only(left: 31.0),
                          child: SizedBox(
                            width: 145,
                            height: 40,
                            child: TextButton(
                              onPressed: () {
                                bottomState(() {
                                  handleButtonSelection(3);
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: selectedButtonIndex == 3
                                    ? const Color(0xFF7B88C2)
                                    : const Color(
                                        0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                // 박스 데코레이션 추가
                                side: BorderSide(
                                    color: Colors.white.withOpacity(0.25)),
                                // 그림자 추가
                                shadowColor: Colors.black,
                                elevation: 5,
                              ),
                              child: const Text(
                                '배달 불가 지역',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    // 텍스트 버튼
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 145,
                          height: 40,
                          child: TextButton(
                            onPressed: () {
                              bottomState(() {
                                handleButtonSelection(4);
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: selectedButtonIndex == 4
                                  ? const Color(0xFF7B88C2)
                                  : const Color(0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              // 박스 데코레이션 추가
                              side: BorderSide(
                                  color: Colors.white.withOpacity(0.25)),
                              // 그림자 추가
                              shadowColor: Colors.black,
                              elevation: 5,
                            ),
                            child: const Text(
                              '배달원 부재',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 25),
                        Padding(
                          padding: const EdgeInsets.only(left: 31.0),
                          child: SizedBox(
                            width: 145,
                            height: 40,
                            child: TextButton(
                              onPressed: () {
                                bottomState(() {
                                  handleButtonSelection(5);
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: selectedButtonIndex == 5
                                    ? const Color(0xFF7B88C2)
                                    : const Color(
                                        0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                // 박스 데코레이션 추가
                                side: BorderSide(
                                    color: Colors.white.withOpacity(0.25)),
                                // 그림자 추가
                                shadowColor: Colors.black,
                                elevation: 5,
                              ),
                              child: const Text(
                                '메뉴 또는 가격 변동',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 42.0),
                          child: SizedBox(
                            width: 145,
                            height: 40,
                            child: TextButton(
                              onPressed: () {
                                bottomState(() {
                                  handleButtonSelection(6);
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: selectedButtonIndex == 6
                                    ? const Color(0xFF7B88C2)
                                    : const Color(
                                        0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                // 박스 데코레이션 추가
                                side: BorderSide(
                                    color: Colors.white.withOpacity(0.25)),
                                // 그림자 추가
                                shadowColor: Colors.black,
                                elevation: 5,
                              ),
                              child: const Text(
                                '요청 사항 적용 불가',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.only(left: 31.0),
                      child: SizedBox(
                        width: 259,
                        height: 52,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // 주문 거절 완료 시 주문 내역 리스트(orderList)에 삭제
                            // setState(() {
                            //   if (orderList.length > index) {
                            //     orderList.removeAt(index);
                            //   }
                            // });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFF7B88C2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            // 박스 데코레이션 추가
                            side: BorderSide(
                                color: Colors.white.withOpacity(0.25)),
                            // 그림자 추가
                            shadowColor: Colors.black,
                            elevation: 5,
                          ),
                          child: const Text(
                            '주문 거절 완료',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<int> getOrderId() async {
    List<OrderModel> orders =
        await OrderService().getUserOrders(widget.storeId);
    int? orderId;

    for (var order in orders) {
      orderId = order.orderId;
    }

    // orderId가 null일 경우 예외 처리
    if (orderId == null) {
      throw Exception("No orders found");
    }

    return orderId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3FF),
      appBar: AppBar(
        actions: const [
          // 오른쪽 상단에 프로필 아이콘을 나타내는 아이콘 추가
          Padding(
            padding: EdgeInsets.only(right: 23.0),
            child: Icon(
              Icons.menu,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
        // 가게 이름을 표시하는 타이틀 설정
        title: const Text(
          '접수 관리',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true, // 타이틀을 가운데 정렬
        backgroundColor: const Color(0xFF374AA3), // 앱 바 배경색 설정
        toolbarHeight: 70, // 앱 바의 높이 설정
        leading: const Padding(
          // 왼쪽 상단에 뒤로가기 아이콘을 나타내는 아이콘 추가
          padding: EdgeInsets.only(left: 15.0),
          child: BackButton(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 23.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 주문 정보 컨테이너
            FutureBuilder<List<OrderModel>>(
              future: OrderService().getUserOrders(widget.storeId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('들어온 주문이 없습니다.'),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final order = snapshot.data![index]; // 리스트 안의 객체

                        return Column(
                          children: [
                            Container(
                              width: double
                                  .infinity, // height 지정을 하지 않으면 child 크기에 맞게 지정
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    offset: const Offset(0, 4),
                                    blurRadius: 4.0,
                                  ),
                                ],
                              ),

                              // 주문 정보
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 가게 이름과 완료 상태
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          order.storeName,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 20),

                                        // 주문이 수락되지 않은 경우에만 "수락" 버튼 보이도록 설정 = 수락되면 사라지도록
                                        if (order.orderStatus == "REQUEST")
                                          SizedBox(
                                            height: 20,
                                            width: 70,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                print(
                                                    '주문 아이디 : ${order.orderId}');

                                                await LetterService()
                                                    .saveLetter(order.orderId);

                                                setState(() {
                                                  order.orderStatus == "ACCEPT";
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFF374AA3)
                                                          .withOpacity(0.66),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6))),
                                              child: const Text(
                                                '수락',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),

                                        // if (order.orderStatus == "ACCEPT")
                                        //   const Row(
                                        //     children: [
                                        //       SizedBox(width: 7),
                                        //       Icon(
                                        //         Icons.brightness_1,
                                        //         color: Color(0xFF7B88C2),
                                        //         size: 12,
                                        //       ),
                                        //       SizedBox(width: 5),
                                        //       Text(
                                        //         '조리 중',
                                        //         style: TextStyle(
                                        //             fontSize: 14,
                                        //             fontWeight:
                                        //                 FontWeight.normal,
                                        //             color: Colors.black),
                                        //       ),
                                        //     ],
                                        //   ),

                                        if (order.orderStatus == "ACCEPT")
                                          Row(
                                            children: [
                                              const SizedBox(width: 7),
                                              SizedBox(
                                                height: 20,
                                                width: 70,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    print(
                                                        '주문 아이디 : ${order.orderId}');

                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            LetterPage(
                                                                orderId: order
                                                                    .orderId),
                                                      ),
                                                    );

                                                    setState(() {
                                                      order.orderStatus ==
                                                          "DELIVERED";
                                                    });
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          const Color(
                                                                  0xFF374AA3)
                                                              .withOpacity(
                                                                  0.66),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6))),
                                                  child: const Text(
                                                    '배차',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                        // 완료 중 상태일 경우 완료 중 표시
                                        if (order.orderStatus == "DELIVERED")
                                          const Row(
                                            children: [
                                              SizedBox(width: 7),
                                              Icon(
                                                Icons.brightness_1,
                                                color: Color(0xFF6DEA6D),
                                                size: 12,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                '완료',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black),
                                              ),
                                              SizedBox(width: 7),
                                            ],
                                          ),

                                        // 주문이 수락되지 않은 경우에만 "거절" 버튼 보이도록 설정 = 수락되면 사라지도록
                                        const SizedBox(width: 7),
                                        if (order.orderStatus == "CANCELED")
                                          SizedBox(
                                            height: 20,
                                            width: 70,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                // 해당 인덱스 받아 거절 사유 함수로 전달
                                                // 주문 내역 삭제를 위해 사용
                                                _showRejectBottomSheet(index);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFFA8A8A8)
                                                          .withOpacity(0.70),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  )),
                                              child: const Text(
                                                '거절',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 13),

                                    // 주문 시간
                                    // Text(
                                    //   order['time'],
                                    //   style: const TextStyle(
                                    //     fontSize: 15,
                                    //     fontWeight: FontWeight.w500,
                                    //   ),
                                    // ),
                                    // const SizedBox(height: 5),

                                    // 주문 정보
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: order.orderMenus.length,
                                      itemBuilder: (context, index) {
                                        final orderMenu =
                                            order.orderMenus[index];
                                        return Text(
                                          '${orderMenu.menuName}  x ${orderMenu.quantity}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 8),

                                    // 총 가격과 리뷰 보기 버튼
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '총 가격 : ${order.totalPrice}원',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),

                                        // 완료 중 상태 일 경우 리뷰 보기 버튼 표시
                                        if (order.orderStatus == "DELIVERED")
                                          TextButton(
                                            onPressed: () async {
                                              // final orderId = await getOrderId();
                                              try {
                                                await ReviewService()
                                                    .getOrderReview(
                                                        order.orderId);

                                                print(order.orderId);
                                                print(widget.storeId);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          OrderReviewPage(
                                                            storeId:
                                                                widget.storeId,
                                                            orderId:
                                                                order.orderId,
                                                          ) // ReceiptPage에서는 selectedStore에 orderList의 title을 집어넣음
                                                      ),
                                                );
                                              } catch (e) {
                                                print(e.toString());
                                              }
                                            },
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.black,
                                              minimumSize: Size.zero,
                                              padding: EdgeInsets.zero,
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                            child: const Row(
                                              children: [
                                                Text(
                                                  '리뷰 보기',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(width: 11),
                                                Icon(Icons.arrow_forward_ios),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF374AA3),
        child: SizedBox(
          height: 70, // 높이 제한 설정
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(), // Gridview의 스크롤 방지
            crossAxisCount: 5, // 1개의 행에 보여줄 item의 개수
            // crossAxisSpacing: 5.0, // 같은 행의 iteme들 사이의 간격, 주석 달음(overflow 생겨서)
            children: [
              storeItem(imgPath: 'assets/images/bottom_home.png', title: '홈'),
              storeItem(
                  imgPath: 'assets/images/bottom_store.png', title: '가게 관리'),
              storeItem(
                  imgPath: 'assets/images/bottom_menu.png', title: '메뉴 관리'),
              storeItem(
                  imgPath: 'assets/images/bottom_review.png', title: '리뷰 관리'),
              storeItem(imgPath: 'assets/images/bottom_my.png', title: 'MY'),
            ],
          ),
        ),
      ),
    );
  }
}
