import 'package:flutter/material.dart';
import 'package:frontend/user/models/order_model.dart';
import 'package:frontend/user/services/userOrder_service.dart';

class UserOrderProvider with ChangeNotifier {
  final List<OrderModel> _userOrderList = [];

  List<OrderModel> get userOrderList => _userOrderList;

  Future<void> getOrder() async {
    List<OrderModel> getUserOrderList = await UserOrderService().getOrder();

    _userOrderList.clear();

    for (var userOrder in getUserOrderList) {
      _userOrderList.add(userOrder);
    }
    notifyListeners();
  }
}
