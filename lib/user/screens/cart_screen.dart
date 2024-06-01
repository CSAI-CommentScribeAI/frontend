import 'package:flutter/material.dart';
import 'package:frontend/user/widgets/cart_widget.dart';
import 'package:frontend/user/widgets/orderAndPay_widget.dart';

class CartPage extends StatefulWidget {
  final Map<String, dynamic> menu;
  const CartPage(this.menu, {super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
        child: CartWidget(widget.menu),
      ),
      bottomNavigationBar: OrderAndPayBtn(
        '주문하기',
        false,
        widget.menu,
      ),
    );
  }
}
