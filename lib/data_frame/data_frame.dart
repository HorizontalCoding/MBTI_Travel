import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
// import 'dart:io';

// =====================================================================
// 6차 업데이트 <br> 태그제거 + 마침표 + 정규표현식(1. 2. 3. 예외처리)
// =====================================================================

// 전역 변수
// 카카오 시작 좌표, 지역 번호
int? g_districtCode = 0;
int g_currentPageIndex = 0; // 전역 변수로 현재 페이지 인덱스를 유지
double g_kakaoMapStartLat = 0.0;
double g_kakaoMapStartLng = 0.0;

String g_locationName = '';
String g_mbtiStringValue = '';

// API 키
late final String tourApiKey;
late final String kakaoMapKey;
late final String tourApi_Encoding_key;

late final String PROD_URL;
late final String DEV_URL;
class MarkerPositionsModel with ChangeNotifier {
  List<Map<String, dynamic>> _markerPositions = [];
  List<Map<String, dynamic>> _detailedMarkerInfo = [];
  bool _isDataLoaded = false;

  bool get isDataLoaded => _isDataLoaded;

  // Getter를 사용하여 데이터에 접근
  List<Map<String, dynamic>> get markerPositions => _markerPositions;
  List<Map<String, dynamic>> get detailedMarkerInfo => _detailedMarkerInfo;

  // 데이터를 업데이트하고 변경 알림
  void updateMarkerPositions(List<Map<String, dynamic>> positions) {
    _markerPositions = positions.map((position)
    {
      return {
        ...position,
        'contentid': position['contentid'] ?? 'N/A',
        'overview': '아직 해당 관광지에 대한 정보가 없어요.', // 기본 overview 값 추가
      };
    }).toList();

    _detailedMarkerInfo = List<Map<String, dynamic>>.filled(positions.length, {});
    _isDataLoaded = false;  // 데이터가 새로 업데이트 되면 로딩 상태로 전환
    notifyListeners();
  }

  // 각 markerPosition의 'keyword'를 기반으로 API 호출 및 여러 필드 업데이트
  Future<void> fetchAndUpdateData(String apiKey) async {
    final String searchEndpoint = 'http://api.visitkorea.or.kr/openapi/service/rest/KorService/searchKeyword';
    final String imageEndpoint = 'http://apis.data.go.kr/B551011/KorService1/detailImage1';
    final String overViewEndpoint = 'http://apis.data.go.kr/B551011/KorService1/detailCommon1';

    List<Future<void>> fetchTasks = [];

    for (int i = 0; i < _markerPositions.length; i++) {
      final String keyword = _markerPositions[i]['tourkey'] ?? 'null';

      final Map<String, String> searchParams = {
        'ServiceKey': apiKey,
        'numOfRows': '1',
        'pageNo': '1',
        'MobileOS': 'ETC',
        'MobileApp': 'MBTI',
        'keyword': keyword,
        'areaCode': '32',
        'sigunguCode': g_districtCode?.toString() ?? '',
        '_type': 'json',
        'arrange': 'E',
      };

      final Uri searchUri = Uri.parse(searchEndpoint).replace(queryParameters: searchParams);
      fetchTasks.add(_fetchDataAndImages(i, searchUri, imageEndpoint, overViewEndpoint, apiKey));
    }

    // 모든 데이터를 가져온 후에만 UI를 업데이트
    await Future.wait(fetchTasks);
    _isDataLoaded = true;  // 데이터 로드 완료 후 상태 갱신
    notifyListeners();
  }

