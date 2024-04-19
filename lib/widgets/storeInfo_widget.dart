import 'package:flutter/material.dart';

Widget storeInfo({
  required TextInputType inputType,
  required String label,
  required dynamic text,
  required TextEditingController controller,
}) {
  return SizedBox(
    height: 50,
    child: TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        labelText: label, // 각 TextField에 대한 라벨 텍스트
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF7E7EB2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onSaved: (value) {
        text = value;
      },
    ),
  );
}
