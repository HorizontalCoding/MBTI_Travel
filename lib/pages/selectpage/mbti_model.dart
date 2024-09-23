import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';  // 색상을 다루기 위해 추가

class MBTIModel with ChangeNotifier {
  String _mbti = '';
  Color _mbtiColor = Colors.grey;  // 초기 색상값을 설정

  // Getter for MBTI
  String get mbti => _mbti;

  // Getter for MBTI Color
  Color get mbtiColor => _mbtiColor;

  // MBTI 값을 설정하고, 해당하는 색상도 설정
  void setMBTI(String newMbti) {
    _mbti = newMbti;
    _mbtiColor = getMbtiColor(newMbti);  // 색상도 함께 설정
    notifyListeners();  // 상태 변경 알림
  }

  // MBTI 값에 따른 색상 반환 함수
  Color getMbtiColor(String? mbti) {
    switch (mbti) {
      case 'ISTJ':
        return Color(0xFFFF8787);
      case 'ISTP':
        return Color(0xFFFE9886);
      case 'ISFJ':
        return Color(0xFFFFCFAD);
      case 'ISFP':
        return Color(0xFFFFF2BC);
      case 'INTP':
        return Color(0xFFB7FE9E);
      case 'INFJ':
        return Color(0xFF88FFAC);
      case 'ESTJ':
        return Color(0xFF78EBFF);
      case 'INFP':
        return Color(0xFF99F8EC);
      case 'ESTP':
        return Color(0xFFA1E0FF);
      case 'INTJ':
        return Color(0xFF88F4C2);
      case 'ESFJ':
        return Color(0xFFA6BFFE);
      case 'ESFP':
        return Color(0xFFD0B8FF);
      case 'ENTJ':
        return Color(0xFFE289FF);
      case 'ENTP':
        return Color(0xFFE6AAFA);
      case 'ENFJ':
        return Color(0xFFF9AEF7);
      case 'ENFP':
        return Color(0xFFFFA1C6);
      default:
        return Colors.black; // 기본 색상
    }
  }
}