  Future<void> _fetchDataAndImages(int index, Uri searchUri, String imageEndpoint, String overViewEndpoint, String apiKey) async {
    try {
      final searchResponse = await http.get(searchUri);

      if (searchResponse.statusCode == 200) {
        final searchData = json.decode(utf8.decode(searchResponse.bodyBytes));
        final items = searchData['response']['body']['items']['item'];

        if (items is List && items.isNotEmpty) {
          _detailedMarkerInfo[index] = _extractMarkerInfo(items[0]);
          _markerPositions[index].addAll(_detailedMarkerInfo[index]);
        } else if (items is Map) {
          _detailedMarkerInfo[index] = _extractMarkerInfo(items);
          _markerPositions[index].addAll(_detailedMarkerInfo[index]);
        } else {
          _markerPositions[index]['contentid'] = 'N/A';
        }

        final String contentId = _detailedMarkerInfo[index]['contentid'] ?? 'N/A';
        // 병렬 처리(Future.wait) 사용(_fetchImages, _fetchOverview 를 병렬로 처리하는 코드)
        if (contentId != 'N/A') {
          await Future.wait([
            _fetchImages(contentId, index, imageEndpoint, apiKey),
            _fetchOverview(contentId, index, overViewEndpoint, apiKey),
          ]);
        }
      } else {
        print('Error: Search API received status code ${searchResponse.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchImages(String contentId, int index, String imageEndpoint, String apiKey) async {
    final Map<String, String> imageParams = {
      'serviceKey': apiKey,
      'numOfRows': '10',
      'pageNo': '1',
      'MobileOS': 'ETC',
      'MobileApp': 'MBTI',
      'contentId': contentId,
      'imageYN': 'Y',
      'subImageYN': 'Y',
      '_type': 'json',
    };

    final Uri imageUri = Uri.parse(imageEndpoint).replace(queryParameters: imageParams);

    final imageResponse = await http.get(imageUri);

    if (imageResponse.statusCode == 200) {
      final imageData = json.decode(utf8.decode(imageResponse.bodyBytes));
      final imageItems = imageData['response']['body']['items']['item'];

      if (imageItems is List && imageItems.isNotEmpty) {
        for (int j = 0; j < imageItems.length; j++) {
          final int imgIndex = j + 1;
          _markerPositions[index].addAll({
            'smallimageurl$imgIndex': imageItems[j]['smallimageurl'] ?? '',
            'originimgurl$imgIndex': imageItems[j]['originimgurl'] ?? '',
          });
        }
      } else if (imageItems is Map) {
        _markerPositions[index].addAll({
          'smallimageurl1': imageItems['smallimageurl'] ?? '',
          'originimgurl1': imageItems['originimgurl'] ?? '',
        });
      }
    } else {
      print('Error: Image API received status code ${imageResponse.statusCode}');
    }
  }

  Future<void> _fetchOverview(String contentId, int index, String overViewEndpoint, String apiKey) async {
    final Map<String, String> overviewParams = {
      'serviceKey': apiKey,
      'contentId': contentId,
      'defaultYN': 'N',
      'addrinfoYN': 'N',
      'overviewYN': 'Y',
      'MobileOS': 'ETC',
      'MobileApp': 'MBTI',
      '_type': 'json',
    };

    final Uri overviewUri = Uri.parse(overViewEndpoint).replace(queryParameters: overviewParams);

    try {
      final overviewResponse = await http.get(overviewUri);

      if (overviewResponse.statusCode == 200) {
        final overviewData = json.decode(utf8.decode(overviewResponse.bodyBytes));
        final overviewItem = overviewData['response']['body']['items']['item'];

        if (overviewItem is List && overviewItem.isNotEmpty) {
          _markerPositions[index]['overview'] = _cleanOverview(overviewItem[0]['overview'] ?? '아직 해당 관광지에 대한 정보가 없어요.');
        } else if (overviewItem is Map && overviewItem.isNotEmpty) {
          _markerPositions[index]['overview'] = _cleanOverview(overviewItem['overview'] ?? '아직 해당 관광지에 대한 정보가 없어요.');
        }
      } else {
        print('Error: Overview API received status code ${overviewResponse.statusCode}');
      }
    } catch (e) {
      print('Error fetching overview: $e');
    }
  }

  // 'name' 필드에서 스페이스바를 줄바꿈으로 변환하는 함수
  String formatNameWithNewline(String name)
  {
    return name.replaceAll(' ', '\n');
  }



  String _cleanOverview(String overview)
  {
    // <br> 태그를 공백 문자로 대체
    // 설명: HTML 문서에서 줄바꿈을 나타내는 <br> 태그를 공백으로 바꿉니다.
    overview = overview.replaceAll('<br>', ' ');

    // 문자열의 각 문자를 순차적으로 검사합니다.
    for (int i = 0; i < overview.length; i++)
    {
      // 마침표를 찾았을 때
      if (overview[i] == '.')
      {
        // 1. 마침표가 문자열의 마지막 문자이거나
        // 2. 마침표 바로 뒤에 공백이 있는 경우
        // 위 두 가지 조건 중 하나라도 만족하면 그 위치에서 문자열을 잘라냅니다.
        if (i + 1 == overview.length || overview[i + 1] == ' ')
        {
          // 문자열을 마침표 뒤까지 포함하여 잘라서 반환합니다.
          return overview.substring(0, i + 1);
        }
      }
    }

    // 만약 마침표가 없거나 잘라낼 필요가 없으면
    // 원래의 전체 문자열을 그대로 반환합니다.
    return overview;
  }


  Map<String, dynamic> _extractMarkerInfo(dynamic item) {
    return {
      'addr1': item['addr1'] ?? '',
      'addr2': item['addr2'] ?? '',
      'areacode': item['areacode'] ?? '',
      'booktour': item['booktour'] ?? '',
      'cat1': item['cat1'] ?? '',
      'cat2': item['cat2'] ?? '',
      'cat3': item['cat3'] ?? '',
      'contentid': item['contentid'] ?? 'N/A',
      'contenttypeid': item['contenttypeid'] ?? '',
      'createdtime': item['createdtime'] ?? '',
      'firstimage': item['firstimage'] ?? '',
      'firstimage2': item['firstimage2'] ?? '',
      'cpyrhtDivCd': item['cpyrhtDivCd'] ?? '',
      'mapx': item['mapx'] ?? '',
      'mapy': item['mapy'] ?? '',
      'mlevel': item['mlevel'] ?? '',
      'modifiedtime': item['modifiedtime'] ?? '',
      'sigungucode': item['sigungucode'] ?? '',
      'tel': item['tel'] ?? '',
      'title': item['title'] ?? '',
      'overview': '아직 해당 관광지에 대한 정보가 없어요.', // 기본 overview 값 추가
    };
  }
}






