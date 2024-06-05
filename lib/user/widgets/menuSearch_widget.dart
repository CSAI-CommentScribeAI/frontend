import 'package:flutter/material.dart';
import 'package:frontend/owner/models/store_model.dart';

class MenuSearchDelegate extends SearchDelegate {
  final Future<List<StoreModel>> storeItems; // 모든 가게 정보 리스트
  late Future<List<StoreModel>> filteredStoreItems;

  // query가 변경될 때마다 filterSearchResults 메서드를 호출하여 즉시 filteredStoreItems를 업데이트
  MenuSearchDelegate(this.storeItems) {
    storeItems.then((value) {
      filteredStoreItems = Future.value(value);
    });
  }

  // 텍스트 필드 우측 위젯 정의 함수
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      // 검색창을 초기화하는 클리어 버튼 구현
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          filterSearchResults(query); // 검색어를 지울 때 결과를 다시 필터링
        },
      ),
    ];
  }

  // 텍스트 필드 좌측 위젯 정의 함수
  @override
  Widget buildLeading(BuildContext context) {
    // 검색 종료 버튼 구현
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  // 검색 결과를 보여줄 위젯 정의 함수
  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<StoreModel>>(
      future: filterSearchResults(query), // 필터링된 결과 가져오기
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error : ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('해당 가게가 없습니다'));
        } else {
          return buildFilteredList(snapshot.data!);
        }
      },
    );
  }

  // 검색 제안을 보여줄 위젯 정의 함수
  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<StoreModel>>(
      future: filterSearchResults(query), //
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No stores found'));
        } else {
          return buildFilteredList(snapshot.data!);
        }
      },
    );
  }

  // 검색 결과를 필터링하는 함수
  Future<List<StoreModel>> filterSearchResults(String query) async {
    final userStores = await storeItems;
    if (query.isNotEmpty) {
      List<StoreModel> filteredList = [];

      for (var item in userStores) {
        // 검색어가 가게 이름에 포함이 되어있으면
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          filteredList.add(item);
        }
      }
      return Future.value(filteredList); // 해당 검색 결과 리스트 반환
    } else {
      return Future.value(userStores); // 없으면 모든 가게 리스트 반환
    }
  }

  // 필터링된 결과 리스트를 ListView로 보여줌
  Widget buildFilteredList(List<StoreModel> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        // 가게 정보 박스
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Container(
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
                      borderRadius: BorderRadius.circular(15.0), // 둥근 정도
                      child: SizedBox(
                        width:
                            MediaQuery.of(context).size.width / 3, // 가로 너비의 1/3
                        height: 132,
                        // 주소를 사용하기 때문에 network 사용
                        child: Image.network(
                          items[index].storeImageUrl,
                          fit: BoxFit.cover,
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
                              items[index].name,
                              style: const TextStyle(
                                fontSize: 22, // 폰트 크기
                                fontWeight: FontWeight.bold, // 폰트 굵기
                                color: Colors.black, // 폰트 색상
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '최소 주문 ${items[index].minOrderPrice}원',
                              style: const TextStyle(
                                fontSize: 12, // 폰트 크기
                                color: Color(0xFF808080), // 폰트 색상
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Row(
                              children: [
                                Icon(Icons.star,
                                    color: Color(0xFFDFB300), size: 15),
                                SizedBox(width: 4), // 별점과 숫자 간의 간격
                                Text(
                                  '4.39',
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
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
