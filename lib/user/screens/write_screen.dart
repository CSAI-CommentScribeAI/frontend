import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:frontend/owner/models/menu_model.dart';
import 'package:frontend/owner/models/store_model.dart';
import 'package:frontend/user/screens/cart_screen.dart';
import 'package:frontend/user/screens/complete_screen.dart';
import 'package:frontend/user/screens/userHome_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/user/services/review_service.dart';

class WriteReviewPage extends StatefulWidget {
  final StoreModel store;
  final AddMenuModel? userMenu;
  final String storeName;
  final int orderId;

  const WriteReviewPage(this.store, this.userMenu,
      {required this.storeName, required this.orderId, super.key});
  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  double rating = 0.0;
  TextEditingController reviewController = TextEditingController();
  File? menuImage; // 이미지 선택
  XFile? image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
  bool isImagePicked = false;
  bool isReviewSubmitted = false; // 리뷰 제출 여부 추적
  bool isWritten = false;

  bool getWritten() {
    if (reviewController.text.isNotEmpty && rating > 0.0) {
      setState(() {
        isWritten == true;
      });
    }

    return true;
  }

  Map<String, dynamic> orderMap =
      {}; // getWrittenOrder를 통해 가져온 주문 정보를 orderMap에 저장

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    if (isImagePicked) return; // 이미지 선택 중복 방지
    // 이미지를 선택할 수 있게 다이얼로그 열림으로 변경
    setState(() {
      isImagePicked = true;
    });
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        image = XFile(pickedFile.path); // 가져온 이미지를 _image에 저장
        menuImage = File(pickedFile.path); // 가져온 이미지를 _menuImage에 저장
      });
    }
    // 선택이 완료되면 다이얼로그 닫음으로 변경
    setState(() {
      isImagePicked = false;
    });
  }

  // 카메락 / 갤러리 선택 다이얼로그
  void showImageSelectionDialog() {
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
                  image != null
                      ? SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.file(File(image!.path)),
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
                            if (image != null) {
                              menuImage = File(image!.path);
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
                            if (image != null) {
                              menuImage = File(image!.path);
                            }
                          });
                        },
                        child: const Text("갤러리"),
                      ),
                      const SizedBox(width: 20),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('리뷰 쓰기'),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserHomePage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.home,
                  size: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartItemPage(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55.0, vertical: 30),
        child: FutureBuilder(
          future: ReviewService().getOrderReview(widget.orderId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (!snapshot.hasData || snapshot.hasError) {
              return const Text('리뷰 데이터를 불러오는데 실패했습니다.');
            }
            final order = snapshot.data;

            // rate에서 지정하면 rating 지정못하기 때문에 여기서 초기값 설정
            if (order != null && rating == 0.0) {
              rating = order['rating'] ?? 0.0;
            }

            return Center(
              child: Column(
                children: [
                  // 가게 이름
                  Text(
                    widget.storeName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 별점
                  Row(
                    children: [
                      PannableRatingBar(
                        rate: rating,
                        items: List.generate(
                            5,
                            (index) => const RatingWidget(
                                  selectedColor: Color(0xFFFFCB45),
                                  unSelectedColor: Colors.grey,
                                  child: Icon(
                                    Icons.star,
                                    size: 48,
                                  ),
                                )),
                        onChanged: (value) {
                          setState(() {
                            rating = value;
                          });
                        },
                      ),
                      const SizedBox(width: 20),
                      Text(
                        '${order!['rating'] ?? 0.0}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFCB45),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // 리뷰 작성 필드
                  SizedBox(
                    width: double.infinity,
                    height: 114,
                    child: TextFormField(
                      controller: reviewController,
                      decoration: InputDecoration(
                        hintText: order['comment'] ?? '음식에 대한 솔직한 리뷰를 남겨주세요',
                        // hintStyle: const TextStyle(
                        //   color: Color(0xFFD3D3D3), // 힌트 텍스트 색상
                        //   fontSize: 14.0, // 힌트 텍스트 크기
                        // ),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5), // 배경 색상
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0), // 테두리 둥글게
                          borderSide: const BorderSide(
                            color: Color(0xFFD3D3D3), // 테두리 색상
                          ),
                        ),
                        // 입력했을 때 색상
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12.0), // 포커스된 테두리 둥글게
                          borderSide: const BorderSide(
                            color: Color(0xFFD3D3D3), // 포커스된 테두리 색상
                          ),
                        ),
                        // 입력하기 전 테두리
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12.0), // 활성화된 테두리 둥글게
                          borderSide: const BorderSide(
                            color: Color(0xFFD3D3D3), // 활성화된 테두리 색상
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 16.0,
                        ), // 내용물 패딩
                      ),
                      maxLines: null, // 여러 줄 입력 가능
                      expands: true, // TextFormField 확장
                    ),
                  ),

                  const SizedBox(height: 18),
                  // 사진 추가 버튼
                  // ElevatedButton(
                  //   onPressed: () {
                  //     _showImageSelectionDialog();
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(5.0),
                  //     ),
                  //     side: const BorderSide(
                  //       color: Color(0xFF7E7EB2),
                  //     ),
                  //     backgroundColor: Colors.white,
                  //     elevation: 0,
                  //   ),
                  //   child: const Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Icon(
                  //         Icons.camera_alt,
                  //         color: Colors.black,
                  //       ),
                  //       SizedBox(width: 10),
                  //       Text(
                  //         '사진 추가',
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 5),
                  // null값이면 이미지 삭제
                  if (menuImage != null)
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.file(menuImage!),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              // 삭제 시 가져온 이미지에 있는 값들 다 null 값으로 전환
                              menuImage = null;
                              image = null;
                            });
                          },
                          icon: const Icon(
                            Icons.close_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
      // 등록하기 버튼
      bottomNavigationBar: ElevatedButton(
        onPressed: () async {
          // 리뷰 데이터 작성
          final reviewData = {
            'rating': rating,
            'comment': reviewController.text,
          };

          // 리뷰 작성 API 호출
          final success =
              await ReviewService().writeReview(reviewData, widget.orderId);

          if (success) {
            // 리뷰 작성 성공 시
            setState(() {
              isReviewSubmitted = true; // 리뷰 제출 상태 업데이트
            });
            Navigator.pushAndRemoveUntil(
              context,
              downToUpRoute(),
              (route) => false,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF274AA3),
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadiusDirectional.zero,
          ),
          minimumSize: const Size(double.infinity, 70),
        ),
        child: const Text(
          '등록하기',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  // 아래에서 위로 페이지 이동하는 애니메이션 함수
  Route downToUpRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => CompletePage(
        widget.store,
        writtenReviews: {widget.orderId: isReviewSubmitted},
        // Pass the updated state here
      ), // 오른쪽에 있는 isWritten : 위의 isWritte의 값
      // 페이지 전환 애니메이션 정의(child: 전환될 페이지)
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0); // 시작점 지정(화면의 아래쪽 의미)
        const end = Offset.zero; // 원래 위치(화면의 제자리) 지정
        const curve = Curves.ease; // 부드러운 속도 변화
        // 시작과 끝을 정의(부드럽게 페이지 이동)
        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        // 위에서 지정했던 애니메이션을 적용하는 위젯
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
