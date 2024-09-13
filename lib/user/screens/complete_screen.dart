import 'package:flutter/material.dart';
import 'package:frontend/owner/models/store_model.dart';
import 'package:frontend/user/models/order_model.dart';
import 'package:frontend/all/services/order_service.dart';
import 'package:frontend/user/screens/write_screen.dart';
import 'package:frontend/user/services/review_service.dart';
import 'package:intl/intl.dart';

class CompletePage extends StatefulWidget {
  final StoreModel store;
  final Map<int, bool>? writtenReviews;
  final Map<int, String>? reviewTexts; // Add this line

  const CompletePage(this.store,
      {this.writtenReviews, this.reviewTexts, super.key});

  @override
  State<CompletePage> createState() => _CompletePageState();
}

class _CompletePageState extends State<CompletePage> {
  List<OrderModel> orderList = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    List<OrderModel> orders = await OrderService().getOrder();
    setState(() {
      orderList = orders;
    });
  }

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat('###,###,###,###'); // 숫자 세자리마다 콤마 넣는 코드

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: const BackButton(
          color: Colors.white,
        ),
        title: const Text(
          '주문 내역',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF374AA3),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const UserHomePage(),
                //   ),
                // );
              },
              icon: const Icon(
                Icons.home,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 24.0),
        child: orderList.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: orderList.length,
                itemBuilder: (BuildContext context, int index) {
                  final order = orderList[index];
                  bool isWritten =
                      widget.writtenReviews?[order.orderId] ?? false;

                  return Column(
                    children: [
                      Column(
                        children: [
                          Card(
                            color: Colors.white,
                            shadowColor: const Color(0xFF374AA3),
                            elevation: 3.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 20.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              order.storeName,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Text(
                                              order.orderStatus,
                                              style: const TextStyle(
                                                color: Color(0xFF808080),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/images/deliverylogo.png',
                                        width: 80,
                                        height: 80,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: order.orderMenus.length,
                                    itemBuilder: (context, index) {
                                      final orderMenu = order.orderMenus[index];
                                      return Text(
                                        '${orderMenu.menuName} x ${orderMenu.quantity}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 34),
                                  Text(
                                    '합계 : ${f.format(order.totalPrice)}원',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 28),

                                  // 주문상태가 배달일 경우에만 리뷰 쓰기 버튼 활성화
                                  if (order.orderStatus == 'DELIVERED')
                                    FutureBuilder(
                                      future: ReviewService()
                                          .getOrderReview(order.orderId),
                                      builder: (context, snapshot) {
                                        final review = snapshot.data;
                                        return Center(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              print(order.orderId);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      WriteReviewPage(
                                                    widget.store,
                                                    null,
                                                    storeName: order.storeName,
                                                    orderId: order.orderId,
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              minimumSize: const Size(302, 39),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              side: const BorderSide(
                                                color: Color(0xFF7E7EB2),
                                                width: 2.0,
                                              ),
                                            ),
                                            child: Text(
                                              // db에 리뷰가 있을 때 작성된 리뷰로 변경
                                              review!['comment'] != null
                                                  ? '작성된 리뷰'
                                                  : '리뷰 쓰기',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
