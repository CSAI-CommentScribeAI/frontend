import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/owner/services/menu_service.dart';

class AddMenuPage extends StatefulWidget {
  final int storeId;
  final String accessToken;
  const AddMenuPage(this.storeId, this.accessToken, {super.key});

  @override
  State<AddMenuPage> createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  // String? _selectedCategory; // 카테고리 선택
  File? _menuImage; // 이미지 선택
  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
  bool saveColor = true;

  final formKey = GlobalKey<FormState>();

  final List<String> categories = [
    '햄버거',
    '피자',
    '커피',
    '디저트',
    '한식',
    '중식',
    '분식',
    '일식',
    '치킨'
  ];

  String name = '';
  String? category;
  String price = '';
  String menuDetail = '';
  String? status = '';

  void printFormValues() {
    print('메뉴명: $name');
    print('매뉴 설정: $menuDetail');
    print('가격: $price');
    // print('카테고리: $category');
    print('노출상태: $status');
    print('이미지: $_menuImage');
  }

  TextEditingController menuController = TextEditingController();
  TextEditingController menuDetailContoller = TextEditingController();
  TextEditingController priceController = TextEditingController();

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

  void _showImageSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // 이미지가 선택되었을 때 이미지 표시
                  _image != null
                      ? SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.file(File(_image!.path)),
                        )
                      // 이미지가 선택되지 않았을 때 기본 컨테이너 표시
                      : Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey,
                        ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          getImage(ImageSource.camera).then((_) {
                            // 이미지가 선택되면 상태를 갱신하여 다이얼로그를 다시 그립니다.
                            setState(() {});
                            // 이미지가 선택되면 _menuImage에도 할당합니다.
                            if (_image != null) {
                              _menuImage = File(_image!.path);
                            }
                          });
                        },
                        child: const Text("카메라"),
                      ),
                      const SizedBox(width: 30),
                      ElevatedButton(
                        onPressed: () {
                          getImage(ImageSource.gallery).then((_) {
                            // 이미지가 선택되면 상태를 갱신하여 다이얼로그를 다시 그립니다.
                            setState(() {});
                            // 이미지가 선택되면 _menuImage에도 할당합니다.
                            if (_image != null) {
                              _menuImage = File(_image!.path);
                            }
                          });
                        },
                        child: const Text("갤러리"),
                      ),
                      const SizedBox(width: 30),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Close"),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    status = ''; // 기본값 설정
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //사용자가 화면을 터치했을 때 포커스를 해제하는 onTap 콜백 정의
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F3FF), // 배경색 설정
        appBar: AppBar(
          actions: const [
            // 오른쪽 상단에 프로필 아이콘을 나타내는 아이콘 추가
            Padding(
              padding: EdgeInsets.only(right: 23.0),
              child: Icon(
                Icons.account_circle,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
          // 가게 이름을 표시하는 타이틀 설정
          title: const Text(
            '메뉴 추가',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          centerTitle: true, // 타이틀을 가운데 정렬
          backgroundColor: const Color(0xFF374AA3), // 앱 바 배경색 설정
          toolbarHeight: 70, // 앱 바의 높이 설정
          leading: const Padding(
            // 왼쪽 상단에 뒤로가기 아이콘을 나타내는 아이콘 추가
            padding: EdgeInsets.only(left: 15.0),
            child: BackButton(
              color: Colors.white,
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 74,
                    width: 380,
                    child: TextFormField(
                      controller: menuController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Color(0xFF808080)),
                        ),
                        labelText: '메뉴명',
                        labelStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w100,
                          color: Color(0xFF808080),
                        ),
                      ),
                      maxLength: 24,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return '메뉴명을 입력하세요';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          name = val ?? '';
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 35),
                  Container(
                    height: 1,
                    width: 380,
                    color: const Color(0xFF808080),
                  ),
                  const SizedBox(height: 35),
                  SizedBox(
                    height: 86,
                    width: 380,
                    child: TextFormField(
                      controller: menuDetailContoller,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Color(0xFF808080)),
                        ),
                        labelText: '메뉴설정(선택)',
                        labelStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w100,
                          color: Color(0xFF808080),
                        ),
                      ),
                      maxLength: 24,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return '메뉴설정을 입력하세요';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          menuDetail = val!;
                        });
                      },
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '주문 수 올리는 메뉴 설명 Tip',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        '구성 품목, 양 알려주기',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.3),
                          fontWeight: FontWeight.bold,
                          fontSize: 10.5,
                        ),
                      ),
                      Text(
                        '들어가는 재료, 맛과 식감 알려주기',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.3),
                          fontWeight: FontWeight.bold,
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Container(
                    height: 1,
                    width: 380,
                    color: const Color(0xFF808080),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 58,
                        width: 180,
                        child: TextFormField(
                          controller: priceController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  const BorderSide(color: Color(0xFF808080)),
                            ),
                            labelText: '가격',
                            labelStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w100,
                              color: Color(0xFF808080),
                            ),
                            suffixText: '원',
                            suffixStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w100,
                              color: Color(0xFF808080),
                            ),
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return '가격을 입력하세요';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            setState(() {
                              price = val!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // SizedBox(
                      //   height: 58,
                      //   width: 180,
                      //   child: DropdownButtonFormField<String>(
                      //     decoration: InputDecoration(
                      //       enabledBorder: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(5),
                      //         borderSide:
                      //             const BorderSide(color: Color(0xFF808080)),
                      //       ),
                      //       labelText: '카테고리',
                      //       labelStyle: const TextStyle(
                      //         fontSize: 13,
                      //         fontWeight: FontWeight.w100,
                      //         color: Color(0xFF808080),
                      //       ),
                      //     ),
                      //     value: _selectedCategory,
                      //     items: const [
                      //       DropdownMenuItem(
                      //         value: '한식',
                      //         child: Text(
                      //           '한식',
                      //           style: TextStyle(fontSize: 14),
                      //         ),
                      //       ),
                      //       DropdownMenuItem(
                      //         value: '중식',
                      //         child: Text(
                      //           '중식',
                      //           style: TextStyle(fontSize: 14),
                      //         ),
                      //       ),
                      //       DropdownMenuItem(
                      //         value: '일식',
                      //         child: Text(
                      //           '일식',
                      //           style: TextStyle(fontSize: 14),
                      //         ),
                      //       ),
                      //       DropdownMenuItem(
                      //         value: '양식',
                      //         child: Text(
                      //           '양식',
                      //           style: TextStyle(fontSize: 14),
                      //         ),
                      //       ),
                      //     ],
                      //     onChanged: (value) {
                      //       setState(() {
                      //         _selectedCategory = value;
                      //       });
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Container(
                    height: 1,
                    width: 380,
                    color: const Color(0xFF808080),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '노출상태',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ToggleButtonGroup(
                        buttons: [
                          ToggleButton(
                            text: '판매중',
                            onPressed: () {
                              setState(() {
                                status = '판매중';
                              });
                            },
                            isSelected: status == '판매중',
                          ),
                          ToggleButton(
                            text: '품절',
                            onPressed: () {
                              setState(() {
                                status = '품절';
                              });
                            },
                            isSelected: status == '품절',
                          ),
                          ToggleButton(
                            text: '숨김',
                            onPressed: () {
                              setState(() {
                                status = '숨김';
                              });
                            },
                            isSelected: status == '숨김',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Container(
                    height: 1,
                    width: 380,
                    color: const Color(0xFF808080),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Text(
                        '메뉴사진(선택)',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      _image != null
                          ? // 이미지가 선택된 경우
                          SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.file(_menuImage!), // 선택된 이미지 표시
                            )
                          : GestureDetector(
                              onTap: _showImageSelectionDialog,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.add_photo_alternate,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                      const SizedBox(width: 25),
                      SizedBox(
                        width: 110,
                        height: 34,
                        child: TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xff374AA3).withOpacity(0.66)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          child: const Text(
                            '사진 등록',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: saveColor
            ? ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    printFormValues();

                    try {
                      await MenuService().registerMenu(
                        name,
                        price,
                        menuDetail,
                        _menuImage!,
                        status!,
                        widget.accessToken,
                        '${widget.storeId}',
                      );

                      Navigator.pop(
                          context, true); // true -> 메뉴 등록 시 바로 페이지 이동해서 보이도록
                    } catch (e) {
                      print('Error registering menu: $e');
                    }
                  }
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

// ToggleButtonGroup 클래스: 여러 개의 토글 버튼을 그룹화하는 위젯
class ToggleButtonGroup extends StatelessWidget {
  final List<ToggleButton> buttons; // 토글 버튼들의 리스트

  // ToggleButtonGroup 생성자: buttons 매개변수로 받음.
  const ToggleButtonGroup({super.key, required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < buttons.length; i++)
          Row(
            // 토글 사이의 간격 설정
            children: [
              buttons[i],
              if (i != buttons.length - 1) const SizedBox(width: 8),
            ],
          ),
      ],
    );
  }
}

// ToggleButton 클래스: 토글 기능을 가진 버튼 위젯
class ToggleButton extends StatelessWidget {
  final String text; // 버튼 텍스트
  final VoidCallback onPressed; // 버튼이 눌렸을 때 실행될 콜백 함수
  final bool isSelected; // 버튼이 선택되었는지 여부

  // ToggleButton 생성자: text, onPressed, isSelected 매개변수로 받음.
  const ToggleButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    // 버튼을 감싸는 SizedBox를 사용하여 크기를 지정
    return SizedBox(
      width: 70, // 버튼의 너비
      height: 20, // 버튼의 높이
      child: ElevatedButton(
        onPressed: onPressed, // 버튼이 눌렸을 때의 동작
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(isSelected
              ? const Color(0xFF374AA3).withOpacity(0.66) // 선택된 경우 배경색
              : const Color(0xFFA8A8A8).withOpacity(0.7)), // 선택되지 않은 경우 배경색
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6), // 버튼의 모서리를 둥글게 만듭니다.
            ),
          ),
        ),
        child: Text(
          text, // 버튼 텍스트
          style: const TextStyle(
            color: Colors.white, // 텍스트 색상
            fontWeight: FontWeight.bold, // 텍스트 굵기
            fontSize: 8, // 텍스트 크기
          ),
        ),
      ),
    );
  }
}
