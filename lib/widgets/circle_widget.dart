import 'package:flutter/material.dart';

class Circle extends StatelessWidget {
  final Color color;
  final double paddingValue; // 사용하는 곳마다 padding 다르게 설정해야 하기 때문에
  const Circle(this.color, this.paddingValue, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: paddingValue),
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
