import 'dart:async'; // Timer 사용
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'default_images.dart';

// 전역 변수
int? g_districtCode = 0;
int g_currentPageIndex = 0;
double g_kakaoMapStartLat = 0.0;
double g_kakaoMapStartLng = 0.0;

// selectedButtonIndex
int selectedButtonIndex = 1;

String g_locationName = '';
String g_mbtiStringValue = '';

late final String tourApiKey;
late final String kakaoMapKey;
late final String tourApi_Encoding_key;

late final String PROD_URL;
late final String DEV_URL;

class MarkerPositionsModel with ChangeNotifier {
  List<Map<String, dynamic>> _markerPositions = [];
  List<Map<String, dynamic>> _results_Places = [];
  List<Map<String, dynamic>> _results_Activity = [];
  List<Map<String, dynamic>> _results_Food = [];
  List<Map<String, dynamic>> _results_Hostel = [];
  List<Map<String, dynamic>> _results_Festival = []; // _results_Festival 추가
  List<Map<String, dynamic>> _detailedMarkerInfo = [];
  bool _isDataLoaded = false;

  bool get isDataLoaded => _isDataLoaded;

  List<Map<String, dynamic>> get markerPositions => _markerPositions;
  List<Map<String, dynamic>> get results_Places => _results_Places;
  List<Map<String, dynamic>> get results_Activity => _results_Activity;
  List<Map<String, dynamic>> get results_Food => _results_Food;
  List<Map<String, dynamic>> get results_Hostel => _results_Hostel;
  List<Map<String, dynamic>> get results_Festival => _results_Festival; // getter 추가
  List<Map<String, dynamic>> get detailedMarkerInfo => _detailedMarkerInfo;

  // MarkerPositions 업데이트
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

  // Places 업데이트
  void updateResultsPlaces(List<Map<String, dynamic>> places) {
    _results_Places = places.map((place) {
      return {
        ...place,
        'contentid': place['contentid'] ?? 'N/A',
        'overview': '아직 해당 장소에 대한 정보가 없어요.',
      };
    }).toList();

    _isDataLoaded = false;
    notifyListeners();
  }

  // Activity 업데이트
  void updateResultsActivity(List<Map<String, dynamic>> activities) {
    _results_Activity = activities.map((activity) {
      return {
        ...activity,
        'contentid': activity['contentid'] ?? 'N/A',
        'overview': '아직 해당 활동에 대한 정보가 없어요.',
      };
    }).toList();

    _isDataLoaded = false;
    notifyListeners();
  }

  // Food 업데이트
  void updateResultsFood(List<Map<String, dynamic>> foodItems) {
    _results_Food = foodItems.map((food) {
      return {
        ...food,
        'contentid': food['contentid'] ?? 'N/A',
        'overview': '아직 해당 음식에 대한 정보가 없어요.',
      };
    }).toList();

    _isDataLoaded = false;
    notifyListeners();
  }

  // Hostel 업데이트
  void updateResultsHostel(List<Map<String, dynamic>> hostels) {
    _results_Hostel = hostels.map((hostel) {
      return {
        ...hostel,
        'contentid': hostel['contentid'] ?? 'N/A',
        'overview': '아직 해당 숙소에 대한 정보가 없어요.',
      };
    }).toList();

    _isDataLoaded = false;
    notifyListeners();
  }

