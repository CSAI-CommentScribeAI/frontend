import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final TextEditingController searchController =
      TextEditingController(); // 검색어를 입력받기 위한 텍스트 컨트롤러
  KakaoMapController? mapController;

  static const String kakaoApiKey =
      'dc5f4dca4d1bc2e566f3be9bd3df53c0'; // 카카오 developer API Key

  // 지도 생성 시 호출 함수
  void onMapCreated(KakaoMapController controller) {
    mapController = controller;
  }

  void hintText(String message) {
    Text(message);
  }

  // 사용자가 입력한 검색어대로 카카오 장소 검색 API 호출
  Future<void> searchLocation() async {
    final query = searchController.text; // 검색한 값을 query에 저장

    // 검색어가 비어있으면 아무것도 실행 안됨
    if (query.isEmpty) {
      return;
    }

    final url = Uri.parse(
      'https://dapi.kakao.com/v2/local/search/keyword.json?query=$query',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'KakaoAK $kakaoApiKey'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(
            response.body); // response.body: 카카오 장소 검색 API 응답 본문, map 형식으로 변환
        final documents =
            data['documents'] as List; // 검색 결과 목록으로 list로 변환해 검색된 장소들의 정보

        if (documents.isNotEmpty) {
          final firstResult = documents[0]; // 첫번째 검색 결과의 정보를 담고 있는 firstResult

          // 검색 결과 장소의 x와 y 값을 가져옴(각각 위도와 경도에 해당)
          final latLng = LatLng(
            double.parse(firstResult['y']),
            double.parse(firstResult['x']),
          );

          mapController?.setCenter(latLng); // 지도의 중심을 latLng으로 설정
          // 검색결과 마커 표시
          mapController?.addMarker(
            markers: [
              Marker(markerId: 'search marker', latLng: latLng),
            ],
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('검색 결과가 없습니다.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('검색 중 오류가 발생했습니다: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('검색 중 오류가 발생했습니다: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kakao Map Search'),
      ),
      body: Stack(
        children: [
          KakaoMap(
            onMapCreated: onMapCreated,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 2.0,
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '검색어를 입력하세요',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFF3F3FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    elevation: 2.0,
                    shadowColor: Colors.black,
                  ),
                  onPressed: searchLocation,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
