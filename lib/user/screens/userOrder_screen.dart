import 'package:cart_stepper/cart_stepper.dart';
import 'package:flutter/material.dart';
import 'package:frontend/owner/models/menu_model.dart';
import 'package:frontend/owner/models/store_model.dart';
import 'package:frontend/owner/screens/address_screen.dart';
import 'package:frontend/user/screens/complete_screen.dart';
import 'package:frontend/user/services/cart_service.dart';
import 'package:frontend/all/services/order_service.dart';

class UserOrderPage extends StatefulWidget {
  final StoreModel store;
  final AddMenuModel menu;
  const UserOrderPage(this.store, this.menu, {super.key});

  @override
  State<UserOrderPage> createState() => _UserOrderPageState();
}

class _UserOrderPageState extends State<UserOrderPage> {
  bool isChecked = false;
  bool ownerChecked = false;
  bool riderChecked = false;
  bool cart = true;
  String userAddress = '';
  int totalPrice = 0;
  int totalQuantity = 0;
  Map<int, int> itemCounts = {}; // 각 장바구니의 수량을 저장
  List<Map<String, dynamic>> orderMenus = []; // 주문 메뉴(주문 api 요청 바디에 있음)

  final List<String> orderStatus = [
    'REQUEST', // 대기 중
    'ACCEPT', // 수락
    'DELIVERED', // 배달 완료
    'CANCEL',
  ];

  @override
  void initState() {
    super.initState();
    fetchUserAddress();
    calculateTotalPrice();
    getCartInfo();
  }

  // 장바구니 정보 가져오는 메서드
  Future<Map<String, dynamic>> getCartInfo() async {
    try {
      Map<String, dynamic> cartInfo = await CartService().getCart();
      if (cartInfo.isEmpty || cartInfo['cartItems'] == null) {
        throw Exception('장바구니가 비어 있습니다.');
      }
      return cartInfo;
    } catch (e) {
      print(e);
      return {};
    }
  }

  // 주소 가져오기 메서드
  Future<void> fetchUserAddress() async {
    Map<String, dynamic> cartInstance = await CartService().getCart();
    setState(() {
      if (cartInstance.isNotEmpty) {
        userAddress = cartInstance['userAddress'];
      }
    });
  }

  // 가격 합 계산 함수
  void calculateTotalPrice() async {
    Map<String, dynamic> cartInstance = await CartService().getCart();

    int tempTotalPrice = 0;
    int tempTotalQuantity = 0;

    if (cartInstance.isNotEmpty) {
      List<dynamic> cartItems = cartInstance['cartItems'];
      for (var item in cartItems) {
        int itemId = item['menuId']; // 해당 메뉴 아이디 저장
        int itemCount = itemCounts[itemId] ?? 1; // 수량 업데이트 함수에서 수량 값 들어있음

        tempTotalPrice += (item['price'] as int) * itemCount;
        tempTotalQuantity += itemCount;
      }

      setState(() {
        totalPrice = tempTotalPrice;
        totalQuantity = tempTotalQuantity;
      });
    }
  }

