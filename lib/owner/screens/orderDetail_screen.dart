import 'package:flutter/material.dart';
import 'package:frontend/all/services/order_service.dart';
import 'package:frontend/owner/screens/orderReview_screen.dart';
import 'package:frontend/owner/services/letter_service.dart';
import 'package:frontend/owner/widgets/store_widget.dart';
import 'package:frontend/user/models/order_model.dart';

class OrderDetailPage extends StatefulWidget {
  final int storeId;
  const OrderDetailPage(this.storeId, {super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
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
          '주문 내역',
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 주문 정보 컨테이너
              FutureBuilder<List<OrderModel>>(
                future: OrderService().getUserOrders(widget
                    .storeId), // 홈화면에서 선택된 가게 아이디를 가져와 getUserOrders 메서드에 전송
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
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final order = snapshot.data![index]; // 리스트 안의 객체

                        if (order.orderStatus == 'DELIVERED') {
                          return Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 150,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 가게 이름과 완료 상태
                                      Text(
                                        order.storeName,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
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
                                          TextButton(
                                            onPressed: () {
                                              print(order.storeId);
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           OrderReviewPage(
                                              //               storeId:
                                              //                   order.storeId,
                                              //               orderId: order
                                              //                   .orderId) // ReceiptPage에서는 selectedStore에 orderList의 title을 집어넣음
                                              //       ),
                                              // );
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
                        }
                        return null;
                      },
                    );
                  }
                },
              ),
            ],
          ),
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
