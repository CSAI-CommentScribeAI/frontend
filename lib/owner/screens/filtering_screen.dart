import 'package:flutter/material.dart';
import 'package:frontend/all/widgets/userReview_widget.dart';

class FilteringPage extends StatelessWidget {
  // final String selectedStore;
  final List<Map<String, dynamic>> reviewList;

  const FilteringPage({
    // required this.selectedStore,
    required this.reviewList,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // reviewList에서 block 혹은 hide 키 값이 true이 객체 review만 필터링해서 새로운 리스트(filteredReviews)에 추가
    List<Map<String, dynamic>> filteredReviews = reviewList
        .where((review) => review['block'] || review['hide'] == true)
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF374AA3),
        toolbarHeight: 70,
        leading: const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: BackButton(
            color: Colors.white,
          ),
        ),
        title: const Text(
          'selectedStore',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
        child: ListView.builder(
          itemCount: filteredReviews.length,
          itemBuilder: (BuildContext context, int index) {
            return UserReview(
              review: filteredReviews[index],
              visibleTrail: false,
            );
          },
        ),
      ),
    );
  }
}
