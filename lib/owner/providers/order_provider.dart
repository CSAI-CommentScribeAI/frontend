import 'package:flutter/material.dart';
import 'package:frontend/all/services/order_service.dart';
import 'package:frontend/user/models/order_model.dart';

class OrderProvider with ChangeNotifier {
  final List<OrderModel> _orderList = [];

  List<OrderModel> get orderList => _orderList;

  Future<void> getUserOrders(int storeId) async {
    List<OrderModel> getOrderList = await OrderService().getUserOrders(storeId);

    _orderList.clear();

    for (var order in getOrderList) {
      _orderList.add(order);
    }
    notifyListeners();
  }
}
