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
// 2024-07-18 :  locationexplain_copy_model.dart에 카카오 맵 코드 통합 - 정형준.
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ## 새로 만든 플러그인 ##
import 'package:kakaomap_webview/src/kakao_view_Markers.dart';
import 'package:kakaomap_webview/src/url_launcher_service.dart';
import 'package:mbtitravel/function_manager.dart';
import 'package:mbtitravel/data_frame/data_frame.dart';

import 'package:provider/provider.dart';
import 'map_model.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';

class LocationexplainCopyModel
    extends FlutterFlowModel<LocationexplainCopyWidget>
{
  ///  State fields for stateful widgets in this page.
  final unfocusNode = FocusNode();
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // State field(s) for SwipeableStack widget.
  late CardSwiperController swipeableStackController;

  // State field(s) for PageView widget.
  late PageController pageController;  // PageController 추가

  late AnimationController animationController;
  // Current index for PageView
  int currentIndex = 0; // currentIndex 추가

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {

    swipeableStackController = CardSwiperController();
    pageController = PageController();  // PageController 초기화
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
    pageController.dispose();  // PageController 해제
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

  // bool _isInitialized = false; // 좌표 초기화를 위한 플래그

  @override
  Widget build(BuildContext context)
  {
    final markerPositionsModel = Provider.of<MarkerPositionsModel>(context);
    final mapModel = Provider.of<MapModel>(context);
    final kakaoViewSize = Provider.of<KakaoViewSize>(context);

    // getter를 통해 리스트에 접근
    final markerPositions = markerPositionsModel.markerPositions;

    // MapModel에서 값을 가져옴
    double _lat = mapModel.lat;
    double _lng = mapModel.lng;;
    int _zoomLevel = mapModel.zoomLevel;


    // 좌표 초기화는 build 메서드에서 처리
    /*if (!_isInitialized && markerPositions.isNotEmpty) {
      _lat = markerPositions[4]['lat'];
      _lng = markerPositions[4]['lng'];
      _zoomLevel = 11;
      _isInitialized = true; // 좌표가 한 번만 초기화되도록 설정
    }*/

     // double kakaoMapView_deviceWidth = MediaQuery.of(context).size.width;
    // double kakaoMapView_deviceHeight = MediaQuery.of(context).size.height;

    kakaoViewSize.updateSizeWidth(MediaQuery.of(context).size.width, 350.0);
    kakaoViewSize.updateSizeHeight(MediaQuery.of(context).size.height, 0.74);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // KakaoViewSize.UpdateSizeWidth(kakaoMapView_deviceWidth, 350.0),
          // KakaoViewSize.UpdateSizeHeight(kakaoMapView_deviceHeight, 0.73),
          KakaoMapView(
            width:  kakaoViewSize.cotextWidth,
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

 // Widget Build Settings

