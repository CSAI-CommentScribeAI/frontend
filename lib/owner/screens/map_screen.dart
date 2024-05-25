import 'package:flutter/material.dart';
import 'package:frontend/owner/screens/store_screen.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class MapPage extends StatefulWidget {
  String address;
  String detailAddress;
  MapPage({required this.address, required this.detailAddress, super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  KakaoMapController? mapController;
  static const String kakaoApiKey =
      'dc5f4dca4d1bc2e566f3be9bd3df53c0'; // 카카오 developer API Key

  // 지도 생성 시 호출 함수
  void onMapCreated(KakaoMapController controller) {
    mapController = controller;
    // 지도 생성 직후 검색 수행
    searchLocation();
  }

  // 사용자가 입력한 검색어대로 카카오 장소 검색 API 호출
  Future<void> searchLocation() async {
    final query = widget.address; // 검색한 값을 query에 저장
    print('Searching for: $query'); // 디버깅 로그 추가

    // 검색어가 비어있으면 아무것도 실행 안됨
    if (query.isEmpty) {
      return;
    }

    final url = Uri.parse(
      'https://dapi.kakao.com/v2/local/search/address.json?query=$query',
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

          final address = firstResult['address'] ?? {}; // address의 value 값 생성
          final roadAddress =
              firstResult['road_address'] ?? {}; // road_address의 value 값 생성

          // 결과를 사용자에게 보여주는 다이얼로그를 안전하게 호출
          if (mounted) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('검색 결과'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('전체 주소: ${firstResult['address_name']}'),
                        Text('도로명 주소: ${roadAddress['road_name'] ?? '없음'}'),
                        Text('지번 주소: ${address['address_name'] ?? '없음'}'),
                        Text('상세주소: ${widget.detailAddress}'),
                        Text('우편번호: ${roadAddress['zone_no'] ?? '없음'}'),
                        Text('위도: ${firstResult['y']}'),
                        Text('경도: ${firstResult['x']}'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('확인'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          }
        } else {
          Get.snackbar('검색 결과가 없습니다.', '다시 검색해보세요');
        }
      } else {
        Get.snackbar('검색 중 오류가 발생했습니다', '${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('검색 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('지도에서 위치 확인'),
      ),
      body: KakaoMap(
        onMapCreated: onMapCreated,
      ),
    );
  }
}
