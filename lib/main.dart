import 'package:flutter/material.dart';
import 'package:frontend/Login_screen.dart';
import 'package:get/get.dart';

void main() {
  // GetX 서비스 초기화
  WidgetsFlutterBinding.ensureInitialized();
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
