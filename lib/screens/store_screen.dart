import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StorePage extends StatefulWidget {
  // home_screen.dart에서 selectedStore 값을 가져옴
  final String selectedStore;
  const StorePage(this.selectedStore, {super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  TimeOfDay openInitialTime = TimeOfDay.now(); // 오픈 시간
  TimeOfDay closeInitialTime = TimeOfDay.now(); // 마감 시간
  bool openTimeBoolean = false;
  bool closeTimeBoolean = false;

  final formKey = GlobalKey<FormState>();

  String register = '';
  String name = '';
  String phoneNumber = '';
  String address = '';
  String category = '';
  String explanation = '';

  void printFormValues() {
    print('사업자 등록 번호: $register');
    print('음식점 이름: $name');
    print('음식점 전화번호: $phoneNumber');
    print('음식점 주소: $address');
    print('음식점 카테고리: $category');
    print('가게 설명: $explanation');
    print('오픈 시간: $openInitialTime');
    print('마감 시간: $closeInitialTime');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
          title: Text(
            widget.selectedStore,
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
        // Form 위젯
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 30, horizontal: 75.5),
              child: Column(
                children: [
                  storeTextFormField(
                    value: register,
                    label: '사업자 등록 번호',
                    onSaved: (val) {
                      // 입력한 값을 지정한 변수에 저장
                      setState(() {
                        register = val;
                      });
                    },
                    // 값 입력하지 않으면 에러 발생
                    validator: (val) {
                      if (val.isEmpty) {
                        return '등록 번호를 입력하세요';
                      }
                      return null;
                    },
                  ),
                  storeTextFormField(
                    value: name,
                    label: '음식점 이름',
                    onSaved: (val) {
                      setState(() {
                        name = val;
                      });
                    },
                    validator: (val) {
                      if (val.isEmpty) {
                        return '이름을 입력하세요';
                      }
                      return null;
                    },
                  ),
                  storeTextFormField(
                    value: phoneNumber,
                    label: '음식점 전화번호',
                    onSaved: (val) {
                      setState(() {
                        phoneNumber = val;
                      });
                    },
                    validator: (val) {
                      if (val.isEmpty) {
                        return '전화번호를 입력하세요';
                      }
                      return null;
                    },
                  ),
                  storeTextFormField(
                    value: address,
                    label: '음식점 주소',
                    onSaved: (val) {
                      setState(() {
                        address = val;
                      });
                    },
                    validator: (val) {
                      if (val.isEmpty) {
                        return '주소를 입력하세요';
                      }
                      return null;
                    },
                  ),
                  storeTextFormField(
                    value: category,
                    label: '음식점 카테고리',
                    onSaved: (val) {
                      setState(() {
                        category = val;
                      });
                    },
                    validator: (val) {
                      if (val.isEmpty) {
                        return '카테고리를 입력하세요';
                      }
                      return null;
                    },
                  ),
                  storeTextFormField(
                    value: explanation,
                    label: '가게 설명',
                    onSaved: (val) {
                      setState(() {
                        explanation = val;
                      });
                    },
                    validator: (val) {
                      if (val.isEmpty) {
                        return '가게 설명 입력하세요';
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 오픈 시간
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '오픈 시간',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF7E7EB2),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // 시간 설정 화면 표시
                              final TimeOfDay? timeOfDay = await showTimePicker(
                                context: context,
                                initialTime: openInitialTime,
                              );
                              // 시간 설정 시 초기 시간에 설정한 시간 저장 후 boolean 값 변경
                              if (timeOfDay != null) {
                                setState(() {
                                  openInitialTime = timeOfDay;
                                  openTimeBoolean = !openTimeBoolean;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: const Size(120, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              // timeOfDay != null로 해서 삼항연산자를 할려고 했으나 정의되지 않는 변수이고 boolean일 때만 사용하라고 해서
                              // timeBoolean이라는 불리안 변수를 만들어 설정을 안할 시 false를, 시간을 설정할 때는 true로 지정해
                              // true일 때는 설정한 시간을, false일 때는 "오픈 마감 시간"을 보이게 구현
                              openTimeBoolean
                                  ? '${openInitialTime.hour}:${openInitialTime.minute}'
                                  : '00:00',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7E7EB2),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // 마감 시간
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '마감 시간',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF7E7EB2),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final TimeOfDay? timeOfDay = await showTimePicker(
                                context: context,
                                initialTime: closeInitialTime,
                              );
                              if (timeOfDay != null) {
                                setState(() {
                                  closeInitialTime = timeOfDay;
                                  closeTimeBoolean = !closeTimeBoolean;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: const Size(120, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              closeTimeBoolean
                                  ? '${closeInitialTime.hour}:${closeInitialTime.minute}'
                                  : '00:00',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7E7EB2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: ElevatedButton(
          onPressed: () async {
            // 설정한 유효성에 맞으면 true를 리턴
            if (formKey.currentState!.validate()) {
              // validation 이 성공하면 폼 저장
              formKey.currentState!.save();

              // 스낵바를 보여줌
              Get.snackbar(
                "저장완료",
                '폼 저장이 완료되었습니다!',
                backgroundColor: Colors.white,
              );
            }
            // 저장이 되는지 안되는지 확인하기 위해 호출
            printFormValues();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF274AA3),
            minimumSize: const Size(double.infinity, 80),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          child: const Text(
            '저장하기',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// 텍스트필드 위젯 생성 함수
storeTextFormField({
  required String value,
  required String label,
  required FormFieldSetter onSaved,
  required FormFieldValidator validator,
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
      TextFormField(
        initialValue: value,
        onSaved: onSaved, // 폼 필드가 저장될 때 호출
        validator: validator, // 입력된 값의 유효성을 검사
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(5.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      const SizedBox(
        height: 18,
      ),
    ],
  );
}
