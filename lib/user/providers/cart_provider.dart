import 'package:flutter/material.dart';
import 'package:frontend/user/services/cart_service.dart';

class CartProvider with ChangeNotifier {
  Map<String, dynamic> _cart = {};

  Map<String, dynamic> get cart => _cart;

  // 장바구니 조회
  Future<void> getCart() async {
    Map<String, dynamic> getCart = await CartService().getCart();

    _cart.clear();

    _cart = getCart;
    notifyListeners();
  }
}