  // Fetch and Update Data
  Future<void> fetchAndUpdateData(String apiKey) async {
    if (_isDataLoaded) {
      print("데이터가 이미 로드되었습니다.");
      return; // 데이터가 이미 로드된 경우 함수 종료
    }

    final String searchEndpoint = 'http://apis.data.go.kr/B551011/KorService1/searchKeyword1';
    final String imageEndpoint = 'http://apis.data.go.kr/B551011/KorService1/detailImage1';
    final String overViewEndpoint = 'http://apis.data.go.kr/B551011/KorService1/detailCommon1';

    List<Future<void>> fetchTasks = [];

    // MarkerPositions에 대한 데이터 가져오기
    for (int i = 0; i < _markerPositions.length; i++) {
      final String keyword = _markerPositions[i]['tourkey'] ?? 'null';

      if (keyword == 'N/A') {
        print('Skipping marker at index $i due to "N/A" value.');
        continue;
      }

      final Uri searchUri = _buildSearchUri(searchEndpoint, apiKey, keyword);
      fetchTasks.add(_retryFetch(() => _fetchDataAndImages(i, searchUri, imageEndpoint, overViewEndpoint, apiKey, "marker")));
    }

    // Places에 대한 데이터 가져오기
    for (int i = 0; i < _results_Places.length; i++) {
      final String keyword = _results_Places[i]['tourkey'] ?? 'null';

      if (keyword == 'N/A') {
        print('Skipping marker at index $i due to "N/A" value.');
        continue;
      }

      final Uri searchUri = _buildSearchUri(searchEndpoint, apiKey, keyword);
      fetchTasks.add(_retryFetch(() => _fetchDataAndImages(i, searchUri, imageEndpoint, overViewEndpoint, apiKey, "places")));
    }

    // Activity에 대한 데이터 가져오기
    for (int i = 0; i < _results_Activity.length; i++) {
      final String keyword = _results_Activity[i]['tourkey'] ?? 'null';

      if (keyword == 'N/A') {
        print('Skipping marker at index $i due to "N/A" value.');
        continue;
      }

      final Uri searchUri = _buildSearchUri(searchEndpoint, apiKey, keyword);
      fetchTasks.add(_retryFetch(() => _fetchDataAndImages(i, searchUri, imageEndpoint, overViewEndpoint, apiKey, "activity")));
    }

    // Food에 대한 데이터 가져오기
    for (int i = 0; i < _results_Food.length; i++) {
      final String keyword = _results_Food[i]['tourkey'] ?? 'null';

      if (keyword == 'N/A') {
        print('Skipping marker at index $i due to "N/A" value.');
        continue;
      }

      final Uri searchUri = _buildSearchUri(searchEndpoint, apiKey, keyword);
      fetchTasks.add(_retryFetch(() => _fetchDataAndImages(i, searchUri, imageEndpoint, overViewEndpoint, apiKey, "food")));
    }

    // Hostel에 대한 데이터 가져오기
    for (int i = 0; i < _results_Hostel.length; i++) {
      final String keyword = _results_Hostel[i]['tourkey'] ?? 'null';

      if (keyword == 'N/A') {
        print('Skipping marker at index $i due to "N/A" value.');
        continue;
      }

      final Uri searchUri = _buildSearchUri(searchEndpoint, apiKey, keyword);
      fetchTasks.add(_retryFetch(() => _fetchDataAndImages(i, searchUri, imageEndpoint, overViewEndpoint, apiKey, "hostel")));
    }

    // Festival 데이터 가져오기
    fetchTasks.add(fetchAndUpdateFestivalData(apiKey, overViewEndpoint));

    // 모든 fetch 작업이 끝날 때까지 기다린 후 _isDataLoaded를 true로 설정
    try {
      await Future.wait(fetchTasks);
    } catch (e) {
      print('Error during fetch tasks: $e');
    } finally {
      _isDataLoaded = true; // 모든 데이터 처리가 완료된 후에야 true로 설정
      print("데이터 로드 완료");
      notifyListeners();
    }
  }

  Uri _buildSearchUri(String searchEndpoint, String apiKey, String keyword) {
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

    return Uri.parse(searchEndpoint).replace(queryParameters: searchParams);
  }

