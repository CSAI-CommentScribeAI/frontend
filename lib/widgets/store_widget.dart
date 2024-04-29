import 'package:flutter/material.dart';

Widget storeItem({
  required String imgPath,
  required String title,
}) {
  return Padding(
    padding: const EdgeInsets.all(11.0),
    child: Column(
      children: [
        Image.asset(imgPath),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}