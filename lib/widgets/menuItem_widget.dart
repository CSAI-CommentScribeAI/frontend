import 'package:flutter/material.dart';

Widget menuItem({
  required String imgPath,
  required String title,
}) {
  return Column(
    children: [
      Image.asset(imgPath),
      const SizedBox(height: 6),
      Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF374AA3).withOpacity(0.66),
        ),
      ),
    ],
  );
}
