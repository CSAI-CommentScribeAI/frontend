import 'package:flutter/material.dart';
import 'package:frontend/owner/models/store_model.dart';
import 'package:frontend/user/models/category_model.dart';
import 'package:frontend/user/providers/category_provider.dart';
import 'package:frontend/user/screens/complete_screen.dart';
import 'package:frontend/user/screens/storeselect_screen.dart';
import 'package:frontend/user/screens/userAddress_screen.dart';
import 'package:frontend/user/services/selectCategory_service.dart';
import 'package:frontend/user/services/userStore_service.dart';
import 'package:frontend/user/widgets/menuSearch_widget.dart';
import 'package:provider/provider.dart';

class UserHomePage extends StatefulWidget {
  final String accessToken;
  const UserHomePage(this.accessToken, {super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  List<CategoryModel> categories = [];
  late Future<List<StoreModel>> futureStores;

  TextEditingController searchController = TextEditingController();
  String userAddress = '주소를 설정하세요'; // 고객 주소
  String fullAddress = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<CategoryProvider>(context, listen: false).getCategory();

      setState(() {
        List<CategoryModel> getCategories =
            Provider.of<CategoryProvider>(context, listen: false).categoryList;

        for (var category in getCategories) {
          categories.add(category);
        }
      });
    });
  }

// 카테고리 정보를 서버에서 가져오는 메서드
  // void fetchCategories() async {
  //   // SelectCategoryService 인스턴스를 생성
  //   SelectCategoryService categoryService = SelectCategoryService();

  //   // categoryService를 사용하여 카테고리 정보를 비동기적으로 가져옴
  //   List<StoreModel> fetchedCategories = await categoryService.getCategory(0);

  //   // 상태를 업데이트하여 가져온 카테고리 정보를 categories 리스트에 저장
  //   setState(() {
  //     categories = fetchedCategories;
  //   });
  // }

  void filterSearchResults(String query) {}

  // 받아온 주소 값을 사용자 주소(userAddress)에 실시간 저장
  void onUserAdddressSelected(String fullAddress) {
    setState(() {
      userAddress = fullAddress;
    });
  }

  // 영어 카테고리를 한글로 변환하는 맵
  Map<String, String> categoryTranslations = {
    'HAMBURGER': '햄버거',
    'PIZZA': '피자',
    'DESSERT': '디저트',
    'KOREANFOOD': '한식',
    'CHINESEFOOD': '중식',
    'FLOURBASEDFOOD': '분식',
    'JAPANESEFOOD': '일식',
    'CHICKEN': '치킨',
  };

  Future<StoreModel> getStoreModel() async {
    List<StoreModel> storeList = await UserStoreService().getManyStores();
    StoreModel? stores;

    for (var store in storeList) {
      stores = store;
    }
    // 만약 조건에 맞는 store가 없다면 예외를 던질 수 있습니다.
    if (stores == null) {
      throw Exception('No store found');
    }

    return stores;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3FF),
      appBar: AppBar(
        automaticallyImplyLeading: false, // 페이지 이동 시 자동으로 생긴 뒤로가기 버튼 숨김
        backgroundColor: const Color(0xFF374AA3),

        // 배달앱 이름
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: userAddress, // 사용자 주소
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserAddressPage(
                            (p0, p1, p2, p3, p4) => null,
                            widget.accessToken,
                            onUserAddressSelected:
                                onUserAdddressSelected, // 필수 요소
                          ),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        centerTitle: false,
        actions: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Image.asset(
                  'assets/images/bottom_my.png',
                  width: 20,
                  height: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Icon(
                  Icons.shopping_cart,
                  size: 26, // 아이콘 크기 설정
                  color: Colors.white, // 아이콘 색상 설정
                ),
              ),
            ),
            onTap: () async {
              StoreModel storeModel = await getStoreModel();

              print('storeModel : $storeModel');

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompletePage(
                    storeModel,
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Center(
          child: Column(
            children: [
              // 오늘의 배달 Tip
              Container(
                width: 400,
                height: 88,
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.only(bottom: 16.0), // 박스들 사이 간격
                decoration: BoxDecoration(
                  color: const Color(0xFFAEAEE5).withOpacity(0.25),
                  borderRadius: BorderRadius.circular(15.0), // 박스 둥근 비율
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '오늘의 배달 Tip',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Image.asset(
                            'assets/images/light.png',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '오늘의 배달팁 알려주세요',
                      style: TextStyle(
                        color: Color(0xFFC6C2C2),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 19.0),

                // 검색 창
                child: Container(
                  padding: const EdgeInsets.only(left: 14),
                  width: 400,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF374AA3).withOpacity(0.5),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            // 검색 화면으로 이동
                            showSearch(
                              context: context,
                              delegate: MenuSearchDelegate(futureStores),
                            );
                          },
                          child: const Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Color(0xFFC6C2C2),
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                '뭐든 다 좋아 다 나와라!!!',
                                style: TextStyle(
                                  color: Color(0xFFC6C2C2),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 13),

              // 광고
              Container(
                // 세 번째 박스
                height: 127,
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  color: Color(0xffAEAEE5),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'CSAI 회원이라면 놓칠 수 없지!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'CSAI만의 ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 11,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '무료 배달',
                                    style: TextStyle(
                                      color: Colors.red, // 여기에 원하는 색상으로 변경
                                      fontSize: 11,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' 멤버십!!!',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 11,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 69),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Image.asset(
                        'assets/images/free.png',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 음식 메뉴
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19.0),
                  child: (userAddress == '주소를 설정하세요')
                      ? const Center(
                          child: Text(
                            '주소를 설정해주세요',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : categories.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : GridView.count(
                              crossAxisCount: 3, // 3 x 3
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              children:
                                  List.generate(categories.length, (index) {
                                bool isDeliveryLogo =
                                    categories[index].category == 'CSAI';
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserMenuPage(
                                          category: categories[index].category,
                                        ),
                                      ),
                                    );
                                    print(
                                        "Food item ${categories[index].category} clicked!"); // Example
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF374AA3)
                                              .withOpacity(0.5),
                                          blurRadius: 4,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/${categories[index].category.toLowerCase()}.png',
                                          height: isDeliveryLogo ? 108 : 50,
                                          width: isDeliveryLogo ? 108 : 50,
                                        ),
                                        if (!isDeliveryLogo) ...[
                                          const SizedBox(height: 10),
                                          Text(
                                            // categories[index].category,
                                            categoryTranslations[
                                                    categories[index]
                                                        .category] ??
                                                categories[index].category,

                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
