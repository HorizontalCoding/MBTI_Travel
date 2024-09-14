import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_swipeable_stack.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'locationexplain_copy_widget.dart' show LocationexplainCopyWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Kakao Plugin(헤더파일)
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

// 새로 만든 플러그인
import 'package:kakaomap_webview/src/kakao_view_Markers.dart';
import 'package:kakaomap_webview/src/url_launcher_service.dart';
import 'package:mbtitravel/function_manager.dart';
import 'package:mbtitravel/data_frame/data_frame.dart';

import 'map_model.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';

class LocationexplainCopyModel extends ChangeNotifier
{
  final unfocusNode = FocusNode();
  TabController? tabBarController;
  late PageController pageController;
  late ScrollController listViewController;
  int currentIndex = 0; // 현재 페이지 인덱스를 저장

  // TextField 관련 필드
  TextEditingController? textController;
  FocusNode? textFieldFocusNode;

  // 초기화 시 초기 페이지 설정
  LocationexplainCopyModel({this.currentIndex = 0})
  {
    pageController = PageController(initialPage: currentIndex);
    listViewController = ScrollController();
  }

  // 새로운 PageController로 초기화
  void updatePageControllerWithNewIndex(int newIndex)
  {
    // 기존 PageController 해제
    pageController.dispose();

    // 새로운 PageController로 초기화 (newIndex로 설정)
    pageController = PageController(initialPage: newIndex);

    // 현재 인덱스를 업데이트
    currentIndex = newIndex;

    // UI 갱신 알림
    notifyListeners();
    print("갱신완료!");
  }

  void updateScrollControllerWithNewIndex(int newIndex)
  {
    // 각 아이템의 높이 (예시: 148.0)
    double itemHeight = 148.0;

    // 새로운 인덱스에 맞는 스크롤 위치 계산
    double offset = newIndex * itemHeight;

    // 기존 ScrollController 해제
    listViewController.dispose();

    if(offset < 592.0)
    {
      // 새로운 ScrollController로 초기화
      listViewController = ScrollController(initialScrollOffset: offset);
      print("업데이트");
    }
    else
    {
      listViewController = ScrollController(initialScrollOffset: 444.0);
      print("444.0 업데이트");
    }

    // 현재 인덱스를 업데이트
    currentIndex = newIndex;

    // UI 갱신 알림
    notifyListeners();
    print("리스트뷰 컨트롤러 갱신 완료! offset: $offset");
  }



  @override
  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();
    pageController.dispose(); // PageController 해제
    textController?.dispose(); // TextController 해제
    textFieldFocusNode?.dispose(); // TextFieldFocusNode 해제
    listViewController.dispose();
    super.dispose(); // 부모 클래스의 dispose 메서드 호출
  }
}

// 카카오 맵 함수
class KakaoMap extends StatefulWidget {
  const KakaoMap({super.key});

  @override
  State<KakaoMap> createState() => _KakaoMapState();
}

class _KakaoMapState extends State<KakaoMap> {
  late WebViewController _mapController;

  @override
  Widget build(BuildContext context) {
    final markerPositionsModel = Provider.of<MarkerPositionsModel>(context);
    final mapModel = Provider.of<MapModel>(context);
    final kakaoViewSize = Provider.of<KakaoViewSize>(context);

    // getter를 통해 리스트에 접근
    final markerPositions = markerPositionsModel.markerPositions;

    // MapModel에서 값을 가져옴
    double _lat = mapModel.lat;
    double _lng = mapModel.lng;
    int _zoomLevel = mapModel.zoomLevel;

    kakaoViewSize.updateSizeWidth(MediaQuery.of(context).size.width, 350.0);
    kakaoViewSize.updateSizeHeight(MediaQuery.of(context).size.height, 0.74);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          KakaoMapView(
            width: kakaoViewSize.cotextWidth,
            height: kakaoViewSize.contextHeight,
            kakaoMapKey: kakaoMapKey,
            lat: _lat,
            lng: _lng,
            zoomLevel: _zoomLevel,
            showMapTypeControl: true,
            showZoomControl: true,
            draggableMarker: false,
            mapController: (controller) => _mapController = controller,
            viewAddMakers: VIEW_MAKER_SCRIPT(markerPositions),
            customOverlayStyle: CUSTOM_OVERLAY_STYLE_SCRIPT(),
            OpenKakaoMap: true,
          ),
        ],
      ),
    );
  }
}
