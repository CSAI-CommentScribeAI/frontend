import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/all/screens/login_screen.dart';
import 'package:frontend/user/screens/menuSelect_screen.dart';
import 'package:frontend/user/screens/storeSelect_screen.dart';
import 'package:get/get.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

void main() async {
  // GetX 서비스 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // .env파일을 런타임에 가져오는 작업
  // load() 함수는 비동기 함수이기 때문에 해당 작업이 끝난 후 runApp을 하기 위해서 await을 걸어 줌
  await dotenv.load(fileName: 'assets/env/.env');

  // 라이브러리 메모리에 appKey 등록
  String appKey = dotenv.env['APP_KEY'] ?? '';
  if (appKey.isEmpty) {
    throw Exception('APP_KEY is missing in .env file');
  }

  AuthRepository.initialize(appKey: appKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // snackbar를 사용하기 위해 GetX 컨텍스트 초기화를 위해 작성
    return const GetMaterialApp(
      home: LoginPage(),
    );
  }
}