  // 수량 업데이트 함수
  void updateItemCount(int itemId, int count) {
    setState(() {
      itemCounts[itemId] = count; // 해당 수량 카운트를 itemCounts의 itemId에 저장
      calculateTotalPrice(); // 가격 합 계산 함수 호출
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: CloseButton(
            color: Colors.white,
          ),
        ),
        title: const Text(
          '주문 / 결제',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Column(
            children: [
              // 고객 집 주소
              Card(
                color: Colors.white,
                shadowColor: const Color(0xFF374AA3),
                elevation: 3.0, // 그림자 설정
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '집 주소',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF808080),
                                ),
                              ),
                              // 주소 페이지로 이동
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddressPage(null, null),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  '수정',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF7E7EB2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            userAddress,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 주소 입력 경고 컨테이너
                    Container(
                      width: double.infinity,
                      height: 39,
                      decoration: BoxDecoration(
                        color: const Color(0xFFAEAEE5).withOpacity(0.3),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          '주소가 잘못 입력된 경우 재배달 및 환불이 되지 않습니다.',
                          style: TextStyle(
                            fontSize: 11.0,
                            color: Color(0xFF808080),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 17),
              // 주문 내용
              FutureBuilder(
                future: CartService().getCart(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('등록된 장바구니가 없습니다.');
                  } else {
                    final List<dynamic> cartItems = snapshot.data!['cartItems'];
                    orderMenus = []; // orderMenus 초기화
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: cartItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Map<String, dynamic> cart = cartItems[index];

                        int itemId = cart['menuId']; // 해당 메뉴 아이디 저장
                        int itemCount = itemCounts[itemId] ??
                            1; // 수량 값(itemId와 키,값 쌍을 이룸)을 itemCount에 저장(1 초기값)

                        // orderMenus에 추가
                        orderMenus.add({
                          'menuId': cart['menuId'],
                          'imageUrl': cart['imageUrl'],
                          'quantity': itemCount,
                        });

                        return Column(
                          children: [
                            Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: [
                                SizedBox(
                                  height: 230,
                                  child: Card(
                                    color: Colors.white,
                                    shadowColor: const Color(0xFF374AA3),
                                    elevation: 3.0, // 그림자 설정
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              // 추후에 구현 예정
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                cart['menuName'],
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Image.network(
                                                  cart['imageUrl'],
                                                  width: 120,
                                                  alignment: Alignment.topLeft,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text('${cart['price']}원'),
                                                  const SizedBox(width: 10),
                                                  CartStepperInt(
                                                    value: itemCount,
                                                    style:
                                                        const CartStepperStyle(
                                                      activeBackgroundColor:
                                                          Color(0xFF7E7EB2),
                                                      radius:
                                                          Radius.circular(5.0),
                                                    ),
                                                    size: 25,
                                                    didChangeCount: (count) {
                                                      if (count < 1) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .hideCurrentSnackBar();
                                                        return;
                                                      }
                                                      updateItemCount(
                                                          itemId, count);
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
                                    ),
                                    onPressed: () {
                                      // Navigate to another screen
                                    },
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final cartInfo =
                                            await CartService().getCart();
                                        OrderService().order(
                                          orderStatus[0],
                                          widget.menu.storeId,
                                          totalPrice,
                                          cartInfo,
                                          orderMenus, // orderMenus를 주문 API에 포함
                                        );
                                      },
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: Colors.black,
                                          ),
                                          SizedBox(width: 5),
                                          Text('더 담으러 가기',
                                              style: TextStyle(
                                                color: Colors.black,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 17),
              // 요청사항
              Card(
                color: Colors.white,
                shadowColor: const Color(0xFF374AA3),
                elevation: 3.0, // 그림자 설정
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '요청사항',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF808080),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                checkboxContainer(
                                  true,
                                  '일회용 수저, 포크 안주셔도 돼요',
                                  const Color(0xFF7E7EB2),
                                  Colors.white,
                                ),
                                const SizedBox(height: 14),
                                const Text(
                                  '가게 사장님께',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF808080),
                                  ),
                                ),
                                const SizedBox(height: 9),
                                checkboxContainer(
                                  false,
                                  '예) 견과류 빼주세요, 덜 맵게 해주세요',
                                  const Color(0xFFAEAEE5).withOpacity(0.3),
                                  const Color(0xFF808080).withOpacity(0.88),
                                ),
                                const SizedBox(height: 9),
                                checkboxTile(ownerChecked, '다음에도 사용', (value) {
                                  setState(() {
                                    ownerChecked = value!;
                                  });
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 라이더 요청사항 컨테이너
                    Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFFAEAEE5).withOpacity(0.3),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '라이더님께',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF808080),
                              ),
                            ),
                            const SizedBox(height: 9),
                            checkboxContainer(false, '문 앞에 두고 벨 눌러주세요',
                                const Color(0xFF7E7EB2), Colors.white),
                            const SizedBox(height: 9),
                            checkboxTile(riderChecked, '이 주소에 다음에도 사용',
                                (value) {
                              setState(() {
                                riderChecked = value!;
                              });
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // 약관동의 내용
              const Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 30.0),
                child: Text(
                  'CSAI는 통신판매중개자로서 통신판매의 당사자가 아니며, 판매자가 등록한 상품 정보, 상품의 품질 및 거래에 대해서 일체의 책임을 지지 않습니다. 회원은 주문 내용을 확인하였고, 결제에 동의합니다.',
                  style: TextStyle(
                    color: Color(0xFF808080),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () async {
          await OrderService().getOrder();

          Navigator.push(
              context,
              cart
                  ? MaterialPageRoute(
                      builder: (context) => CompletePage(widget.store))
                  : downToUpRoute());
        }, // 결제 화면으로 이동
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF274AA3),
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadiusDirectional.zero,
          ),
          minimumSize: const Size(double.infinity, 70),
        ),
        child: Text(
          '$totalPrice원 결제하기',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ), // '20000'에 totalPrice 변수 넣을 예정
    );
  }

  // 아래에서 위로 페이지 이동하는 애니메이션 함수
  Route downToUpRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          UserOrderPage(widget.store, widget.menu),

      // 페이지 전환 애니메이션 정의(child: 전환될 페이지)
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0); // 시작점 지정(화면의 아래쪽 의미)
        const end = Offset.zero; // 원래 위치(화면의 제자리) 지정
        const curve = Curves.ease; // 부드러운 속도 변화

        // 시작과 끝을 정의(부드럽게 페이지 이동)
        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        // 위에서 지정했던 애니메이션을 적용하는 위젯
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  // 체크박스 컨테이너 위젯
  Widget checkboxContainer(
      bool ischeckedBox, String title, Color backgroundColor, Color textColor) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Row(
        children: [
          // 체크박스 들어있을 때 없을 때 boolean 생성해 삼항연산자 작성
          ischeckedBox
              ? Checkbox(
                  value: isChecked,
                  onChanged: ((value) {
                    setState(() {
                      isChecked = !isChecked;
                    });
                  }),
                  activeColor: const Color(0xFFF3F3FF),
                  checkColor: const Color(0xFF7E7EB2),
                )
              : const SizedBox(width: 20),
          Text(
            title,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // 주쇼 사용 체크박스 설정 위젯
  Widget checkboxTile(
      bool checked, String title, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: checked,
          onChanged: onChanged,
          activeColor: const Color(0xFFF3F3FF),
          checkColor: const Color(0xFF7E7EB2),
        ),
        Text(title),
      ],
    );
  }
}
