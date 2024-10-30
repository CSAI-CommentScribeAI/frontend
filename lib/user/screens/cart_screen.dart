import 'package:flutter/material.dart';
import 'package:frontend/user/models/cartMenu_model.dart';
import 'package:frontend/user/screens/userHome_screen.dart';
import 'package:frontend/user/screens/userOrder_screen.dart';
import 'package:frontend/user/services/cart_service.dart';
import 'package:frontend/user/widgets/cart_widget.dart';
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
  void initState() {
    super.initState();
  }

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
        actions: [
          // 홈 화면으로 이동
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserHomePage(),
                  ),
                  (route) => false,
                );
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
        child: FutureBuilder<Map<String, dynamic>>(
          future: CartService().getCart(),
          builder: (context, snapshot) {
            // 데이터가 로드되는 동안 로딩 스피너 표시
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
              // 데이터 로드 중 에러 발생 시 오류 메세지 표시
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('장바구니에 담은 메뉴가 없습니다.'),
              );
              // 데이터가 없거나 빈 리스트일 경우 '등록된 가게가 없습니다' 메시지 표시
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('장바구니에 담은 메뉴가 없습니다.'),
              );
              // 데이터가 성공적으로 로드될 경우 가게 목록 표시
            } else {
              final storeName = snapshot.data!['storeName'];
              // List<CartMenuModel> 타입으로 변환
              // 이유: FutureBuilder 타입이 Map<String, dynamic>로 되어있어
              // cartItem안에 Map<String, dynamic>으로 되어있기 때문
              final List<CartMenuModel> cartItems = List<CartMenuModel>.from(
                snapshot.data!['cartItems']
                    .map((item) => CartMenuModel.fromJson(item)),
              ).toList();

              return ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: cartItems.length,
                itemBuilder: (BuildContext context, int index) {
                  final CartMenuModel cart =
                      cartItems[index]; // 하나의 cartItem 변수 지정
                  return CartWidget(cart, storeName);
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () async {
          Navigator.push(
            context,
            downToUpRoute(),
          );
        }, // 결제 화면으로 이동
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF374AA3),
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadiusDirectional.zero,
          ),
          minimumSize: const Size(double.infinity, 70),
        ),
        child: const Text(
          '주문하기',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  // 아래에서 위로 페이지 이동하는 애니메이션 함수
  Route downToUpRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const UserOrderPage(),
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
}
