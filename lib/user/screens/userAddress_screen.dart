// UI 수정 필요
import 'package:flutter/material.dart';
import 'package:frontend/owner/screens/map_screen.dart';
import 'package:frontend/user/screens/userHome_screen.dart';
import 'package:kpostal/kpostal.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserAddressPage extends StatefulWidget {
  final Function(String) onUserAddressSelected;
  Function(String, String, String, String, String) sendAddress;

  UserAddressPage(this.sendAddress,
      {required this.onUserAddressSelected, super.key});

  @override
  State<UserAddressPage> createState() => _UserAddressPageState();
}

class _UserAddressPageState extends State<UserAddressPage> {
  String sentPostalCode = ''; // 우편 번호
  String sentAddress = ''; // 도로명 주소
  String sentJibun = ''; // 지번 주소
  String sentLatitude = '';
  String sentLongitude = '';
  TextEditingController detailController = TextEditingController();
  String serverAddress = '';

  // 주소 등록 api
  Future<void> registerAddr(
    String fullAddress,
    String roadAddress,
    String jibunAddress,
    String postalCode,
    String detailAddress,
    double latitude,
    double longitude,
  ) async {
    if (Platform.isAndroid) {
      serverAddress = 'http://10.0.2.2:9000/api/v1/user/addresses';
    } else if (Platform.isIOS) {
      serverAddress = 'http://127.0.0.1:9000/api/v1/user/addresses';
    }

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    try {
      final url = Uri.parse(serverAddress);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'fullAddress': fullAddress,
          'roadAddress': roadAddress,
          'jibunAddress': jibunAddress,
          'postalCode': postalCode,
          'detailAddress': detailAddress,
          'latitude': latitude,
          'longitude': longitude,
        }),
      );

      if (response.statusCode == 201) {
        print('주소 등록 성공: ${response.body}');
      } else {
        print('주소 등록 실패: ${response.body}');
      }
    } catch (e) {
      print('주소 등록 예외 발생: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF374AA3),
        toolbarHeight: 70,
        leading: const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: BackButton(
            color: Colors.white,
          ),
        ),
        title: const Text(
          '주소 설정',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '주소를',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '검색해주세요',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => KpostalView(
                        useLocalServer: false,
                        kakaoKey: '6b495c589c2dc2d9d5bb5c10b293c129',
                        callback: (Kpostal result) {
                          setState(() {
                            sentPostalCode = result.postCode;
                            sentAddress = result.address;
                            sentJibun = result.jibunAddress;
                            sentLatitude = result.latitude?.toString() ?? '-';
                            sentLongitude = result.longitude?.toString() ?? '-';
                          });
                        },
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFD9D9D9),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
                child: const Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 5),
                    Text('검색어를 입력하세요'),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.gps_fixed,
                    size: 25,
                  ),
                  SizedBox(width: 5),
                  Text(
                    '현위치로 검색하기',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPage(
                      address: sentAddress,
                      detailAddress: detailController.text,
                    ),
                  ),
                );
              },
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: Column(
                    children: [
                      Text(
                        '우편번호 : $sentPostalCode',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '주소: $sentAddress',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '지번 주소: $sentJibun',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        '위도',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                          'latitude: $sentLatitude, longitude: $sentLongitude'),

                      // 상세 주소 입력 필드
                      const Text(
                        '상세 주소',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        style: const TextStyle(fontSize: 16.0),
                        controller: detailController,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          // kpostal에서 받은 주소값들을 변수를 선언해 저장
          String detailAddress = detailController.text;
          String fullAddress = '$sentAddress $detailAddress'; // 상세 주소 생성
          String roadAddress = sentAddress;
          String jibunAddress = sentJibun;
          String postalCode = sentPostalCode;
          String latitude = sentLatitude;
          String longitude = sentLongitude;

          print('roadAddress: $roadAddress');
          print('jibunAddress: $jibunAddress');
          print('postalCode: $postalCode');
          print('detailAddress: $detailAddress');
          print('latitude: $latitude');
          print('longitude: $longitude');

          widget.onUserAddressSelected(
              fullAddress); // userHomePage에서 받은 fullAddress 값을 알아낸 뒤 전달
          widget.sendAddress(
              roadAddress, jibunAddress, postalCode, latitude, longitude);

          try {
            // 주소 등록 api
            registerAddr(
              fullAddress,
              roadAddress,
              jibunAddress,
              postalCode,
              detailAddress,
              double.parse(latitude),
              double.parse(longitude),
            );
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserHomePage(),
                ),
                (route) => false);
          } catch (e) {
            print('위도 및 경도 변환 오류: ${e.toString()}');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF374AA3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          minimumSize: const Size(double.infinity, 80),
        ),
        child: const Text(
          '등록하기',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
