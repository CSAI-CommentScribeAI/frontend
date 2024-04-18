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

  String register = '110-89-341392';
  String name = 'BBQ 코엑스점';
  String phoneNumber = '02-343-1230';
  String address = '서울특별시 강남구 영동대로 513';
  String explanation = '가게 설명글';
  int minOrderPrice = 18000;

  bool saveColor = false;

  // TextFormField의 입력을 제어
  final TextEditingController _textEditingController = TextEditingController();
  final List<String> _tags = []; // 태그가 들어갈 빈 리스트

  List<Widget> _buildTags() {
    return _tags.map((tag) => _buildTagItem(tag)).toList();
  }

  // 태그 위젯
  Widget _buildTagItem(String tag) {
    return Chip(
      label: Text(tag),
      labelStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      deleteIcon: const Icon(
        Icons.clear,
        size: 20,
        color: Colors.white,
      ),
      backgroundColor: const Color(0xFFD7D7FE),
      side: BorderSide.none,

      // 삭제 시 _tags 리스트에 삭제
      onDeleted: () {
        setState(() {
          _tags.remove(tag);
        });
      },
    );
  }

  void printFormValues() {
    print('사업자 등록 번호: $register');
    print('음식점 이름: $name');
    print('음식점 전화번호: $phoneNumber');
    print('음식점 주소: $address');
    print('가게 설명: $explanation');
    print('음식점 카테고리: $minOrderPrice');
    print('오픈 시간: $openInitialTime');
    print('마감 시간: $closeInitialTime');
    print('배달 가능 지역 $_tags');
  }

  String selectedAreaCode = '02'; // 초기값 설정

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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 350.0),
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          saveColor = !saveColor;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: saveColor
                            ? const Color(0xFF374AA3).withOpacity(0.66)
                            : const Color(0xFFB3A9A9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          // 아이콘 크기 조절
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 75.5, right: 75.5, bottom: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      storeTextFormField(
                        value: register,
                        label: '사업자 등록 번호',
                        editable: saveColor ? false : true,
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
                        suffixText: '',
                        showAreaCodeDropdown: false, // 지역번호 선택 드롭다운 표시 여부
                      ),

                      storeTextFormField(
                        value: name,
                        label: '음식점 이름',
                        editable: saveColor ? false : true,
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
                        suffixText: '',
                        showAreaCodeDropdown: false, // 지역번호 선택 드롭다운 표시 여부
                      ),

                      storeTextFormField(
                        value: phoneNumber,
                        label: '음식점 전화번호',
                        selectedAreaCode: selectedAreaCode, // 선택된 지역번호
                        onAreaCodeChanged: (newValue) {
                          setState(() {
                            selectedAreaCode = newValue ??
                                selectedAreaCode; // 지역번호가 바뀌면 newValue값을 업데이트해 selectedAreaCode에 저장
                          });
                        },
                        showAreaCodeDropdown: true, // 지역번호 선택 드롭다운 표시 여부
                        editable: saveColor ? false : true,
                        onSaved: (val) {
                          setState(() {
                            phoneNumber = '$selectedAreaCode-$val'; // 전화번호 저장
                          });
                        },
                        validator: (val) {
                          if (val.isEmpty) {
                            return '전화번호를 입력하세요';
                          }
                          // 정규표현식을 사용하여 전화번호의 형식을 검사합니다.
                          // 하이픈(-)을 포함한 전화번호의 형식인지 확인하고, 중간 번호와 마지막 번호의 자릿수를 검사합니다.
                          RegExp phoneRegex = RegExp(r'^\d{3,4}-\d{4}$');
                          if (!phoneRegex.hasMatch(val)) {
                            return '올바른 전화번호 형식이 아닙니다';
                          }
                          return null;
                        },
                        suffixText: '',
                      ),

                      storeTextFormField(
                        value: address,
                        label: '음식점 주소',
                        editable: saveColor ? false : true,
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
                        suffixText: '',
                        showAreaCodeDropdown: false, // 지역번호 선택 드롭다운 표시 여부
                      ),

                      storeTextFormField(
                        value: explanation,
                        label: '가게 설명',
                        editable: saveColor ? false : true,
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
                        suffixText: '',
                        showAreaCodeDropdown: false, // 지역번호 선택 드롭다운 표시 여부
                      ),

                      storeTextFormField(
                        value: minOrderPrice,
                        label: '최소 주문 가격',
                        editable: saveColor
                            ? false
                            : true, // 편집 버튼 눌렀으면(saveColor=true) 쓰기 모드로 전환
                        onSaved: (val) {
                          setState(() {
                            // 문자열을 정수로 변환
                            // 정수가 아닌 문자열로 변화 시 예외 처리 발생
                            try {
                              minOrderPrice = int.parse(val);
                            } on FormatException {
                              minOrderPrice = -1;
                            }
                          });
                        },
                        validator: (val) {
                          if (val.isEmpty) {
                            return '최소주문가격을 입력하세요';
                          }
                          return null;
                        },
                        suffixText: '(원)',
                        showAreaCodeDropdown: false, // 지역번호 선택 드롭다운 표시 여부
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
                                // saveColor가 true일 경우에만 press 적용
                                onPressed: saveColor
                                    ? () async {
                                        // 시간 설정 화면 표시
                                        final TimeOfDay? timeOfDay =
                                            await showTimePicker(
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
                                      }
                                    : null,
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
                                onPressed: saveColor
                                    ? () async {
                                        final TimeOfDay? timeOfDay =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: closeInitialTime,
                                        );
                                        if (timeOfDay != null) {
                                          setState(() {
                                            closeInitialTime = timeOfDay;
                                            closeTimeBoolean =
                                                !closeTimeBoolean;
                                          });
                                        }
                                      }
                                    : null,
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
                      const SizedBox(height: 30),

                      // 배달 가능 지역
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _textEditingController,
                            readOnly: saveColor ? false : true,
                            decoration: InputDecoration(
                              hintText: '배달 가능 지역',
                              hintStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              focusColor: Colors.white,
                              prefixIcon: const Icon(Icons.search),
                              prefixIconColor: Colors.white,
                              filled: true,
                              fillColor: const Color(0xFF7E7EB2),
                              contentPadding: const EdgeInsets.all(5.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            // 입력을 완료하고 엔터를 눌렀을 때 호출
                            onFieldSubmitted: (value) {
                              // 값을 입력했으면 _tags 리스트에 추가 및 입력 필드가 비워짐
                              if (value.isNotEmpty) {
                                setState(() {
                                  _tags.add(value);
                                  _textEditingController.clear();
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _buildTags(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: saveColor
            ? ElevatedButton(
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
              )
            : Container(
                height: 0,
              ),
      ),
    );
  }
}

// 텍스트필드 위젯 생성 함수
storeTextFormField({
  required dynamic value,
  required String label,
  required FormFieldSetter onSaved,
  required FormFieldValidator validator,
  required bool editable,
  required String suffixText,
  required bool showAreaCodeDropdown, // 새로운 인자: 지역번호 선택 드롭다운을 표시할지 여부
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
          // 지역번호 선택을 위한 드롭다운
          showAreaCodeDropdown
              ? DropdownButton<String>(
                  value: selectedAreaCode, // 선택된 지역번호
                  onChanged: onAreaCodeChanged, // 지역번호 변경 시 호출될 함수
                  items: <String>['02', '031', '032', '033'] // 지역번호 목록
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              : Container(width: 0),
          const SizedBox(width: 8), // 조금의 간격을 추가하여 텍스트 필드와 분리
          Expanded(
            child: TextFormField(
              initialValue: value.toString(),
              onSaved: onSaved, // 폼 필드가 저장될 때 호출
              validator: validator, // 입력된 값의 유효성을 검사
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
