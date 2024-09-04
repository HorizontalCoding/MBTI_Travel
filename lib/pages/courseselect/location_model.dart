import 'package:flutter/foundation.dart';

class LocationModel with ChangeNotifier {
  String _selectedLocation = '';
  int? _districtCode;

  // 현재 선택된 위치 이름과 시군구 번호를 반환하는 getter
  String get selectedLocation => _selectedLocation;
  int? get districtCode => _districtCode;

  // 위치 이름을 설정하는 메서드
  void setLocation(String location)
  {
    _selectedLocation = location;

    // print("전역적으로 저장한 Location_model (location_model.dart): $_selectedLocation");
    notifyListeners(); // 상태가 변경되었음을 알림
  }

  // 시군구 번호를 설정하는 메서드
  void setDistrictCode(int code)
  {
    _districtCode = code;

    // print("전역적으로 저장한 District Code (location_model.dart): $_districtCode");
    notifyListeners(); // 상태가 변경되었음을 알림
  }
}
