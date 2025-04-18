import 'package:flutter/material.dart';
import 'package:frontend/owner/models/store_model.dart';
import 'package:frontend/user/providers/category_provider.dart';
import 'package:frontend/user/screens/menuselect_screen.dart';
import 'package:frontend/user/services/selectCategory_service.dart';
import 'package:provider/provider.dart';

class StoreSelectPage extends StatefulWidget {
  const StoreSelectPage({
    super.key,
  });

  @override
  State<StoreSelectPage> createState() => _StoreSelectPageState();
}

class _StoreSelectPageState extends State<StoreSelectPage> {
  int selectedButtonIndex = -1;
  double rating = 1.0; // 별점
  double deliveryFee = 0; // 배달비
  double minOrder = 3000; // 최소주문
  final SelectCategoryService selectCategoryService = SelectCategoryService();

  @override
  void initState() {
    super.initState(); // initState 메서드를 호출하여 초기화
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await Provider.of<CategoryProvider>(context, listen: false)
    //       .getSelectCategory(widget.category);
    // });
  }

  void handleButtonSelection(int index) {
    setState(() {
      selectedButtonIndex = index;
      if (index == 5) {
        // 버튼 인덱스가 5번일 경우 Bottomsheet 생성 = 필터순 텍스트 버튼
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return buildBottomSheet(context);
          },
        );
      }
    });
  }

  Future<List<StoreModel>> getStoreData() async {
    return Provider.of<CategoryProvider>(context, listen: false).storeList;
  }

  Widget buildBottomSheet(BuildContext context) {
    return SingleChildScrollView(
      // Bottomsheet 내 스크롤 적용
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: 600,
        child: StatefulBuilder(
          // Bottomsheet에서 실시간으로 업데이트 하기위해선 StatefulBuilder 사용 필수
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '별점',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Slider(
                  // 별점 범위 필터링
                  value: rating,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: '${rating.toStringAsFixed(1)}점 이상',
                  activeColor: const Color(0xFF7E7EB2), // 채워진 부분의 색상
                  onChanged: (value) {
                    setState(() {
                      rating = value;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          rating = 1;
                        });
                      },
                      child: const Text(
                        '1점 이상',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          rating = 2;
                        });
                      },
                      child: const Text(
                        '2점 이상',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          rating = 3;
                        });
                      },
                      child: const Text(
                        '3점 이상',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          rating = 4;
                        });
                      },
                      child: const Text(
                        '4점 이상',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          rating = 5;
                        });
                      },
                      child: const Text(
                        '5점 이상',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '배달비',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Slider(
                  // 배달비 범위 필터링
                  value: deliveryFee,
                  min: 0,
                  max: 4000,
                  divisions: 4,
                  label: deliveryFee == 0 ? '무료배달' : '${deliveryFee.toInt()}원',
                  activeColor: const Color(0xFF7E7EB2), // 채워진 부분의 색상
                  onChanged: (value) {
                    setState(() {
                      deliveryFee = value;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          deliveryFee = 0;
                        });
                      },
                      child: const Text(
                        '무료배달',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          deliveryFee = 1000;
                        });
                      },
                      child: const Text(
                        '1,000원',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          deliveryFee = 2000;
                        });
                      },
                      child: const Text(
                        '2,000원',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          deliveryFee = 3000;
                        });
                      },
                      child: const Text(
                        '3,000원',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          deliveryFee = 4000;
                        });
                      },
                      child: const Text(
                        '4000원',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '최소주문',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Slider(
                  // 최소주문 범위 필터링
                  value: minOrder,
                  min: 3000,
                  max: 15000,
                  divisions: 4,
                  label: '${minOrder.toInt()}원',
                  activeColor: const Color(0xFF7E7EB2), // 채워진 부분의 색상
                  onChanged: (value) {
                    setState(() {
                      minOrder = value;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          minOrder = 3000;
                        });
                      },
                      child: const Text(
                        '3,000원',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          minOrder = 6000;
                        });
                      },
                      child: const Text(
                        '6,000원',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          minOrder = 9000;
                        });
                      },
                      child: const Text(
                        '9,000원',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          minOrder = 12000;
                        });
                      },
                      child: const Text(
                        '12,000원',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          minOrder = 15000;
                        });
                      },
                      child: const Text(
                        '15,000원',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 43),
                Center(
                  child: SizedBox(
                    width: 251,
                    height: 43,
                    child: TextButton(
                      onPressed: () {
                        // 필터 적용 버튼 클릭 시 수행할 동작을 여기에 추가하세요.
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xff7E7EB2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        '적용하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 사용자가 화면을 터치했을 때 포커스를 해제하는 onTap 콜백 정의s
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F3FF),
        appBar: AppBar(
          actions: const [
            // 오른쪽 상단에 프로필 아이콘을 나타내는 아이콘 추가
            Padding(
              padding: EdgeInsets.only(right: 23.0),
              child: Icon(
                Icons.shopping_cart,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
          // 가게 이름을 표시하는 타이틀 설정
          title: const Text(
            'CSAI 배달',
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
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal, // 버튼 가로 스크롤
                child: Row(
                  children: [
                    SizedBox(
                      // 버튼 1
                      width: 55,
                      height: 28,
                      child: TextButton(
                        onPressed: () {
                          handleButtonSelection(0);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: selectedButtonIndex == 0
                              ? const Color(0xFF7E7EB2)
                              : const Color(0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          // 박스 데코레이션 추가
                          side:
                              BorderSide(color: Colors.white.withOpacity(0.25)),
                        ),
                        child: const Text(
                          '추천순',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 9), // 버튼 사이의 간격
                    SizedBox(
                      // 버튼 2
                      width: 68,
                      height: 28,
                      child: TextButton(
                        onPressed: () {
                          handleButtonSelection(1);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: selectedButtonIndex == 1
                              ? const Color(0xFF7E7EB2)
                              : const Color(0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          // 박스 데코레이션 추가
                          side:
                              BorderSide(color: Colors.white.withOpacity(0.25)),
                        ),
                        child: const Text(
                          '주문많은순',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 9), // 버튼 사이의 간격
                    SizedBox(
                      // 버튼 3
                      width: 60,
                      height: 28,
                      child: TextButton(
                        onPressed: () {
                          handleButtonSelection(2);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: selectedButtonIndex == 2
                              ? const Color(0xFF7E7EB2)
                              : const Color(0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          // 박스 데코레이션 추가
                          side:
                              BorderSide(color: Colors.white.withOpacity(0.25)),
                        ),
                        child: const Text(
                          '가까운순',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 9), // 버튼 사이의 간격
                    SizedBox(
                      // 버튼 4
                      width: 68,
                      height: 28,
                      child: TextButton(
                        onPressed: () {
                          handleButtonSelection(3);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: selectedButtonIndex == 3
                              ? const Color(0xFF7E7EB2)
                              : const Color(0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          // 박스 데코레이션 추가
                          side:
                              BorderSide(color: Colors.white.withOpacity(0.25)),
                        ),
                        child: const Text(
                          '별점많은순',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 9), // 버튼 사이의 간격
                    SizedBox(
                      // 버튼 5
                      width: 68,
                      height: 28,
                      child: TextButton(
                        onPressed: () {
                          handleButtonSelection(4);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: selectedButtonIndex == 4
                              ? const Color(0xFF7E7EB2)
                              : const Color(0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          // 박스 데코레이션 추가
                          side:
                              BorderSide(color: Colors.white.withOpacity(0.25)),
                        ),
                        child: const Text(
                          '신규매장순',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 9), // 버튼 사이의 간격
                    SizedBox(
                      // 버튼 6
                      width: 70,
                      height: 28,
                      child: TextButton(
                        onPressed: () {
                          handleButtonSelection(5);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: selectedButtonIndex == 5
                              ? const Color(0xFF7E7EB2)
                              : const Color(0xFFD9D9D9), // 클릭 여부에 따라 색상 변경
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          side:
                              BorderSide(color: Colors.white.withOpacity(0.25)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '필터순',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(width: 4), // 텍스트와 아이콘 사이의 간격
                            Icon(
                              Icons.filter_alt,
                              color: Colors.white,
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // 가게 리스트
              Expanded(
                child: FutureBuilder<List<StoreModel>>(
                  future: getStoreData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('등록된 가게가 없습니다.'));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final store = snapshot.data![index];

                          return GestureDetector(
                            onTap: () async {
                              print('가게 아이디: ${store.id}');

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserMenuSelectPage(
                                    store: store,
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: store.id, // 가게 아이디로 태그 설정
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 18),
                                width: double.infinity,
                                height: 132,
                                padding: const EdgeInsets.only(right: 20.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(15.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      offset: const Offset(0, 4),
                                      blurRadius: 4.0,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        height: 132,
                                        child: Image.asset(
                                          'assets/images/deliverylogo.png',
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Center(
                                              child: Icon(
                                                Icons.error,
                                                color: Colors.red,
                                                size: 50,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              store.name,
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '최소 주문 ${store.minOrderPrice}원',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF808080),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            const Row(
                                              children: [
                                                Icon(Icons.star,
                                                    color: Color(0xFFDFB300),
                                                    size: 15),
                                                SizedBox(width: 4),
                                                Text(
                                                  '4.5',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
