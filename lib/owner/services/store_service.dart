import 'package:frontend/owner/models/store_model.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<StoreModel>> getStore() async {
    late String serverAddress;

    try {
      if (Platform.isAndroid) {
        serverAddress = 'http://10.0.2.2:9000/api/v1/store/';
      } else if (Platform.isIOS) {
        serverAddress = 'http://127.0.0.1:9000/api/v1/store/';
      }

      final url = Uri.parse(serverAddress);
      final response = await http.get(url);
      List<StoreModel> stores = [];

      if (response.statusCode == 200) {
        print('조회 성공 $stores');
        return stores;
      } else {
        print('조회 실패');
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
