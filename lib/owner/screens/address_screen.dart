import 'package:flutter/material.dart';
import 'package:frontend/owner/screens/map_screen.dart';
import 'package:kpostal/kpostal.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  String postCode = '';
  String address = '';
  String jibunAddress = '';
  String latitude = '';
  String longitude = '';
  String kakaoLatitude = '';
  String kakaoLongitude = '';

  bool setAddress = false;

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
                            postCode = result.postCode;
                            address = result.address;
                            jibunAddress = result.jibunAddress;
                            latitude = result.latitude?.toString() ?? '-';
                            longitude = result.longitude?.toString() ?? '-';
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
                    builder: (context) => MapPage(address: address),
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
                        '우편번호 : $postCode',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '주소: $address',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '지번 주소: $jibunAddress',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'LatLng',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('latitude: $latitude, longitude: $longitude'),
                      const Text(
                        'through KAKAO Geocoder',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('latitude: $kakaoLatitude'),
                      Text('longitude: $kakaoLongitude'),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
