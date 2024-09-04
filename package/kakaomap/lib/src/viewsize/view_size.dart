// view_size 클래스
// 333.0 (Width)
// 597.0 (height)

/*class KakaoViewSize {
  static double cotextWidth = 0.0;
  static double contextHeight = 0.0;

  static double UpdateSizeWidth(double deviceWidth, double desiredWidth)
  {
    double kakaoMapViewWidth = (deviceWidth * (desiredWidth / deviceWidth));
    cotextWidth = (deviceWidth * (desiredWidth / deviceWidth));
    return kakaoMapViewWidth;
  }

  static double UpdateSizeHeight(double deviceHight, double desiredHight)
  {
    double kakaoMapViewHeight = (deviceHight * desiredHight);
    contextHeight = kakaoMapViewHeight;
    return kakaoMapViewHeight;
  }
}*/

import 'package:flutter/material.dart';

class KakaoViewSize with ChangeNotifier {
  double _cotextWidth = 0.0;
  double _contextHeight = 0.0;

  double get cotextWidth => _cotextWidth;
  double get contextHeight => _contextHeight;

  void updateSizeWidth(double deviceWidth, double desiredWidth) {
    _cotextWidth = (deviceWidth * (desiredWidth / deviceWidth));
    notifyListeners(); // 상태가 변경되었음을 알림
  }

  void updateSizeHeight(double deviceHeight, double desiredHeight) {
    _contextHeight = (deviceHeight * desiredHeight);
    notifyListeners(); // 상태가 변경되었음을 알림
  }
}
