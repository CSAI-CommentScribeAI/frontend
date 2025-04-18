import 'package:flutter/material.dart';

// 가게 정보 텍스트필드 위젯
Widget storeTextFormField({
  required TextEditingController controller,
  required String label,
  required FormFieldSetter onSaved,
  required FormFieldValidator validator,
  Function(String)? onChanged,
  required bool editable,
  required String suffixText,
  String? selectedAreaCode, // 새로운 인자: 선택된 지역번호, 필수가 아님
  void Function(String?)?
      onAreaCodeChanged, // 새로운 인자: 지역번호 변경 시 호출될 콜백 함수, 필수가 아님
}) {
  return Column(
    children: [
      Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF7E7EB2),
            ),
          ),
        ],
      ),
      Row(
        children: [
          const SizedBox(width: 8), // 조금의 간격을 추가하여 텍스트 필드와 분리
          Expanded(
            child: TextFormField(
              controller: controller,
              onSaved: onSaved, // 폼 필드가 저장될 때 호출
              validator: validator, // 입력된 값의 유효성을 검사
              onChanged: onChanged,
              readOnly: editable, // 읽기/쓰기 권한
              textAlign: TextAlign.center, // 중앙 정렬
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(5.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide.none,
                ),
                suffixText: suffixText,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 18,
      ),
    ],
  );
}
