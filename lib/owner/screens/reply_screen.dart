import 'package:flutter/material.dart';
import 'package:frontend/all/widgets/userReview_widget.dart';

class ReplyPage extends StatefulWidget {
  final List<Map<String, dynamic>> reviewList;
  final Map<String, dynamic> review;
  const ReplyPage({required this.reviewList, required this.review, super.key});

  @override
  State<ReplyPage> createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage> {
  final formKey = GlobalKey<FormState>();

  bool registerColor = false;
  String? reply;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3FF),
      appBar: AppBar(
        toolbarHeight: 70,
        // 기존 제공하는 뒤로가기 버튼 색상 변경
        leading: const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: BackButton(
            color: Colors.white,
          ),
        ),
        title: const Text(
          'BBQ 코엑스점',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 23.0),
            child: Icon(
              Icons.tune,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: const Color(0xFF374AA3),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
        child: Column(
          children: [
            UserReview(
              review: widget.review,
              visibleTrail: false,
            ),
            const SizedBox(height: 30),

            // 답글 텍스트필드
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Form(
                key: formKey,
                child: TextFormField(
                  // 사용자가 입력하거나 포커스를 이동할 때 즉시 유효성 검사가 수행되고 오류 메시지가 표시
                  // 입력 시 에러메시지 사라짐
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  initialValue: reply,
                  maxLength: 300,
                  keyboardType: TextInputType.text,
                  maxLines: 5,
                  onSaved: (val) {
                    setState(() {
                      reply = val;
                    });
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return '1자 이상 입력해주세요';
                    }
                    return null;
                  },

                  onChanged: (val) {
                    setState(() {
                      // 텍스트필드에 입력했을 때 register 값 true로 변환
                      // 입력값이 비어있는지 확인하여 registerColor 값을 조정(비어있으면 false, 비어있지 않으면 true)
                      registerColor = val.isNotEmpty;
                      print(registerColor);
                    });
                  },

                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xFF808080).withOpacity(0.7),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF374AA3),
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // 주의 글
            Text(
              '작성하신 답글에 부적절한 단어가 포함될 경우 답글이 삭제될 수 있습니다.',
              style: TextStyle(
                fontSize: 12,
                color: const Color(0xFF808080).withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),

      // 답글 등록 버튼
      bottomNavigationBar: ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
          }

          print(reply);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              registerColor ? const Color(0xFF274AA3) : const Color(0xFFB3A9A9),
          minimumSize: const Size(double.infinity, 80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        child: const Text(
          '답글 등록',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
