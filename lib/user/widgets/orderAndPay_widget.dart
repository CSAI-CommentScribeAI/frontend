import 'package:flutter/material.dart';
import 'package:frontend/owner/models/menu_model.dart';
import 'package:frontend/owner/models/store_model.dart';
import 'package:frontend/user/screens/complete_screen.dart';
import 'package:frontend/user/screens/userOrder_screen.dart';

// 하단바 공통 위젯 해결해야함
class OrderAndPayBtn extends StatelessWidget {
  final String title;
  final bool cart;
  final StoreModel store;
  final AddMenuModel userMenu;

  const OrderAndPayBtn(this.title, this.cart, this.store, this.userMenu,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigator.push(
        //     context,
        //     cart
        //         ? MaterialPageRoute(builder: (context) => CompletePage(store))
        //         : downToUpRoute());
      }, // 결제 화면으로 이동
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF274AA3),
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadiusDirectional.zero,
        ),
        minimumSize: const Size(double.infinity, 70),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
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
