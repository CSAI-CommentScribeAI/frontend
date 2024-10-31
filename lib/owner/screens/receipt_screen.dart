import 'package:flutter/material.dart';
import 'package:frontend/all/services/order_service.dart';
import 'package:frontend/owner/screens/letter_screen.dart';
import 'package:frontend/owner/screens/orderReview_screen.dart';
import 'package:frontend/owner/services/delivery_service.dart';
import 'package:frontend/owner/services/letter_service.dart';
import 'package:frontend/owner/widgets/store_widget.dart';
import 'package:frontend/user/models/order_model.dart';

class ReceiptPage extends StatefulWidget {
  final int storeId;
  const ReceiptPage(this.storeId, {super.key});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  bool isCooking = false; // 조리 중 상태

  int i = 0; // 각 객체마다 isCompleted에 접근하기 위해 선언
  // int orderId = 0;
  bool isExpanded = false;
  int selectedButtonIndex = -1;
  bool isOrderAccepted = false; // 주문이 수락되었는지 여부 확인

  // 거절 버튼 누를 시 작용하는 Bottomsheet
  // void _showRejectBottomSheet(int index) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         // bottomState는 하단 시트 내에서 상태를 업데이트하는 데 사용되는 함수 = 즉시 업데이트 가능
  //         builder: (BuildContext context, StateSetter bottomState) {
  //           return SizedBox(
  //             height: MediaQuery.of(context).size.height * 0.5,
  //             child: Center(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.all(31.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         const Text(
  //                           '거절 사유',
  //                           style: TextStyle(
  //                             fontSize: 22,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                         IconButton(
  //                           onPressed: () {
  //                             Navigator.pop(context);
  //                             setState(() {
  //                               isExpanded = true;
  //                             });
  //                           },
  //                           icon: const Icon(Icons.close),
  //                         ),
  //                       ],
  //                     ),
  //                   ),

