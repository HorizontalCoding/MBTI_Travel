import 'package:url_launcher/url_launcher.dart';

Future<void> openKakaoMap(List<Map<String, dynamic>> _markerPositions, int targetId) async {
  // targetId에 해당하는 마커 찾기
  Map<String, dynamic>? marker;
  for (var item in _markerPositions) {
    if (item['id'] == targetId) {
      marker = item;
      break;
    }
  }

  if (marker != null) {
    final lat = marker['lat'];
    final lng = marker['lng'];
    final name = marker['name'];

    const String kakaoMapPackageName = 'net.daum.android.map';

    // Kakao Map URL 생성
    final Uri url = Uri.parse('kakaomap://search?q=$name&p=$lat,$lng');
    final Uri playStoreUrl = Uri.parse('https://play.google.com/store/apps/details?id=$kakaoMapPackageName');

    print("함수 호출: $url");

    // Kakao Map URL 열기
    if (await canLaunchUrl(url))
    {
      await launchUrl(url);
      print("(flutter 프레임워크 제한) -> 만약에 삼성 디바이스 중에 URL 스키마가 허가가 되는 기기이면, 해당 좌표로 카카오맵 실행");
    }
    else
    {
      await launchUrl(playStoreUrl);
      print("(flutter 프레임워크 제한) -> 만약에 삼성 디바이스 중에 URL 스키마가 허가가 안되는 기기이면, web으로 빠져라. 또는 카카오맵이 설치X라면,");
      throw 'Could not launch $playStoreUrl';
    }
  }
  else
  {
    print("id가 $targetId인 마커가 없습니다.");
  }
}

Future<void> openKakaoMapAtCoordinates(int targetId, List<Map<String, dynamic>> _markerPositions) async
{
  // targetId에 해당하는 마커 찾기
  Map<String, dynamic>? marker;
  for (var item in _markerPositions) {
    if (item['id'] == targetId) {
      marker = item;
      break;
    }
  }

  if (marker != null) {
    final lat = marker['lat'];
    final lng = marker['lng'];
    final name = marker['name'];

    // Kakao Map URL 생성
    const String kakaoMapPackageName = 'net.daum.android.map';

    final Uri url = Uri.parse('kakaomap://search?q=$name&p=$lat,$lng');
    final Uri playStoreUrl = Uri.parse('https://play.google.com/store/apps/details?id=$kakaoMapPackageName');

    print("함수 호출: $url");

    // Kakao Map URL 열기
    if (await canLaunchUrl(url))
    {
      await launchUrl(url);
      print("(flutter 프레임워크 제한) -> 만약에 삼성 디바이스 중에 URL 스키마가 허가가 되는 기기이면, 해당 좌표로 카카오맵 실행");
    }
    else
    {
      await launchUrl(playStoreUrl);
      print("(flutter 프레임워크 제한) -> 만약에 삼성 디바이스 중에 URL 스키마가 허가가 안되는 기기이면, web으로 빠져라. 또는 카카오맵이 설치X라면,");
      throw 'Could not launch $playStoreUrl';
    }
  }
  else
  {
    print("id가 $targetId인 마커가 없습니다.");
  }
}

// "더보기" URL 카카오맵 오픈 함수
Future<void> openKakaoMapByLatLng(String name, double lat, double lng) async
{
  const String kakaoMapPackageName = 'net.daum.android.map';

  // Kakao Map URL 생성
  final Uri url = Uri.parse('kakaomap://search?q=$name&p=$lat,$lng');
  final Uri playStoreUrl = Uri.parse('https://play.google.com/store/apps/details?id=$kakaoMapPackageName');

  print("Kakao Map 호출 URL: $url");

  // Kakao Map URL 열기
  if (await canLaunchUrl(url))
  {
    await launchUrl(url);
    print("(flutter 프레임워크 제한) -> 삼성 디바이스에서 카카오맵 앱으로 실행");
  }
  else
  {
    await launchUrl(playStoreUrl);
    print("(flutter 프레임워크 제한) -> 카카오맵 앱이 없거나 URL 스키마가 허용되지 않으면, 웹 브라우저로 실행");
    throw 'Could not launch $playStoreUrl';
  }
}