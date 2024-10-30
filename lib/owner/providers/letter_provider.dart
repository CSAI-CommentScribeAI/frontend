import 'package:flutter/material.dart';
import 'package:frontend/owner/services/letter_service.dart';

class LetterProvider with ChangeNotifier {
  Map<String, dynamic> _letter = {};

  Map<String, dynamic> get letter => _letter;

  Future<void> getLetter(int orderId) async {
    Map<String, dynamic> getLetter = await LetterService().getLetter(orderId);

    _letter.clear();

    _letter = getLetter;
    notifyListeners();
  }
}
