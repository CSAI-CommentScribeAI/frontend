import 'package:flutter/material.dart';
import 'package:frontend/user/services/review_service.dart';

class ReviewProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _storeReviewList = [];

  List<Map<String, dynamic>> get storeReviewList => _storeReviewList;

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
}
