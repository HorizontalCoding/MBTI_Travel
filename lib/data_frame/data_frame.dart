import 'dart:async'; // Timer 사용
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';

// 전역 변수
int? g_districtCode = 0;
int g_currentPageIndex = 0;
double g_kakaoMapStartLat = 0.0;
double g_kakaoMapStartLng = 0.0;

String g_locationName = '';
String g_mbtiStringValue = '';

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

  List<Map<String, dynamic>> get markerPositions => _markerPositions;
  List<Map<String, dynamic>> get detailedMarkerInfo => _detailedMarkerInfo;

  void updateMarkerPositions(List<Map<String, dynamic>> positions) {
    _markerPositions = positions.map((position) {
      return {
        ...position,
        'contentid': position['contentid'] ?? 'N/A',
        'overview': '아직 해당 관광지에 대한 정보가 없어요.', // 기본 overview 값 추가
      };
    }).toList();

    _detailedMarkerInfo = List<Map<String, dynamic>>.filled(positions.length, {});
    _isDataLoaded = false;
    notifyListeners();
  }

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
      fetchTasks.add(_retryFetch(() => _fetchDataAndImages(i, searchUri, imageEndpoint, overViewEndpoint, apiKey)));
    }

    await Future.wait(fetchTasks);
    _isDataLoaded = true;
    notifyListeners();
  }

  // 재시도 로직을 포함한 API 호출 함수
  Future<void> _retryFetch(Future<void> Function() fetchFunction, {int maxRetries = 3}) async {
    int retryCount = 0;
    while (retryCount < maxRetries) {
      try {
        await fetchFunction().timeout(Duration(seconds: 5)); // 10초 타임아웃
        return; // 성공 시 리턴
      } catch (e) {
        retryCount++;
        print('Error: $e - 재시도 횟수: $retryCount');
        if (retryCount >= maxRetries) {
          print('최대 재시도 횟수를 초과했습니다.');
        }
      }
    }
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
        if (contentId != 'N/A') {
          await Future.wait([
            _retryFetch(() => _fetchImages(contentId, index, imageEndpoint, apiKey)),
            _retryFetch(() => _fetchOverview(contentId, index, overViewEndpoint, apiKey)),
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

    try {
      final imageResponse = await http.get(imageUri);

      if (imageResponse.statusCode == 200) {
        final imageData = json.decode(utf8.decode(imageResponse.bodyBytes));
        final imageItems = imageData['response']['body']['items']['item'];

        if (imageItems is List && imageItems.isNotEmpty) {
          for (int j = 0; j < imageItems.length; j++) {
            final int imgIndex = j + 1;
            try {
              _markerPositions[index].addAll({
                'smallimageurl$imgIndex': imageItems[j]['smallimageurl'] ?? '',
                'originimgurl$imgIndex': imageItems[j]['originimgurl'] ?? '',
              });
            } catch (e) {
              print('Error at index $index: $e');
              continue;
            }
          }
        } else if (imageItems is Map) {
          try {
            _markerPositions[index].addAll({
              'smallimageurl1': imageItems['smallimageurl'] ?? '',
              'originimgurl1': imageItems['originimgurl'] ?? '',
            });
          } catch (e) {
            print('Error at index $index: $e');
          }
        }
      } else {
        print('Error: Image API received status code ${imageResponse.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
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

  String formatNameWithNewline(String name) {
    return name.replaceAll(' ', '\n');
  }

  String _cleanOverview(String overview) {
    overview = overview.replaceAll('<br>', ' ');

    int endIndex = overview.indexOf('다.');
    if (endIndex != -1) {
      return overview.substring(0, endIndex + 2);
    }

    for (int i = 0; i < overview.length; i++) {
      if (overview[i] == '.' && (i + 1 == overview.length || overview[i + 1] == ' ')) {
        return overview.substring(0, i + 1);
      }
    }
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
      'overview': '아직 해당 관광지에 대한 정보가 없어요.',
    };
  }
}