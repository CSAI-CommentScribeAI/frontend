import 'package:flutter/material.dart';
import 'package:frontend/owner/models/menu_model.dart';
import 'package:frontend/owner/models/store_model.dart';
import 'package:frontend/user/providers/userMenu_provider.dart';
import 'package:frontend/user/services/cart_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserMenuSelectPage extends StatefulWidget {
  final StoreModel store;
  const UserMenuSelectPage({required this.store, super.key});

  @override
  State<UserMenuSelectPage> createState() => _UserMenuSelectPageState();
}

class _UserMenuSelectPageState extends State<UserMenuSelectPage> {
  var f = NumberFormat('###,###,###,###');

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<UserMenuProvider>(context, listen: false)
          .fetchMenus(widget.store.id);

      getMenuData();
    });
  }

  Future<List<AddMenuModel>> getMenuData() async {
    return Provider.of<UserMenuProvider>(context, listen: false).userMenuList;
  }

  // 숫자 세자리마다 콤마 넣는 코드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3FF),
      appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 23.0),
            child: Icon(
              Icons.home,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 23.0),
            child: Icon(
              Icons.shopping_cart,
              size: 30,
              color: Colors.black,
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: const Color(0xFFF3F3FF),
        toolbarHeight: 70,
        leading: const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: BackButton(
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Hero(
              tag: widget.store.id,
              child: Container(
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
                        width: MediaQuery.of(context).size.width / 3,
                        height: 132,
                        child: Image.asset(
                          'assets/images/deliverylogo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
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
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.store.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '최소 주문 ${f.format(widget.store.minOrderPrice)}원',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF808080),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Color(0xFFDFB300), size: 15),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.store.rating}',
                                  style: const TextStyle(
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          showReviewsBottomSheet(context);
                        },
                        child: const Text(
                          '리뷰 93개',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite),
                        color: Colors.red,
                        iconSize: 30,
                        onPressed: () {},
                      ),
                      const SizedBox(width: 2),
                      const Text(
                        '966',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        '최소주문',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF808080),
                        ),
                      ),
                      const SizedBox(
                        width: 42,
                      ),
                      Text(
                        '${f.format(widget.store.minOrderPrice)}원',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        '가게설명',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF808080),
                        ),
                      ),
                      const SizedBox(
                        width: 42,
                      ),
                      Expanded(
                        child: Text(
                          widget.store.info,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        '가게주소',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF808080),
                        ),
                      ),
                      const SizedBox(
                        width: 42,
                      ),
                      // overflow 방지로 Row 위젯의 경계를 벗어나지 않기 위해 줄바꿈 사용
                      Expanded(
                        child: Text(
                          widget.store.fullAddress,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: 0, left: 10), // 텍스트와 구분선 사이 간격 조정
                child: Text(
                  '전체 메뉴',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const Divider(), // 구분선
            Expanded(child: allMenuSection()), // 전체 메뉴 위젯 호출
          ],
        ),
      ),
    );
  }

  Widget allMenuSection() {
    return FutureBuilder<List<AddMenuModel>>(
      future: getMenuData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('등록된 메뉴가 없습니다.'),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              final userMenu = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () async {
                    try {
                      await CartService().putCart(userMenu);
                      // 장바구니 담기에 성공하면 장바구니에 페이지로 이동
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         CartItemPage(widget.store, userMenu),
                      //   ),
                      // );
                    } catch (e) {
                      // 장바구니에 담은 경우 다른 가게의 메뉴를 담을려고 할 때 경고창 구현
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('경고'),
                            content: const Text('다른 가게의 메뉴를 추가할 수 없습니다.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('확인'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Card(
                    color: const Color(0xFFF3F3FF),
                    elevation: 0,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userMenu.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '${f.format(userMenu.price)}원',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    userMenu.menuDetail,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF808080),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Image.asset(
                                          'assets/images/goodjob.png',
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        '45명',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.network(
                                  userMenu.imageUrl,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

void showReviewsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
          padding: const EdgeInsets.all(30.0),
          height: 270,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '리뷰 유형',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
            // 여기에 리뷰 목록을 추가하세요.
            Row(
              children: [
                const Text(
                  '우리 배달앱 리뷰보기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 184),
                ClipRRect(
                  // 둥근 정도 조절
                  borderRadius: BorderRadius.circular(5.0),
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset(
                      'assets/images/mydelivery.png',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 21),
            const Divider(), // 구분선 생성
            const SizedBox(height: 21),
            Row(
              children: [
                const Text(
                  '우리 배달앱 리뷰보기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 180),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset(
                      'assets/images/maindelivery.png',
                    ),
                  ),
                ),
              ],
            ),
          ]));
    },
  );
}
