import 'package:flutter/material.dart';
import 'package:frontend/owner/screens/address_screen.dart';
import 'package:frontend/owner/services/store_service.dart';
import 'package:frontend/owner/widgets/storeForm_widget.dart';
import 'package:get/get.dart';
import 'dart:io' show File;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class StorePage extends StatefulWidget {
  // home_screen.dart에서 selectedStore 값을 가져옴
  final String selectedStore;
  final String accessToken;
  const StorePage(this.selectedStore, this.accessToken, {super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  TimeOfDay openInitialTime = TimeOfDay.now(); // 오픈 시간
  TimeOfDay closeInitialTime = TimeOfDay.now(); // 마감 시간
  bool openTimeBoolean = false;
  bool closeTimeBoolean = false;
  bool isPickingImage = false;

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

  String register = '';
  String name = '';
  String? category;
  String phoneNumber = '';
  String fullAddress = '';
  String explanation = '';
  String minOrderPrice = '';
  String finalRoadAddress = '';
  String finalJibunAddres = '';
  String finalPostalCode = '';
  String finalLatitude = '';
  String finalLongitude = '';

  bool saveColor = false;

  File? _menuImage; // 이미지 선택
  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker();

  // TextFormField의 입력을 제어
  // final TextEditingController _textEditingController = TextEditingController();
  // final List<String> _tags = []; // 태그가 들어갈 빈 리스트

  // List<Widget> _buildTags() {
  //   return _tags.map((tag) => _buildTagItem(tag)).toList();
  // }

  // 태그 위젯
  // Widget _buildTagItem(String tag) {
  //   return Chip(
  //     label: Text(tag),
  //     labelStyle: const TextStyle(
  //       color: Colors.white,
  //       fontSize: 16,
  //     ),
  //     deleteIcon: const Icon(
  //       Icons.clear,
  //       size: 20,
  //       color: Colors.white,
  //     ),
  //     backgroundColor: const Color(0xFFD7D7FE),
  //     side: BorderSide.none,

  //     // 삭제 시 _tags 리스트에 삭제
  //     onDeleted: () {
  //       setState(() {
  //         _tags.remove(tag);
  //       });
  //     },
  //   );
  // }

  void printFormValues() {
    print('사업자 등록 번호: $register');
    print('음식점 이름: $name');
    print('음식점 카테고리: $category');
    print('음식점 주소: $fullAddress');
    print('가게 설명: $explanation');
    print('최소 주문가격: $minOrderPrice');
    print('오픈 시간: $openInitialTime');
    print('마감 시간: $closeInitialTime');
    print('지번 주소: $finalJibunAddres');
    print('위도와 경도: $finalLatitude $finalLongitude');
    print('도로명: $finalRoadAddress');
    print('우편 번호: $finalPostalCode');
    print('이미지: $_menuImage');
    // print('배달 가능 지역 $_tags');
  }

  String selectedAreaCode = '02'; // 초기값 설정

  TextEditingController resisterController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addrController = TextEditingController();
  TextEditingController infoController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  // 가게 설정 콜백 함수
  // 전체 주소를 받아서 주소 입력 컨트롤러에 저장
  void _onAddressSelected(String fullAddress) {
    setState(() {
      addrController.text = fullAddress;
    });
  }

  // 주소 전달 함수
  void sendAddress(String roadAddress, String jibunAddres, String postalCode,
      String latitude, String longitude) {
    setState(() {
      finalRoadAddress = roadAddress;
      finalJibunAddres = jibunAddres;
      finalPostalCode = postalCode;
      finalLatitude = latitude;
      finalLongitude = longitude;
    });
  }

  //이미지를 가져오는 함수
  Future<void> getImage(ImageSource imageSource) async {
    // 이미지 선택 중일 때 추가 요청 막기
    if (isPickingImage) return;

    setState(() {
      isPickingImage = true;
    });

    try {
      // pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
      final XFile? pickedFile = await picker.pickImage(source: imageSource);
      if (pickedFile != null) {
        setState(() {
          _image = XFile(pickedFile.path); // 가져온 이미지를 _image에 저장
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isPickingImage = false;
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
                      const SizedBox(width: 10),
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
                      const SizedBox(width: 10),
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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 23.0),
              child: saveColor
                  ? actionIcon(icon: Icons.delete)
                  : actionIcon(icon: Icons.account_circle),
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
                        controller: resisterController,
                        label: '사업자 등록 번호',
                        editable: saveColor ? false : true,
                        onSaved: (val) {
                          // 입력한 값을 지정한 변수에 저장
                          setState(() {
                            val = resisterController.text;
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
                        controller: nameController,
                        label: '음식점 이름',
                        editable: saveColor ? false : true,
                        onSaved: (val) {
                          setState(() {
                            val = nameController.text;
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '카테고리: $category',
                            style: TextStyle(
                              color: saveColor
                                  ? Colors.black
                                  : const Color(0xFFD9D9D9),
                            ),
                          ),
                          const SizedBox(width: 30),
                          DropdownButton<String>(
                            hint: const Text('카테고리 선택'),
                            value: category,
                            items: categories.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: saveColor
                                ? (String? val) {
                                    setState(() {
                                      category = val;
                                    });
                                  }
                                : null,
                          ),
                        ],
                      ),
                      // storeTextFormField(
                      //   controller: phoneController,
                      //   label: '음식점 전화번호',
                      //   selectedAreaCode: selectedAreaCode, // 선택된 지역번호
                      //   onAreaCodeChanged: saveColor // 편집 버튼 누를 때만 드롭다운 버튼 활성화
                      //       ? (newValue) {
                      //           setState(() {
                      //             selectedAreaCode = newValue ??
                      //                 selectedAreaCode; // 지역번호가 바뀌면 newValue값을 업데이트해 selectedAreaCode에 저장
                      //           });
                      //         }
                      //       : null,
                      //   showAreaCodeDropdown: true, // 지역번호 선택 드롭다운 표시 여부
                      //   editable: saveColor ? false : true,
                      //   onSaved: (val) {
                      //     setState(() {
                      //       phoneNumber = '$selectedAreaCode-$val'; // 전화번호 저장
                      //     });
                      //   },
                      //   validator: (val) {
                      //     if (val.isEmpty) {
                      //       return '전화번호를 입력하세요';
                      //     }
                      //     // 정규표현식을 사용하여 전화번호의 형식을 검사합니다.
                      //     // 하이픈(-)을 포함한 전화번호의 형식인지 확인하고, 중간 번호와 마지막 번호의 자릿수를 검사합니다.
                      //     RegExp phoneRegex = RegExp(r'^\d{3,4}-\d{4}$');
                      //     if (!phoneRegex.hasMatch(val)) {
                      //       return '올바른 전화번호 형식이 아닙니다';
                      //     }
                      //     return null;
                      //   },
                      //   suffixText: '',
                      // ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.7, // 예시로 너비 지정
                            child: GestureDetector(
                              onTap: () {
                                saveColor
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddressPage(
                                            // 주소 입력 페이지(AddressPage)로 함수 전달
                                            // 주소 입력 창에 주소 좀 집어넣게 주소 값 좀 알아오라고 임무 전달
                                            onAddressSelected:
                                                _onAddressSelected,
                                            sendAddress: sendAddress,
                                          ),
                                        ),
                                      )
                                    : '';
                              },
                              child: storeTextFormField(
                                controller: addrController,
                                label: '음식점 주소',
                                editable: saveColor ? false : true,
                                onSaved: (val) {
                                  setState(() {
                                    val = addrController.text;
                                    fullAddress = val;
                                  });
                                },
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return '주소를 입력하세요';
                                  }
                                  return null;
                                },
                                suffixText: '',
                                showAreaCodeDropdown:
                                    false, // 지역번호 선택 드롭다운 표시 여부
                              ),
                            ),
                          ),
                        ],
                      ),

                      storeTextFormField(
                        controller: infoController,
                        label: '가게 설명',
                        editable: saveColor ? false : true,
                        onSaved: (val) {
                          setState(() {
                            val = infoController.text;
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
                        controller: priceController,
                        label: '최소 주문 가격',
                        editable: saveColor
                            ? false
                            : true, // 편집 버튼 눌렀으면(saveColor=true) 쓰기 모드로 전환
                        onSaved: (val) {
                          setState(() {
                            val = priceController;
                            minOrderPrice = val;
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                backgroundColor: MaterialStateProperty.all<
                                        Color>(
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

                      // 배달 가능 지역
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.stretch,
                      //   children: [
                      //     TextFormField(
                      //       controller: _textEditingController,
                      //       readOnly: saveColor ? false : true,
                      //       decoration: InputDecoration(
                      //         hintText: '배달 가능 지역',
                      //         hintStyle: const TextStyle(
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.w700,
                      //           color: Colors.white,
                      //         ),
                      //         focusColor: Colors.white,
                      //         prefixIcon: const Icon(Icons.search),
                      //         prefixIconColor: Colors.white,
                      //         filled: true,
                      //         fillColor: const Color(0xFF7E7EB2),
                      //         contentPadding: const EdgeInsets.all(5.0),
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(5.0),
                      //           borderSide: BorderSide.none,
                      //         ),
                      //       ),
                      //       // 입력을 완료하고 엔터를 눌렀을 때 호출
                      //       onFieldSubmitted: (value) {
                      //         // 값을 입력했으면 _tags 리스트에 추가 및 입력 필드가 비워짐
                      //         if (value.isNotEmpty) {
                      //           setState(() {
                      //             _tags.add(value);
                      //             _textEditingController.clear();
                      //           });
                      //         }
                      //       },
                      //     ),
                      //     const SizedBox(height: 16),
                      //     Wrap(
                      //       spacing: 8,
                      //       runSpacing: 8,
                      //       children: _buildTags(),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: saveColor
            ? ElevatedButton(
                onPressed: () {
                  // 주소 페이지로 이동하면서 도로,지번 주소와 우편번호 값들을 받아온 후
                  // 이 페이지에 있는 도로,지번 주소와 우편번호 변수에 저장하기 위해 sendAddress를 호출해 값을 저장
                  sendAddress(finalRoadAddress, finalJibunAddres,
                      finalPostalCode, finalLatitude, finalLongitude);

                  // 저장이 되는지 안되는지 확인하기 위해 호출
                  printFormValues();
                  StoreService().registerStore(
                    register,
                    name,
                    category!,
                    explanation,
                    minOrderPrice,
                    fullAddress,
                    finalRoadAddress,
                    finalJibunAddres,
                    finalPostalCode,
                    finalLatitude,
                    finalLongitude,
                    openInitialTime,
                    closeInitialTime,
                    _menuImage!,
                    formKey,
                    widget.accessToken,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF274AA3),
                  minimumSize: const Size(double.infinity, 80),
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

  // 상단바 action 아이콘 위젯
  IconButton actionIcon({required IconData icon}) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        icon,
        size: 30,
        color: Colors.white,
      ),
    );
  }
}
