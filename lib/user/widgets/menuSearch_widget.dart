import 'package:flutter/material.dart';
import 'package:frontend/owner/models/store_model.dart';

class MenuSearchDelegate extends SearchDelegate {
  final Future<List<StoreModel>> storeItems; // 모든 가게 정보 리스트
  late Future<List<StoreModel>> filteredStoreItems;

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
      future: filterSearchResults(query),
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
      future: filterSearchResults(query),
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
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          filteredList.add(item);
        }
      }
      return Future.value(filteredList);
    } else {
      return Future.value(userStores);
    }
  }

  // 필터링된 결과 리스트를 ListView로 보여줌
  Widget buildFilteredList(List<StoreModel> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(items[index].name),
        );
      },
    );
  }
}
