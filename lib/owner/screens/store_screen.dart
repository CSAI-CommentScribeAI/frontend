import 'package:flutter/material.dart';
import 'package:frontend/owner/models/store_model.dart';
import 'package:frontend/owner/providers/store_provider.dart';
import 'package:provider/provider.dart';

class StorePage extends StatefulWidget {
  final int? storeId;
  const StorePage({this.storeId, super.key});

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final formKey = GlobalKey<FormState>();

  bool saveColor = false;
  String storeName = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<StoreProvider>(context, listen: false)
          .getStore(widget.storeId!);

      setState(() {
        storeName =
            Provider.of<StoreProvider>(context, listen: false).store['name'];
      });
    });
  }

  Future<Map<String, dynamic>> getStoreData() async {
    return Provider.of<StoreProvider>(context, listen: false).store;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3FF),
      appBar: AppBar(
        title: Text(storeName),
        backgroundColor: const Color(0xFF274AA3),
        foregroundColor: Colors.white,
        actions: [actionIcon(icon: Icons.delete)], // 삭제 아이콘
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 320.0),
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
              FutureBuilder<Map<String, dynamic>>(
                future: getStoreData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No stores found.'));
                  } else {
                    // 해당 가게의 인덱스를 가져와 가게 정보 객체를 가져옴
                    // 아이디마다 등록한 가게의 리스트가 다르기 때문에 들어온 순서대로 storeIndex 부여
                    final store = snapshot.data!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 75.5, vertical: 10.0),
                      child: Column(
                        children: [
                          // 음식점 이름
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '음식점 이름',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF7E7EB2),
                                ),
                              ),
                              TextFormField(
                                initialValue: store['name'],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.all(5.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                                readOnly: saveColor ? false : true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          // 카테고리
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '카테고리',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF7E7EB2),
                                ),
                              ),
                              TextFormField(
                                initialValue: store['category'],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.all(5.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                                readOnly: saveColor ? false : true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          // 음식점 주소
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '음식점 주소',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF7E7EB2),
                                ),
                              ),
                              TextFormField(
                                initialValue: store['storeAddress']
                                    ['fullAddress'],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.all(5.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                                readOnly: saveColor ? false : true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          // 가게 설명
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '가게 설명',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF7E7EB2),
                                ),
                              ),
                              TextFormField(
                                initialValue: store['info'],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.all(5.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                                readOnly: saveColor ? false : true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          // 최소 주문 가격
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '최소 주문 가격',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF7E7EB2),
                                ),
                              ),
                              TextFormField(
                                initialValue: store['minOrderPrice'].toString(),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.all(5.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  suffixText: '원',
                                ),
                                textAlign: TextAlign.center,
                                readOnly: saveColor ? false : true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

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
                              TextFormField(
                                initialValue: store['openTime'],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.all(5.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                                readOnly: saveColor ? false : true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

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
                              TextFormField(
                                initialValue: store['closeTime'],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.all(5.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                                readOnly: saveColor ? false : true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '가게 로고',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF7E7EB2),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Image.network(
                                    store['storeImageUrl'] ?? '',
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: saveColor
          ? ElevatedButton(
              onPressed: () {},
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
    );
  }

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
