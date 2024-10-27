import 'package:flutter/material.dart';
import 'package:frontend/user/services/cart_service.dart';

class CartProvider with ChangeNotifier {
  Map<String, dynamic> _cart = {};

  Map<String, dynamic> get cart => _cart;

  Future<Map<String, dynamic>> getCart() async {
    Map<String, dynamic> getCart = await CartService().getCart();

    _cart.clear();

    _cart = getCart;
    notifyListeners();

    return _cart;
  }
}
