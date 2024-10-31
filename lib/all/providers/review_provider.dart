import 'package:flutter/material.dart';
import 'package:frontend/all/services/review_service.dart';

class ReviewProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _storeReviewList = [];
  Map<String, dynamic> _orderReviewList = {};

  List<Map<String, dynamic>> get storeReviewList => _storeReviewList;
  Map<String, dynamic> get orderReviewList => _orderReviewList;

  // 가게별 리뷰 조회
  Future<void> getStoreReview(int storeId) async {
    List<Map<String, dynamic>> getStoreReviewList =
        await ReviewService().getStoreReview(storeId);

    _storeReviewList.clear();

    for (var storeReview in getStoreReviewList) {
      _storeReviewList.add(storeReview);
    }
    notifyListeners();
  }

  // 주문 리뷰 조회
  Future<void> getOrderReview(int orderId) async {
    Map<String, dynamic> getOrderReviewList =
        await ReviewService().getOrderReview(orderId);

    _orderReviewList.clear();

    _orderReviewList = getOrderReviewList;
    notifyListeners();
  }
}
