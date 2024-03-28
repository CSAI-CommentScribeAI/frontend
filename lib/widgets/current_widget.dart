import 'package:flutter/material.dart';

class CurrentCircle extends StatelessWidget {
  final Color borderColor, centerColor;
  final String value;

  const CurrentCircle(this.borderColor, this.centerColor, this.value,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: centerColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 8,
        ),
      ),
      child: Center(
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
