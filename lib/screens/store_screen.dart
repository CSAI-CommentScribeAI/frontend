import 'package:flutter/material.dart';

class StorePage extends StatelessWidget {
  // home_screen.dart에서 selectedStore 값을 가져옴
  final String selectedStore;
  const StorePage(this.selectedStore, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        // 기존 제공하는 뒤로가기 버튼 색상 변경
        leading: const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: BackButton(
            color: Colors.white,
          ),
        ),
        title: Text(
          selectedStore,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 23.0),
            child: Icon(
              Icons.account_circle,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: const Color(0xFF374AA3),
      ),
    );
  }
}
