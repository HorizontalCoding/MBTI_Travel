import 'package:flutter/material.dart';

class MapModel extends ChangeNotifier {
  double lat = 0.0;
  double lng = 0.0;
  int zoomLevel = 0;

  // 초기화 값을 받는 생성자
  MapModel({required this.lat, required this.lng, this.zoomLevel = 0});

  // 위치 및 줌 레벨 업데이트 메서드
  void updateCoordinates(double newLat, double newLng, int newZoomLevel) {
    lat = newLat;
    lng = newLng;
    zoomLevel = newZoomLevel;
    notifyListeners(); // 상태 변경을 알림
  }
}