  //                   // 텍스트 버튼
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       SizedBox(
  //                         width: 145,
  //                         height: 40,
  //                         child: TextButton(
  //                           onPressed: () {
  //                             bottomState(() {
  //                               handleButtonSelection(0);
  //                             });
  //                           },
  //                           style: TextButton.styleFrom(
  //                             backgroundColor: selectedButtonIndex == 0
  //                                 ? const Color(0xFF7B88C2)
  //                                 : const Color(0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(8.0),
  //                             ),
  //                             // 박스 데코레이션 추가
  //                             side: BorderSide(
  //                                 color: Colors.white.withOpacity(0.25)),
  //                             // 그림자 추가
  //                             shadowColor: Colors.black,
  //                             elevation: 5,
  //                           ),
  //                           child: const Text(
  //                             '가게 사정',
  //                             style: TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 14,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(width: 25),
  //                       Padding(
  //                         padding: const EdgeInsets.only(left: 31.0),
  //                         child: SizedBox(
  //                           width: 145,
  //                           height: 40,
  //                           child: TextButton(
  //                             onPressed: () {
  //                               bottomState(() {
  //                                 handleButtonSelection(1);
  //                               });
  //                             },
  //                             style: TextButton.styleFrom(
  //                               backgroundColor: selectedButtonIndex == 1
  //                                   ? const Color(0xFF7B88C2)
  //                                   : const Color(
  //                                       0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(8.0),
  //                               ),
  //                               // 박스 데코레이션 추가
  //                               side: BorderSide(
  //                                   color: Colors.white.withOpacity(0.25)),
  //                               // 그림자 추가
  //                               shadowColor: Colors.black,
  //                               elevation: 5,
  //                             ),
  //                             child: const Text(
  //                               '조리 지연',
  //                               style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 14,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 25),
  //                   // 텍스트 버튼
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       SizedBox(
  //                         width: 145,
  //                         height: 40,
  //                         child: TextButton(
  //                           onPressed: () {
  //                             bottomState(() {
  //                               handleButtonSelection(2);
  //                             });
  //                           },
  //                           style: TextButton.styleFrom(
  //                             backgroundColor: selectedButtonIndex == 2
  //                                 ? const Color(0xFF7B88C2)
  //                                 : const Color(0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(8.0),
  //                             ),
  //                             // 박스 데코레이션 추가
  //                             side: BorderSide(
  //                                 color: Colors.white.withOpacity(0.25)),
  //                             // 그림자 추가
  //                             shadowColor: Colors.black,
  //                             elevation: 5,
  //                           ),
  //                           child: const Text(
  //                             '재료 소진',
  //                             style: TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 14,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(width: 25),
  //                       Padding(
  //                         padding: const EdgeInsets.only(left: 31.0),
  //                         child: SizedBox(
  //                           width: 145,
  //                           height: 40,
  //                           child: TextButton(
  //                             onPressed: () {
  //                               bottomState(() {
  //                                 handleButtonSelection(3);
  //                               });
  //                             },
  //                             style: TextButton.styleFrom(
  //                               backgroundColor: selectedButtonIndex == 3
  //                                   ? const Color(0xFF7B88C2)
  //                                   : const Color(
  //                                       0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(8.0),
  //                               ),
  //                               // 박스 데코레이션 추가
  //                               side: BorderSide(
  //                                   color: Colors.white.withOpacity(0.25)),
  //                               // 그림자 추가
  //                               shadowColor: Colors.black,
  //                               elevation: 5,
  //                             ),
  //                             child: const Text(
  //                               '배달 불가 지역',
  //                               style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 14,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 25),
  //                   // 텍스트 버튼
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       SizedBox(
  //                         width: 145,
  //                         height: 40,
  //                         child: TextButton(
  //                           onPressed: () {
  //                             bottomState(() {
  //                               handleButtonSelection(4);
  //                             });
  //                           },
  //                           style: TextButton.styleFrom(
  //                             backgroundColor: selectedButtonIndex == 4
  //                                 ? const Color(0xFF7B88C2)
  //                                 : const Color(0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(8.0),
  //                             ),
  //                             // 박스 데코레이션 추가
  //                             side: BorderSide(
  //                                 color: Colors.white.withOpacity(0.25)),
  //                             // 그림자 추가
  //                             shadowColor: Colors.black,
  //                             elevation: 5,
  //                           ),
  //                           child: const Text(
  //                             '배달원 부재',
  //                             style: TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 14,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(width: 25),
  //                       Padding(
  //                         padding: const EdgeInsets.only(left: 31.0),
  //                         child: SizedBox(
  //                           width: 145,
  //                           height: 40,
  //                           child: TextButton(
  //                             onPressed: () {
  //                               bottomState(() {
  //                                 handleButtonSelection(5);
  //                               });
  //                             },
  //                             style: TextButton.styleFrom(
  //                               backgroundColor: selectedButtonIndex == 5
  //                                   ? const Color(0xFF7B88C2)
  //                                   : const Color(
  //                                       0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(8.0),
  //                               ),
  //                               // 박스 데코레이션 추가
  //                               side: BorderSide(
  //                                   color: Colors.white.withOpacity(0.25)),
  //                               // 그림자 추가
  //                               shadowColor: Colors.black,
  //                               elevation: 5,
  //                             ),
  //                             child: const Text(
  //                               '메뉴 또는 가격 변동',
  //                               style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 14,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 25),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.only(left: 42.0),
  //                         child: SizedBox(
  //                           width: 145,
  //                           height: 40,
  //                           child: TextButton(
  //                             onPressed: () {
  //                               bottomState(() {
  //                                 handleButtonSelection(6);
  //                               });
  //                             },
  //                             style: TextButton.styleFrom(
  //                               backgroundColor: selectedButtonIndex == 6
  //                                   ? const Color(0xFF7B88C2)
  //                                   : const Color(
  //                                       0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(8.0),
  //                               ),
  //                               // 박스 데코레이션 추가
  //                               side: BorderSide(
  //                                   color: Colors.white.withOpacity(0.25)),
  //                               // 그림자 추가
  //                               shadowColor: Colors.black,
  //                               elevation: 5,
  //                             ),
  //                             child: const Text(
  //                               '요청 사항 적용 불가',
  //                               style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 14,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 25),
  //                   Padding(
  //                     padding: const EdgeInsets.only(left: 31.0),
  //                     child: SizedBox(
  //                       width: 259,
  //                       height: 52,
  //                       child: TextButton(
  //                         onPressed: () {
  //                           Navigator.pop(context);
  //                           // 주문 거절 완료 시 주문 내역 리스트(orderList)에 삭제
  //                           // setState(() {
  //                           //   if (orderList.length > index) {
  //                           //     orderList.removeAt(index);
  //                           //   }
  //                           // });
  //                         },
  //                         style: TextButton.styleFrom(
  //                           backgroundColor: const Color(0xFF7B88C2),
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(8.0),
  //                           ),
  //                           // 박스 데코레이션 추가
  //                           side: BorderSide(
  //                               color: Colors.white.withOpacity(0.25)),
  //                           // 그림자 추가
  //                           shadowColor: Colors.black,
  //                           elevation: 5,
  //                         ),
  //                         child: const Text(
  //                           '주문 거절 완료',
  //                           style: TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 20,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          order.storeName,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        (order.orderStatus == 'REQUEST')
                                            ?
                                            // isCooking가 true일 때 조리 중으로 보여지게 구현
                                            (isCooking)
                                                ? Row(
                                                    children: [
                                                      Container(
                                                        height: 12,
                                                        width: 12,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            const BoxDecoration(
                                                                color: Color(
                                                                    0xFF7B88C2),
                                                                shape: BoxShape
                                                                    .circle),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      const Text(
                                                        '조리 중',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : ElevatedButton(
                                                    onPressed: () async {
                                                      setState(() {
                                                        isCooking =
                                                            true; // 주문 수락 후 편지 작성 후 저장 API가 성공하기 전에 true로 바꿔 조리 중으로 뜨게 구현
                                                      });
                                                      await LetterService()
                                                          .saveLetter(
                                                              order.orderId);
                                                      setState(() {
                                                        isCooking =
                                                            false; // API가 끝나면 false로 다시 돌아와 배차/수락 버튼으로 변경
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          const Color(
                                                              0xFF7B88C2),
                                                      foregroundColor:
                                                          Colors.white,
                                                      textStyle:
                                                          const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6.0),
                                                      ),
                                                      minimumSize:
                                                          const Size(50, 30),
                                                    ),
                                                    child: const Text('수락'),
                                                  )
                                            // 주문상태가 DELIVERED일 경우 배차/출력 버튼으로 변경
                                            : ElevatedButton(
                                                onPressed: () async {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          LetterPage(
                                                              orderId: order
                                                                  .orderId),
                                                    ),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFF7B88C2),
                                                  foregroundColor: Colors.white,
                                                  textStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                  ),
                                                  minimumSize:
                                                      const Size(50, 30),
                                                ),
                                                child: const Text('배차 / 출력'),
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

                                        // 리뷰 보기 버튼
                                        // 주문상태가 DELIVERED일 경우 보이게 구현
                                        if (order.orderStatus == "DELIVERED")
                                          TextButton(
                                            onPressed: () async {
                                              try {
                                                if (context.mounted) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            OrderReviewPage(
                                                              orderId:
                                                                  order.orderId,
                                                            ) // ReceiptPage에서는 selectedStore에 orderList의 title을 집어넣음
                                                        ),
                                                  );
                                                }
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
