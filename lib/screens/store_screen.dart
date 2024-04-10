import 'package:flutter/material.dart';
import 'package:frontend/widgets/storeInfo_widget.dart';

class StorePage extends StatefulWidget {
  // home_screen.dart에서 selectedStore 값을 가져옴
  final String selectedStore;
  const StorePage(this.selectedStore, {super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  TimeOfDay initialTime = TimeOfDay.now();
  bool timeBoolean = false;

  final resisterTextEditController = TextEditingController();
  final nameTextEditController = TextEditingController();
  final phoneTextEditController = TextEditingController();
  final addressTextEditController = TextEditingController();
  final cateTextEditController = TextEditingController();
  final exTextEditController = TextEditingController();
  final timeTextEditingController = TextEditingController();
  final placeTextEditingController = TextEditingController();

  bool editColor = false;

  // TextEditingController를 사용하여 작성한 정보를 변수에 저장
  String? resisterText;
  String? nameText;
  String? phoneText;
  String? addressText;
  String? cateText;
  String? exText;
  String? timeText;
  String? placeText;

  @override
  void dispose() {
    resisterTextEditController.dispose();
    nameTextEditController.dispose();
    phoneTextEditController.dispose();
    addressTextEditController.dispose();
    cateTextEditController.dispose();
    exTextEditController.dispose();
    timeTextEditingController.dispose();
    placeTextEditingController.dispose();
    super.dispose();
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 23.0),
              child: SizedBox(
                width: 30,
                height: 30,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      editColor = !editColor;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: editColor
                        ? const Color(0xFF374AA3).withOpacity(0.66)
                        : Colors.black.withOpacity(0.66),
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
            Expanded(
              child: ListView.builder(
                itemCount: 1, // 한 세트로 설정
                itemBuilder: (BuildContext context, index) {
                  return Column(
                    children: [
                      storeInfo(
                        controller: resisterTextEditController,
                        inputType: TextInputType.phone,
                        label: '사업자 등록 번호',
                        text: resisterText,
                      ),
                      const SizedBox(height: 30),
                      storeInfo(
                          controller: nameTextEditController,
                          inputType: TextInputType.text,
                          label: '이름',
                          text: nameText),
                      const SizedBox(height: 30),
                      storeInfo(
                        controller: phoneTextEditController,
                        inputType: TextInputType.phone,
                        label: '전화번호',
                        text: phoneText,
                      ),
                      const SizedBox(height: 30),
                      storeInfo(
                        controller: addressTextEditController,
                        inputType: TextInputType.streetAddress,
                        label: '주소',
                        text: addressText,
                      ),
                      const SizedBox(height: 30),
                      storeInfo(
                        controller: cateTextEditController,
                        inputType: TextInputType.text,
                        label: '카테고리',
                        text: cateText,
                      ),
                      const SizedBox(height: 30),
                      storeInfo(
                        controller: exTextEditController,
                        inputType: TextInputType.text,
                        label: '가게 설명',
                        text: exText,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 오픈 시간
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: const Size(120, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              '오픈 시간',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7E7EB2),
                              ),
                            ),
                          ),

                          // 마감 시간
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: const Size(120, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              '마감 시간',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7E7EB2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      storeInfo(
                        controller: placeTextEditingController,
                        inputType: TextInputType.text,
                        label: '배달 가능 지역',
                        text: placeText,
                      ),
                    ],
                  );
                },
                padding: const EdgeInsets.symmetric(
                    horizontal: 80.0, vertical: 10.0),
              ),
            ),
          ],
        ),
        bottomNavigationBar: ElevatedButton(
          onPressed: () {
            resisterText = resisterTextEditController.text;
            nameText = nameTextEditController.text;
            phoneText = phoneTextEditController.text;
            addressText = addressTextEditController.text;
            cateText = cateTextEditController.text;
            exText = exTextEditController.text;
            timeText = timeTextEditingController.text;
            placeText = placeTextEditingController.text;

            // 가져온 내용을 출력
            print('사업자 등록 번호: $resisterText');
            print('이름: $nameText');
            print('전화번호: $phoneText');
            print('주소: $addressText');
            print('카테고리: $cateText');
            print('가게 설명: $exText');
            print('오픈 마감 시간: $timeText');
            print('배달 가능 지역: $placeText');

            // 필요한 경우 가져온 내용을 화면에 표시할 수 있음
            setState(() {
              resisterTextEditController.text = resisterText!;
              nameTextEditController.text = nameText!;
              phoneTextEditController.text = phoneText!;
              addressTextEditController.text = addressText!;
              cateTextEditController.text = cateText!;
              exTextEditController.text = exText!;
              timeTextEditingController.text = timeText!;
              placeTextEditingController.text = placeText!;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF274AA3),
            minimumSize: const Size(double.infinity, 70),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          child: const Text(
            '저장하기',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
