import 'package:flutter/foundation.dart';

class MBTIModel with ChangeNotifier {
  String _mbti = '';

  String get mbti => _mbti;

  void setMBTI(String newMbti) {
    _mbti = newMbti;
    // print("mbti_model.dart클래스의 private 변수 : ${_mbti}");
    notifyListeners();
  }
}