  Future<void> _retryFetch(Future<void> Function() fetchFunction, {int maxRetries = 3}) async {
    int retryCount = 0;
    while (retryCount < maxRetries) {
      try {
        await fetchFunction().timeout(Duration(seconds: 5));
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

  Future<void> _fetchDataAndImages(int index, Uri searchUri, String imageEndpoint, String overViewEndpoint, String apiKey, String category) async {
    try {
      final searchResponse = await http.get(searchUri);

      if (searchResponse.statusCode == 200) {
        final searchData = json.decode(utf8.decode(searchResponse.bodyBytes));
        final bodyData = searchData['response']['body'];

        if (bodyData == null || bodyData['items'] == "" || bodyData['totalCount'] == 0) {
          print('Skipping index $index due to invalid bodyData or no results found.');
          return;
        }

        final items = bodyData['items']['item'];

        if (items == null || items == "" || (items is List && items.isEmpty)) {
          print('Skipping contentId for index $index due to no valid data in body.');
          return;
        }

        if (items is List && items.isNotEmpty) {
          _detailedMarkerInfo[index] = _extractMarkerInfo(items[0]);
          _addDataToCategory(index, _detailedMarkerInfo[index], category);
        } else if (items is Map) {
          _detailedMarkerInfo[index] = _extractMarkerInfo(items);
          _addDataToCategory(index, _detailedMarkerInfo[index], category);
        } else {
          _addEmptyDataToCategory(index, category);
        }

        final String contentId = _detailedMarkerInfo[index]['contentid'] ?? 'N/A';

        if (contentId != 'N/A' && contentId.isNotEmpty) {
          await Future.wait([
            _retryFetch(() => _fetchImages(contentId, index, imageEndpoint, apiKey, category)),
            _retryFetch(() => _fetchOverview(contentId, index, overViewEndpoint, apiKey, category)),
          ]);
        } else {
          print('Skipping image and overview fetch for index $index due to empty or invalid contentId.');
        }
      } else {
        print('Error: Search API received status code ${searchResponse.statusCode}');
      }
    } catch (e) {
      print('ErrorA for index $index: $e');
    }
  }

  Future<void> _fetchImages(String contentId, int index, String imageEndpoint, String apiKey, String category) async {
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
        final body = json.decode(utf8.decode(imageResponse.bodyBytes));
        final responseBody = body['response']['body'];

        if (responseBody == null || responseBody['items'] == "" || responseBody['items']['item'] == null) {
          print('Skipping contentId $contentId, index $index due to no valid image data in body');
          return;
        }

        final dynamic imageItems = responseBody['items']['item'];

        if (imageItems is List && imageItems.isNotEmpty) {
          for (int j = 0; j < imageItems.length; j++) {
            final int imgIndex = j + 1;
            final dynamic imageItem = imageItems[j];

            if (imageItem is Map<String, dynamic>) {
              final smallImageUrl = imageItem['smallimageurl'];
              final originImageUrl = imageItem['originimgurl'];

              if (smallImageUrl is String && originImageUrl is String && smallImageUrl.isNotEmpty && originImageUrl.isNotEmpty) {
                _addImageToCategory(index, imageItem, imgIndex, category);
              } else {
                print('Invalid image URLs at index $index, imgIndex $imgIndex: smallimageurl=$smallImageUrl, originimgurl=$originImageUrl');
              }
            }
          }
        } else if (imageItems is Map<String, dynamic>) {
          final smallImageUrl = imageItems['smallimageurl'];
          final originImageUrl = imageItems['originimgurl'];

          if (smallImageUrl is String && originImageUrl is String && smallImageUrl.isNotEmpty && originImageUrl.isNotEmpty) {
            _addImageToCategory(index, imageItems, 1, category);
          } else {
            print('Invalid image URLs at index $index, single item: smallimageurl=$smallImageUrl, originimgurl=$originImageUrl');
          }
        }
      } else {
        print('Error: Image API received status code ${imageResponse.statusCode}');
      }
    } catch (e) {
      print('_fetchImages Error for contentId $contentId, index $index: $e');
    }
  }

  Future<void> _fetchOverview(String contentId, int index, String overViewEndpoint, String apiKey, String category) async {
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
          _addOverviewToCategory(index, overviewItem[0], category);
        } else if (overviewItem is Map && overviewItem.isNotEmpty) {
          _addOverviewToCategory(index, (overviewItem as Map<dynamic, dynamic>).cast<String, dynamic>(), category);
        }
      } else {
        print('Error: Overview API received status code ${overviewResponse.statusCode}');
      }
    } catch (e) {
      print('Error fetching overview: $e');
    }
  }

  // 축제 데이터를 가져와 _results_Festival에 추가하는 함수
  Future<void> fetchAndUpdateFestivalData(String apiKey, String overViewEndpoint) async {
    final String festivalEndpoint = 'http://apis.data.go.kr/B551011/KorService1/areaBasedList1';
    final Map<String, String> festivalParams = {
      'ServiceKey': apiKey,
      'numOfRows': '100',
      'pageNo': '1',
      'MobileOS': 'ETC',
      'MobileApp': 'MBTI',
      'contentTypeId': '15', // 축제 contentTypeId는 15로 고정
      'areaCode': '32',
      'sigunguCode': g_districtCode?.toString() ?? '',
      'ListYN': 'Y',
      '_type': 'json',
      'arrange': 'E',
    };

    final Uri festivalUri = Uri.parse(festivalEndpoint).replace(queryParameters: festivalParams);

    try {
      final response = await http.get(festivalUri);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final items = data['response']['body']['items']['item'];

        if (items is List && items.isNotEmpty) {
          _results_Festival = items.asMap().entries.map((entry) {
            int index = entry.key;
            var item = entry.value;

            final String firstImageUrl = (item['firstimage'] != null && item['firstimage'].isNotEmpty)
                ? item['firstimage']
                : (g_districtCode != null && defaultImages.containsKey(g_districtCode)
                ? defaultImages[g_districtCode]!
                : '');

            return {
              'id': index + 1,
              'name': item['title'] ?? '',
              'contentid': item['contentid'] ?? 'N/A',
              'firstimage': firstImageUrl,
              'firstimage2': item['firstimage2'] ?? '',
              'lng': double.tryParse(item['mapx']?.toString() ?? '') ?? 0.0,
              'lat': double.tryParse(item['mapy']?.toString() ?? '') ?? 0.0,
              'overview': '아직 해당 축제에 대한 정보가 없어요.',
            };
          }).toList();

          notifyListeners();

          for (int i = 0; i < _results_Festival.length; i++) {
            final String contentId = _results_Festival[i]['contentid'] ?? 'N/A';
            if (contentId != 'N/A') {
              await _retryFetch(() => _fetchOverview(contentId, i, overViewEndpoint, apiKey, "festival"));
            }
          }
        }
      } else {
        print('Error: Festival API 응답 상태 코드 ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _addDataToCategory(int index, Map<String, dynamic> data, String category) {
    if (category == 'marker') {
      _markerPositions[index].addAll(data);
    } else if (category == 'places') {
      _results_Places[index].addAll(data);
    } else if (category == 'activity') {
      _results_Activity[index].addAll(data);
    } else if (category == 'food') {
      _results_Food[index].addAll(data);
    } else if (category == 'hostel') {
      _results_Hostel[index].addAll(data);
    } else if (category == 'festival') {
      _results_Festival[index].addAll(data);
    }
  }

  void _addEmptyDataToCategory(int index, String category) {
    if (category == 'marker') {
      _markerPositions[index]['contentid'] = 'N/A';
    } else if (category == 'places') {
      _results_Places[index]['contentid'] = 'N/A';
    } else if (category == 'activity') {
      _results_Activity[index]['contentid'] = 'N/A';
    } else if (category == 'food') {
      _results_Food[index]['contentid'] = 'N/A';
    } else if (category == 'hostel') {
      _results_Hostel[index]['contentid'] = 'N/A';
    } else if (category == 'festival') {
      _results_Festival[index]['contentid'] = 'N/A';
    }
  }

  void _addImageToCategory(int index, Map<String, dynamic> imageItem, int imgIndex, String category) {
    if (category == 'marker') {
      _markerPositions[index].addAll({
        'smallimageurl$imgIndex': imageItem['smallimageurl'] ?? '',
        'originimgurl$imgIndex': imageItem['originimgurl'] ?? '',
      });
    } else if (category == 'places') {
      _results_Places[index].addAll({
        'smallimageurl$imgIndex': imageItem['smallimageurl'] ?? '',
        'originimgurl$imgIndex': imageItem['originimgurl'] ?? '',
      });
    } else if (category == 'activity') {
      _results_Activity[index].addAll({
        'smallimageurl$imgIndex': imageItem['smallimageurl'] ?? '',
        'originimgurl$imgIndex': imageItem['originimgurl'] ?? '',
      });
    } else if (category == 'food') {
      _results_Food[index].addAll({
        'smallimageurl$imgIndex': imageItem['smallimageurl'] ?? '',
        'originimgurl$imgIndex': imageItem['originimgurl'] ?? '',
      });
    } else if (category == 'hostel') {
      _results_Hostel[index].addAll({
        'smallimageurl$imgIndex': imageItem['smallimageurl'] ?? '',
        'originimgurl$imgIndex': imageItem['originimgurl'] ?? '',
      });
    } else if (category == 'festival') {
      _results_Festival[index].addAll({
        'smallimageurl$imgIndex': imageItem['smallimageurl'] ?? '',
        'originimgurl$imgIndex': imageItem['originimgurl'] ?? '',
      });
    }
  }

  void _addOverviewToCategory(int index, Map<String, dynamic> overviewItem, String category) {
    String cleanedOverview = _cleanOverview(overviewItem['overview'] ?? '아직 해당 정보가 없어요.');
    if (category == 'marker') {
      _markerPositions[index]['overview'] = cleanedOverview;
    } else if (category == 'places') {
      _results_Places[index]['overview'] = cleanedOverview;
    } else if (category == 'activity') {
      _results_Activity[index]['overview'] = cleanedOverview;
    } else if (category == 'food') {
      _results_Food[index]['overview'] = cleanedOverview;
    } else if (category == 'hostel') {
      _results_Hostel[index]['overview'] = cleanedOverview;
    } else if (category == 'festival') {
      _results_Festival[index]['overview'] = cleanedOverview;
    }
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
