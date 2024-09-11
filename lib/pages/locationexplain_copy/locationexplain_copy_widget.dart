import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:mbtitravel/pages/selectpage/mbti_model.dart';

import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_swipeable_stack.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'locationexplain_copy_model.dart';
import 'dart:async';
export 'locationexplain_copy_model.dart';

import 'package:flutter/services.dart';  // 이 줄을 추가해야 합니다


// import 'dart:convert';
import 'package:flutter/material.dart';
// 데이터 프레임이 있는 곳
import 'package:mbtitravel/function_manager.dart';

// 로케이션 모델 헤더
import 'package:mbtitravel/pages/courseselect/location_model.dart';
// html 기능 사용하는 헤더
import 'package:flutter_html/flutter_html.dart';

// 카카오 패키지에서 만든 함수 가져오기(openKakaoMapAtCoordinates)
// import 'package:kakaomap_webview/src/url_launcher_service.dart';
// 데이터 프레임 가져오기
import 'package:mbtitravel/data_frame/data_frame.dart';
import 'package:mbtitravel/data_frame/default_images.dart';
import 'package:mbtitravel/data_frame/subscripts_images.dart';
import 'map_model.dart'; // MapModel이 정의된 파일

// import 'locationexplain_copy_model.dart';

import 'package:cached_network_image/cached_network_image.dart';

class LocationexplainCopyWidget extends StatefulWidget
{
  const LocationexplainCopyWidget({super.key});

  @override
  State<LocationexplainCopyWidget> createState() => _LocationexplainCopyWidgetState();

}

class _LocationexplainCopyWidgetState extends State<LocationexplainCopyWidget>
    with TickerProviderStateMixin
{
  late LocationexplainCopyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  // 초기화 코드: 스와이핑, 탭, 등의 컨트롤러 등을 초기화하는 코드
  // model.dart하고 연결되어있음.
  @override
  void initState()
  {
    super.initState(); // 부모 클래스의 initState를 먼저 호출

    // _model을 먼저 초기화한 후에 pageController를 초기화
    _model = LocationexplainCopyModel();

    _model.pageController;

    //  여기 수정함 2024-08-31 오전11:00
    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(()
    {

    });

    // 초기 좌표 정해줌.(좌표 초기화 코드)
    initializeKakaoMapPosition();

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    // 지도 스와이핑 코드
    // TabController에 리스너 추가(업데이트 코드)
    _model.tabBarController?.addListener(()
    {
      final markerPositionsModel = Provider.of<MarkerPositionsModel>(context, listen: false);
      final mapModel = Provider.of<MapModel>(context, listen: false);
      final markerPositions = markerPositionsModel.markerPositions;

      // 업데이트 될 떄마다.
      if (_model.tabBarController?.index == 2)
      {
        // 지도로 스와이핑되었을 때 좌표 변경
        if (markerPositions.isNotEmpty)
        {
          double newLat = g_kakaoMapStartLat;
          double newLng = g_kakaoMapStartLng;
          int newZoomLevel = 9;

          mapModel.updateCoordinates(newLat, newLng, newZoomLevel);
          // print('지도 탭으로 스와이프됨: 새로운 좌표와 줌 레벨이 설정되었습니다.');
        }
        else
        {
          print('지도 탭으로 스와이프됨: 마커 위치가 없습니다.');
        }
      }
    });

    // 마커 && 이미지 이니셜라이즈(초기화) 코드
    _initializeMarkersAndImages();


    // 전환 될때마다 나오는 애니메이션 세트
    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation4': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation5': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation6': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation7': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });
  }

  // 안드로이드 인터페이스(뒤로가기) 세팅

  Future<bool> _onWillPop() async
  {
    if (_model.tabBarController?.index == 1 || _model.tabBarController?.index == 2)
    {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _model.tabBarController!.animateTo(0);
      });
      return false; // 뒤로 가기 동작을 막음
    }
    // _model.tabBarController?.index == 0이라면,
    if(_model.tabBarController?.index == 0)
    {
      if (Navigator.of(context).canPop())
      {
        // 경고 창을 띄움
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (BuildContext alertDialogContext)
          {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0), // 모서리 둥글기 설정
              ),
              title: Text(
                '경고',
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '지역 선택화면으로 돌아가시겠습니까?',
                    textAlign: TextAlign.center, // 텍스트 중앙 정렬
                  ),
                  SizedBox(height: 20),
                  Text(
                    '(주의: 현재 코스는 저장되지 않습니다.)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange, // 강조를 위해 주황색으로 설정
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 버튼 중앙 정렬
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(alertDialogContext).pop(true),
                      child: Text('예'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(alertDialogContext).pop(false),
                      child: Text('아니요'),
                    ),
                  ],
                ),
              ],
            );
          },
        );
        if (shouldPop == true)
        {
          // 사용자가 "예"를 눌렀을 때 두 번 pop 수행
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
        return false; // 추가적인 pop을 막기 위해 false 반환
      }
    }
    return true;
  }

  // 카카오 포지션 초기화 함수
  void initializeKakaoMapPosition()
  {
    // print("지도 실행 초기화");

    final markerPositionsModel = Provider.of<MarkerPositionsModel>(context, listen: false);
    final mapModel = Provider.of<MapModel>(context, listen: false);
    final markerPositions = markerPositionsModel.markerPositions;

    if (markerPositions.isNotEmpty)
    {
      double newLat = g_kakaoMapStartLat;
      double newLng = g_kakaoMapStartLng;
      int newZoomLevel = 9;

      mapModel.updateCoordinates(newLat, newLng, newZoomLevel);

    }
    else
    {
      print('지도 초기화 실패');
    }
  }

  // dataframe 이미지 로딩 비동기로 되어있음
  Future<void> _initializeMarkersAndImages() async
  {
    final markerPositionsModel = Provider.of<MarkerPositionsModel>(context, listen: false);
    try
    {
      // TOUR API 키를 사용하여 데이터를 초기화 시점에서 받아옴
      await markerPositionsModel.fetchAndUpdateData(tourApiKey);
    }
    catch (error)
    {
      print('데이터를 받아오는 중에 오류 발생: $error');
    }
  }

  @override
  void dispose()
  {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    final markerPositionsModel = Provider.of<MarkerPositionsModel>(context);
    final markerPositions = markerPositionsModel.markerPositions;

    final mapModel = Provider.of<MapModel>(context);

    final kakaoViewSize = Provider.of<KakaoViewSize>(context);

    // Size ViewWize = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: _onWillPop,
        child:  GestureDetector(
          onTap: () => _model.unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.black,

            appBar: AppBar(
              backgroundColor: const Color(0xFF0C0202),
              automaticallyImplyLeading: false,
              leading: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 60.0,
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 30.0,
                ),
                onPressed: () async {
                  // 경고 창을 띄움
                  final shouldPop = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext alertDialogContext) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0), // 모서리 둥글기 설정
                        ),
                        title: Text(
                          '경고',
                          textAlign: TextAlign.center,
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '지역 선택화면으로 돌아가시겠습니까?',
                              textAlign: TextAlign.center, // 텍스트 중앙 정렬
                            ),
                            SizedBox(height: 20),
                            Text(
                              '(주의: 현재 코스는 저장되지 않습니다.)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange, // 강조를 위해 주황색으로 설정
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center, // 버튼 중앙 정렬
                            children: [
                              TextButton(
                                onPressed: () => Navigator.of(alertDialogContext).pop(true),
                                child: Text('예'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(alertDialogContext).pop(false),
                                child: Text('아니요'),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                  if (shouldPop == true)
                  {
                    // 사용자가 "예"를 선택했을 때 두 번 pop 수행
                    markerPositions.clear();
                    for (int popIndex = 0; popIndex < 2; popIndex++)
                    {
                      Navigator.pop(context);
                    }
                  }
                },
              ),
              title: Text(
                'MBTI TRAVEL',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                ),
              ),
              actions: const [],
              centerTitle: false,
              elevation: 2.0,
            ),
            body: SafeArea(
              top: true,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: const AlignmentDirectional(0.0, 0.0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16.0, 16.0, 0.0, 0.0),
                      child: Text(

                        getSelectedLocation(context),
                        style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: 'Readex Pro',
                          letterSpacing: 0.0,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Align(
                          alignment: const Alignment(0.0, 0),
                          child: TabBar(
                            labelColor: Colors.white,
                            unselectedLabelColor: const Color(0xFF434F57),
                            labelStyle:
                            FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0.0,
                            ),
                            unselectedLabelStyle: const TextStyle(),
                            indicatorColor: FlutterFlowTheme.of(context).primary,
                            padding: const EdgeInsets.all(4.0),
                            tabs: const [
                              Tab(
                                text: '코스',
                              ),
                              Tab(
                                text: '장소설명',
                              ),
                              Tab(
                                text: '지도',
                              ),
                            ],
                            controller: _model.tabBarController,
                            onTap: (i) async {
                              [() async
                              {
                                // 첫 번째 탭 클릭시(코스)
                              }, () async
                              {
                                // 두 번째 탭 클릭시(장소 설명)
                              }, () async
                              {
                                // 세 번째 탭 클릭시(지도)
                                if (markerPositions.isNotEmpty)
                                {
                                  double newLat = g_kakaoMapStartLat; // 첫 번째 마커의 위도 사용
                                  double newLng = g_kakaoMapStartLng; // 첫 번째 마커의 경도 사용
                                  int newZoomLevel = 9; // 예시 줌 레벨

                                  // updateCoordinates 메서드를 호출하여 좌표 및 줌 레벨 업데이트
                                  mapModel.updateCoordinates(newLat, newLng, newZoomLevel);

                                  // print('지도 탭 클릭됨: 새로운 좌표와 줌 레벨이 설정되었습니다.');
                                }
                                else
                                {
                                  print('지도 탭 클릭됨: 마커 위치가 없습니다.');
                                }
                              }][i]();
                            },
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _model.tabBarController,
                            children: [
                              // 첫 번째 탭 (카드형 리스트)
                              Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                ),
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    // 첫 번째 카드형 리스트 아이템
                                    Padding( // 0번 카드
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 1.0),
                                      child: InkWell(  // 카드 클릭 시 이벤트 추가
                                        onTap: () {
                                          if (_model.tabBarController != null)
                                          {
                                          setState(() {
                                            _model.updatePageControllerWithNewIndexForTap(0); // 탭 클릭 시 0번 카드로 이동
                                          });

                                            // UI 갱신 후 탭 전환
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              _model.tabBarController!.animateTo(1); // '코스설명' 탭으로 이동
                                            });
                                          }
                                        },
                                        child: Card(
                                          elevation: 3.0, // 그림자 효과
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.0), // 카드 모서리 둥글게
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            height: 148.0,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.circular(12.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // 썸네일 이미지
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional.fromSTEB(4.0, 30.0, 0.0, 0.0),
                                                    child: Container(
                                                      width: 77.0,
                                                      height: 77.0,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme.of(context).accent1,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: FlutterFlowTheme.of(context).primary,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(50.0),
                                                        child: buildThumbnailLoader(context, markerPositions[0]['contentid']),
                                                      ),
                                                    ),
                                                  ),

                                                  // 텍스트 및 설명 부분
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 12.0),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          // 장소 이름
                                                          Text(
                                                            '${markerPositions[0]['name']}',
                                                            style: FlutterFlowTheme.of(context).displaySmall.override(
                                                              fontFamily: 'Outfit',
                                                              color: Colors.white,
                                                              fontSize: 16.0,
                                                              letterSpacing: 0.0,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),

                                                          // Kakao map 버튼 (텍스트 대신 버튼으로)
                                                          Padding(
                                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                                                            child: Row(
                                                              children: [
                                                                ElevatedButton(  // kakao map을 버튼으로 변경
                                                                  onPressed: () {
                                                                    if (_model.tabBarController != null) {
                                                                      _model.tabBarController!.animateTo(2); // "지도" 탭으로 이동
                                                                    }
                                                                    Provider.of<MapModel>(context, listen: false).updateCoordinates(
                                                                      markerPositions[0]['lat'],  // 새 lat 값
                                                                      markerPositions[0]['lng'],  // 새 lng 값
                                                                      3,                         // 새 zoomLevel 값
                                                                    );
                                                                  },
                                                                  child: Text(
                                                                    'Kakao Map',
                                                                    style: TextStyle(
                                                                      fontFamily: 'Readex Pro',
                                                                      fontSize: 16.0,
                                                                      letterSpacing: 0.0,
                                                                      color: Colors.white,
                                                                    ),
                                                                  ),
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: FlutterFlowTheme.of(context).primary, // 버튼 색상
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(12.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                                // 화살표 아이콘
                                                                Padding(
                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                                                                  child: InkWell(
                                                                    onTap: () {},
                                                                    child: Icon(
                                                                      Icons.chevron_right_rounded,
                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                      size: 24.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // 다른 카드형 리스트 아이템들 추가 가능...
                                    Padding( // 1번카드
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 1.0),
                                      child: InkWell(  // 카드 클릭 시 이벤트 추가
                                        onTap: () {
                                          if (_model.tabBarController != null) {
                                            setState(() {
                                              _model.updatePageControllerWithNewIndexForTap(1); // 탭 클릭 시 1번 카드로 이동
                                            });

                                            // UI 갱신 후 탭 전환
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              _model.tabBarController!.animateTo(1); // '코스설명' 탭으로 이동
                                            });
                                          }
                                        },
                                        child: Card(
                                          elevation: 3.0, // 그림자 효과
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.0), // 카드 모서리 둥글게
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            height: 148.0,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.circular(12.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // 썸네일 이미지
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional.fromSTEB(4.0, 30.0, 0.0, 0.0),
                                                    child: Container(
                                                      width: 77.0,
                                                      height: 77.0,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme.of(context).accent1,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: FlutterFlowTheme.of(context).primary,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(50.0),
                                                        child: buildThumbnailLoader(context, markerPositions[1]['contentid']),
                                                      ),
                                                    ),
                                                  ),

                                                  // 텍스트 및 설명 부분
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 12.0),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          // 장소 이름
                                                          Text(
                                                            '${markerPositions[1]['name']}',
                                                            style: FlutterFlowTheme.of(context).displaySmall.override(
                                                              fontFamily: 'Outfit',
                                                              color: Colors.white,
                                                              fontSize: 16.0,
                                                              letterSpacing: 0.0,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),

                                                          // Kakao map 버튼 (텍스트 대신 버튼으로)
                                                          Padding(
                                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                                                            child: Row(
                                                              children: [
                                                                ElevatedButton(  // kakao map을 버튼으로 변경
                                                                  onPressed: () {
                                                                    if (_model.tabBarController != null) {
                                                                      _model.tabBarController!.animateTo(2); // "지도" 탭으로 이동
                                                                    }
                                                                    Provider.of<MapModel>(context, listen: false).updateCoordinates(
                                                                      markerPositions[1]['lat'],  // 새 lat 값
                                                                      markerPositions[1]['lng'],  // 새 lng 값
                                                                      3,                         // 새 zoomLevel 값
                                                                    );
                                                                  },
                                                                  child: Text(
                                                                    'Kakao Map',
                                                                    style: TextStyle(
                                                                      fontFamily: 'Readex Pro',
                                                                      fontSize: 16.0,
                                                                      letterSpacing: 0.0,
                                                                      color: Colors.white,
                                                                    ),
                                                                  ),
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: FlutterFlowTheme.of(context).primary, // 버튼 색상
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(12.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                                // 화살표 아이콘
                                                                Padding(
                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                                                                  child: InkWell(
                                                                    onTap: () {},
                                                                    child: Icon(
                                                                      Icons.chevron_right_rounded,
                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                      size: 24.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding( // 2번 카드
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 1.0),
                                      child: InkWell(  // 카드 클릭 시 이벤트 추가
                                        onTap: () {
                                          if (_model.tabBarController != null) {
                                            setState(() {
                                              _model.updatePageControllerWithNewIndexForTap(2); // 탭 클릭 시 2번 카드로 이동
                                            });

                                            // UI 갱신 후 탭 전환
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              _model.tabBarController!.animateTo(1); // '코스설명' 탭으로 이동
                                            });
                                          }
                                        },
                                        child: Card(
                                          elevation: 3.0, // 그림자 효과
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.0), // 카드 모서리 둥글게
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            height: 148.0,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.circular(12.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // 썸네일 이미지
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional.fromSTEB(4.0, 30.0, 0.0, 0.0),
                                                    child: Container(
                                                      width: 77.0,
                                                      height: 77.0,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme.of(context).accent1,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: FlutterFlowTheme.of(context).primary,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(50.0),
                                                        child: buildThumbnailLoader(context, markerPositions[2]['contentid']),
                                                      ),
                                                    ),
                                                  ),

                                                  // 텍스트 및 설명 부분
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 12.0),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          // 장소 이름
                                                          Text(
                                                            '${markerPositions[2]['name']}',
                                                            style: FlutterFlowTheme.of(context).displaySmall.override(
                                                              fontFamily: 'Outfit',
                                                              color: Colors.white,
                                                              fontSize: 16.0,
                                                              letterSpacing: 0.0,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),

                                                          // Kakao map 버튼 (텍스트 대신 버튼으로)
                                                          Padding(
                                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                                                            child: Row(
                                                              children: [
                                                                ElevatedButton(  // kakao map을 버튼으로 변경
                                                                  onPressed: () {
                                                                    if (_model.tabBarController != null) {
                                                                      _model.tabBarController!.animateTo(2); // "지도" 탭으로 이동
                                                                    }
                                                                    Provider.of<MapModel>(context, listen: false).updateCoordinates(
                                                                      markerPositions[2]['lat'],  // 새 lat 값
                                                                      markerPositions[2]['lng'],  // 새 lng 값
                                                                      3,                         // 새 zoomLevel 값
                                                                    );
                                                                  },
                                                                  child: Text(
                                                                    'Kakao Map',
                                                                    style: TextStyle(
                                                                      fontFamily: 'Readex Pro',
                                                                      fontSize: 16.0,
                                                                      letterSpacing: 0.0,
                                                                      color: Colors.white,
                                                                    ),
                                                                  ),
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: FlutterFlowTheme.of(context).primary, // 버튼 색상
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(12.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                                // 화살표 아이콘
                                                                Padding(
                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                                                                  child: InkWell(
                                                                    onTap: () {},
                                                                    child: Icon(
                                                                      Icons.chevron_right_rounded,
                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                      size: 24.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding( // 3번 카드
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 1.0),
                                      child: InkWell(  // 카드 클릭 시 이벤트 추가
                                        onTap: () {
                                          if (_model.tabBarController != null) {
                                            setState(() {
                                              _model.updatePageControllerWithNewIndexForTap(3); // 탭 클릭 시 3번 카드로 이동
                                            });

                                            // UI 갱신 후 탭 전환
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              _model.tabBarController!.animateTo(1); // '코스설명' 탭으로 이동
                                            });
                                          }
                                        },
                                        child: Card(
                                          elevation: 3.0, // 그림자 효과
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.0), // 카드 모서리 둥글게
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            height: 148.0,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.circular(12.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // 썸네일 이미지
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional.fromSTEB(4.0, 30.0, 0.0, 0.0),
                                                    child: Container(
                                                      width: 77.0,
                                                      height: 77.0,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme.of(context).accent1,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: FlutterFlowTheme.of(context).primary,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(50.0),
                                                        child: buildThumbnailLoader(context, markerPositions[3]['contentid']),
                                                      ),
                                                    ),
                                                  ),

                                                  // 텍스트 및 설명 부분
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 12.0),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          // 장소 이름
                                                          Text(
                                                            '${markerPositions[3]['name']}',
                                                            style: FlutterFlowTheme.of(context).displaySmall.override(
                                                              fontFamily: 'Outfit',
                                                              color: Colors.white,
                                                              fontSize: 16.0,
                                                              letterSpacing: 0.0,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),

                                                          // Kakao map 버튼 (텍스트 대신 버튼으로)
                                                          Padding(
                                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                                                            child: Row(
                                                              children: [
                                                                ElevatedButton(  // kakao map을 버튼으로 변경
                                                                  onPressed: () {
                                                                    if (_model.tabBarController != null) {
                                                                      _model.tabBarController!.animateTo(2); // "지도" 탭으로 이동
                                                                    }
                                                                    Provider.of<MapModel>(context, listen: false).updateCoordinates(
                                                                      markerPositions[3]['lat'],  // 새 lat 값
                                                                      markerPositions[3]['lng'],  // 새 lng 값
                                                                      3,                         // 새 zoomLevel 값
                                                                    );
                                                                  },
                                                                  child: Text(
                                                                    'Kakao Map',
                                                                    style: TextStyle(
                                                                      fontFamily: 'Readex Pro',
                                                                      fontSize: 16.0,
                                                                      letterSpacing: 0.0,
                                                                      color: Colors.white,
                                                                    ),
                                                                  ),
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: FlutterFlowTheme.of(context).primary, // 버튼 색상
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(12.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                                // 화살표 아이콘
                                                                Padding(
                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                                                                  child: InkWell(
                                                                    onTap: () {},
                                                                    child: Icon(
                                                                      Icons.chevron_right_rounded,
                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                      size: 24.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding( // 4번 카드
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 1.0),
                                      child: InkWell(  // 카드 클릭 시 이벤트 추가
                                        onTap: () {
                                          if (_model.tabBarController != null) {
                                            setState(() {
                                              _model.updatePageControllerWithNewIndexForTap(4); // 탭 클릭 시 4번 카드로 이동
                                            });

                                            // UI 갱신 후 탭 전환
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              _model.tabBarController!.animateTo(1); // '코스설명' 탭으로 이동
                                            });
                                          }
                                        },
                                        child: Card(
                                          elevation: 3.0, // 그림자 효과
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.0), // 카드 모서리 둥글게
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            height: 148.0,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.circular(12.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // 썸네일 이미지
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional.fromSTEB(4.0, 30.0, 0.0, 0.0),
                                                    child: Container(
                                                      width: 77.0,
                                                      height: 77.0,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme.of(context).accent1,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: FlutterFlowTheme.of(context).primary,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(50.0),
                                                        child: buildThumbnailLoader(context, markerPositions[4]['contentid']),
                                                      ),
                                                    ),
                                                  ),

                                                  // 텍스트 및 설명 부분
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 12.0),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          // 장소 이름
                                                          Text(
                                                            '${markerPositions[4]['name']}',
                                                            style: FlutterFlowTheme.of(context).displaySmall.override(
                                                              fontFamily: 'Outfit',
                                                              color: Colors.white,
                                                              fontSize: 16.0,
                                                              letterSpacing: 0.0,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),

                                                          // Kakao map 버튼 (텍스트 대신 버튼으로)
                                                          Padding(
                                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                                                            child: Row(
                                                              children: [
                                                                ElevatedButton(  // kakao map을 버튼으로 변경
                                                                  onPressed: () {
                                                                    if (_model.tabBarController != null) {
                                                                      _model.tabBarController!.animateTo(2); // "지도" 탭으로 이동
                                                                    }
                                                                    Provider.of<MapModel>(context, listen: false).updateCoordinates(
                                                                      markerPositions[4]['lat'],  // 새 lat 값
                                                                      markerPositions[4]['lng'],  // 새 lng 값
                                                                      3,                         // 새 zoomLevel 값
                                                                    );
                                                                  },
                                                                  child: Text(
                                                                    'Kakao Map',
                                                                    style: TextStyle(
                                                                      fontFamily: 'Readex Pro',
                                                                      fontSize: 16.0,
                                                                      letterSpacing: 0.0,
                                                                      color: Colors.white,
                                                                    ),
                                                                  ),
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: FlutterFlowTheme.of(context).primary, // 버튼 색상
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(12.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                                // 화살표 아이콘
                                                                Padding(
                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                                                                  child: InkWell(
                                                                    onTap: () {},
                                                                    child: Icon(
                                                                      Icons.chevron_right_rounded,
                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                      size: 24.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding( // 5번 카드
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 1.0),
                                      child: InkWell(  // 카드 클릭 시 이벤트 추가
                                        onTap: () {
                                          if (_model.tabBarController != null) {
                                            setState(() {
                                              _model.updatePageControllerWithNewIndexForTap(5); // 탭 클릭 시 5번 카드로 이동
                                            });

                                            // UI 갱신 후 탭 전환
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              _model.tabBarController!.animateTo(1); // '코스설명' 탭으로 이동
                                            });
                                          }
                                        },
                                        child: Card(
                                          elevation: 3.0, // 그림자 효과
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.0), // 카드 모서리 둥글게
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            height: 148.0,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.circular(12.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // 썸네일 이미지
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional.fromSTEB(4.0, 30.0, 0.0, 0.0),
                                                    child: Container(
                                                      width: 77.0,
                                                      height: 77.0,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme.of(context).accent1,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: FlutterFlowTheme.of(context).primary,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(50.0),
                                                        child: buildThumbnailLoader(context, markerPositions[5]['contentid']),
                                                      ),
                                                    ),
                                                  ),

                                                  // 텍스트 및 설명 부분
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 12.0),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          // 장소 이름
                                                          Text(
                                                            '${markerPositions[5]['name']}',
                                                            style: FlutterFlowTheme.of(context).displaySmall.override(
                                                              fontFamily: 'Outfit',
                                                              color: Colors.white,
                                                              fontSize: 16.0,
                                                              letterSpacing: 0.0,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),

                                                          // Kakao map 버튼 (텍스트 대신 버튼으로)
                                                          Padding(
                                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                                                            child: Row(
                                                              children: [
                                                                ElevatedButton(  // kakao map을 버튼으로 변경
                                                                  onPressed: () {
                                                                    if (_model.tabBarController != null) {
                                                                      _model.tabBarController!.animateTo(2); // "지도" 탭으로 이동
                                                                    }
                                                                    Provider.of<MapModel>(context, listen: false).updateCoordinates(
                                                                      markerPositions[5]['lat'],  // 새 lat 값
                                                                      markerPositions[5]['lng'],  // 새 lng 값
                                                                      3,                         // 새 zoomLevel 값
                                                                    );
                                                                  },
                                                                  child: Text(
                                                                    'Kakao Map',
                                                                    style: TextStyle(
                                                                      fontFamily: 'Readex Pro',
                                                                      fontSize: 16.0,
                                                                      letterSpacing: 0.0,
                                                                      color: Colors.white,
                                                                    ),
                                                                  ),
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: FlutterFlowTheme.of(context).primary, // 버튼 색상
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(12.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                                // 화살표 아이콘
                                                                Padding(
                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                                                                  child: InkWell(
                                                                    onTap: () {},
                                                                    child: Icon(
                                                                      Icons.chevron_right_rounded,
                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                      size: 24.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding( // 6번 카드
                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 1.0),
                                      child: InkWell(  // 카드 클릭 시 이벤트 추가
                                        onTap: () {
                                          if (_model.tabBarController != null) {
                                            setState(() {
                                              _model.updatePageControllerWithNewIndexForTap(6); // 탭 클릭 시 6번 카드로 이동
                                            });

                                            // UI 갱신 후 탭 전환
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              _model.tabBarController!.animateTo(1); // '코스설명' 탭으로 이동
                                            });
                                          }
                                        },
                                        child: Card(
                                          elevation: 3.0, // 그림자 효과
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.0), // 카드 모서리 둥글게
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            height: 148.0,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.circular(12.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // 썸네일 이미지
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional.fromSTEB(4.0, 30.0, 0.0, 0.0),
                                                    child: Container(
                                                      width: 77.0,
                                                      height: 77.0,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme.of(context).accent1,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: FlutterFlowTheme.of(context).primary,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(50.0),
                                                        child: buildThumbnailLoader(context, markerPositions[6]['contentid']),
                                                      ),
                                                    ),
                                                  ),

                                                  // 텍스트 및 설명 부분
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 12.0),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          // 장소 이름
                                                          Text(
                                                            '${markerPositions[6]['name']}',
                                                            style: FlutterFlowTheme.of(context).displaySmall.override(
                                                              fontFamily: 'Outfit',
                                                              color: Colors.white,
                                                              fontSize: 16.0,
                                                              letterSpacing: 0.0,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),

                                                          // Kakao map 버튼 (텍스트 대신 버튼으로)
                                                          Padding(
                                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                                                            child: Row(
                                                              children: [
                                                                ElevatedButton(  // kakao map을 버튼으로 변경
                                                                  onPressed: () {
                                                                    if (_model.tabBarController != null) {
                                                                      _model.tabBarController!.animateTo(2); // "지도" 탭으로 이동
                                                                    }
                                                                    Provider.of<MapModel>(context, listen: false).updateCoordinates(
                                                                      markerPositions[6]['lat'],  // 새 lat 값
                                                                      markerPositions[6]['lng'],  // 새 lng 값
                                                                      3,                         // 새 zoomLevel 값
                                                                    );
                                                                  },
                                                                  child: Text(
                                                                    'Kakao Map',
                                                                    style: TextStyle(
                                                                      fontFamily: 'Readex Pro',
                                                                      fontSize: 16.0,
                                                                      letterSpacing: 0.0,
                                                                      color: Colors.white,
                                                                    ),
                                                                  ),
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: FlutterFlowTheme.of(context).primary, // 버튼 색상
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(12.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                                // 화살표 아이콘
                                                                Padding(
                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                                                                  child: InkWell(
                                                                    onTap: () {},
                                                                    child: Icon(
                                                                      Icons.chevron_right_rounded,
                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                      size: 24.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // ========================================================인덱스 끝========================================================
                              /*설명 카드 시작*/
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onVerticalDragUpdate: (details) {
                                        if (details.delta.dy > 0 && _model.currentIndex == 0) {
                                          // 첫 번째 카드에서 아래로 스와이프 막기
                                          print("첫 번째 카드에서 더 이상 아래로 스와이프할 수 없습니다.");
                                        } else if (details.delta.dy < 0 && _model.currentIndex == markerPositions.length - 1) {
                                          // 마지막 카드에서 위로 스와이프 막기
                                          print("마지막 카드에서 더 이상 위로 스와이프할 수 없습니다.");
                                        } else {
                                          // 일반적인 스와이프 처리
                                          if (details.delta.dy > 0) {
                                            // 아래로 스와이프
                                            _model.pageController.previousPage(
                                              duration: Duration(milliseconds: 300),
                                              curve: Curves.easeIn,
                                            );
                                          } else if (details.delta.dy < 0) {
                                            // 위로 스와이프
                                            _model.pageController.nextPage(
                                              duration: Duration(milliseconds: 300),
                                              curve: Curves.easeIn,
                                            );
                                          }
                                        }
                                      },
                                      child: PageView.builder(
                                        controller: _model.pageController,
                                        scrollDirection: Axis.vertical, // 스크롤 방향을 수직으로 변경
                                        itemCount: markerPositions.length,
                                        onPageChanged: (index) {
                                          setState(() {
                                            _model.updatePageControllerWithNewIndex(index);
                                          });
                                        },
                                        // PageView.builder에서 각 카드 함수 호출
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Builder(
                                                    builder: (context) {
                                                      if (index == 0) {
                                                        return buildCard0(context, markerPositions[index]);
                                                      } else if (index == 1) {
                                                        return buildCard1(context, markerPositions[index]);
                                                      } else if (index == 2) {
                                                        return buildCard2(context, markerPositions[index]);
                                                      } else if (index == 3) {
                                                        return buildCard3(context, markerPositions[index]);
                                                      } else if (index == 4) {
                                                        return buildCard4(context, markerPositions[index]);
                                                      } else if (index == 5) {
                                                        return buildCard5(context, markerPositions[index]);
                                                      } else if (index == 6) {
                                                        return buildCard6(context, markerPositions[index]);
                                                      } else {
                                                        throw Exception('Invalid index: $index');
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                              // 각 카드 아래에 경계선 추가
                                              if (index != markerPositions.length - 1) // 마지막 카드 제외
                                                Divider(
                                                  color: Colors.white, // 선 색상 설정
                                                  thickness: 3.0, // 선 두께 설정
                                                  height: 3.0, // 선 높이 설정
                                                ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              /*설명 카드 쪽 코드 끝*/
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 10.0, 0.0, 0.0),
                                    child: Container(
                                      width: kakaoViewSize.cotextWidth,
                                      height: kakaoViewSize.contextHeight,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                        ),
                                      ),
                                      child: const KakaoMap(), // 카카오 맵
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );

  }
}
/*여행지 명 리턴 함수*/
String getSelectedLocation(BuildContext context)
{
  return Provider.of<LocationModel>(context, listen: false).selectedLocation;
}

/// 이미지 URL을 가져오는 함수
String _getImageUrlHelper(Map<String, dynamic> marker, List<String> imageKeys, String defaultUrl) {
  for (String key in imageKeys) {
    final imageUrl = marker[key] as String?;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return imageUrl;
    }
  }
  return defaultUrl;
}

// 콘텐츠 ID에 따라 적절한 이미지를 반환하는 함수
String getImageUrl(List<Map<String, dynamic>> markerPositions, String? contentId, String defaultUrl) {
  if (contentId == null || contentId.isEmpty) {
    return defaultUrl;
  }

  final marker = markerPositions.firstWhere(
        (element) => element['contentid'] == contentId,
    orElse: () => <String, dynamic>{},
  );

  if (marker.isNotEmpty) {
    if (contentId == '2815362') {
      return marker['originimgurl5'] ?? defaultUrl;
    } else {
      return _getImageUrlHelper(marker, ['firstimage', 'originimgurl1'], defaultUrl);
    }
  }

  return defaultUrl;
}

// 썸네일 이미지 URL을 가져오는 함수
Future<String> getThumbnailUrl(List<Map<String, dynamic>> markerPositions, String? contentId, String defaultUrl) {
  if (contentId == null || contentId.isEmpty) {
    return Future.value(defaultUrl);
  }

  final marker = markerPositions.firstWhere(
        (element) => element['contentid'] == contentId,
    orElse: () => <String, dynamic>{},
  );

  if (marker.isNotEmpty) {
    if (contentId == '2815362') {
      return Future.value(marker['smallimageurl5'] ?? defaultUrl);
    } else {
      return Future.value(_getImageUrlHelper(marker, ['firstimage2', 'smallimageurl1'], defaultUrl));
    }
  }

  return Future.value(defaultUrl);
}

/// CachedNetworkImage 위젯을 생성하는 함수
Widget buildImageLoader(List<Map<String, dynamic>> markerPositions, String contentId, int g_districtCode) {
  final defaultImageUrl = subScriptsImages[g_districtCode] ?? 'https://picsum.photos/seed/872/600';
  final imageUrl = getImageUrl(markerPositions, contentId, defaultImageUrl);

  return CachedNetworkImage(
    imageUrl: imageUrl,
    placeholder: (context, url) => Center(
      child: SizedBox(
        width: 24.0,
        height: 24.0,
        child: CircularProgressIndicator(strokeWidth: 2.0),
      ),
    ),
    errorWidget: (context, url, error) => Icon(Icons.error),
    width: double.infinity,
    height: 200.0,
    fit: BoxFit.contain,
  );
}

String getNonCachedImageUrl(String imageUrl) {
  return '$imageUrl?timestamp=${DateTime.now().millisecondsSinceEpoch}';
}

Widget _buildNetworkImage(String? imageUrl) {
  // 이미지 URL이 없을 경우 기본 이미지를 사용
  if (imageUrl == null || imageUrl.isEmpty) {
    return Image.network(
      'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Thumb_images/%EB%94%94%ED%8F%B4%ED%8A%B8.jpg',
      width: 40.0,
      height: 40.0,
      fit: BoxFit.cover,
    );
  }

  return Image.network(
    imageUrl,
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) {
        return child;  // 이미지를 성공적으로 로드한 경우
      } else {
        // 로딩 중일 때만 로딩 스피너를 표시
        return Center(
          child: SizedBox(
            width: 24.0,
            height: 24.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
            ),
          ),
        );
      }
    },
    errorBuilder: (context, error, stackTrace) {
      // 로드에 실패했을 때 기본 이미지를 표시
      return Image.network(
        'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Thumb_images/%EB%94%94%ED%8F%B4%ED%8A%B8.jpg',
        width: 40.0,
        height: 40.0,
        fit: BoxFit.cover,
      );
    },
    width: 40.0,
    height: 40.0,
    fit: BoxFit.cover,
  );
}

Widget buildThumbnailLoader(BuildContext context, String contentId) {
  final markerPositionsModel = Provider.of<MarkerPositionsModel>(context);

  if (!markerPositionsModel.isDataLoaded) {
    // 데이터가 로드되지 않았을 때 로딩 스피너 표시
    return Center(
      child: SizedBox(
        width: 24.0,
        height: 24.0,
        child: CircularProgressIndicator(strokeWidth: 2.0),
      ),
    );
  }

  // 데이터가 로드되었으면 이미지를 표시
  return FutureBuilder<String>(
    future: getThumbnailUrl(markerPositionsModel.markerPositions, contentId, ''),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: SizedBox(
            width: 24.0,
            height: 24.0,
            child: CircularProgressIndicator(strokeWidth: 2.0),
          ),
        );
      } else if (snapshot.hasError) {
        return Icon(Icons.error);
      } else if (snapshot.connectionState == ConnectionState.done) {
        final imageUrl = snapshot.data;
        if (imageUrl == null || imageUrl.isEmpty) {
          String? defaultImageUrl = defaultImages[g_districtCode];
          return _buildNetworkImage(defaultImageUrl);
        } else {
          return _buildNetworkImage(imageUrl);
        }
      } else {
        return Icon(Icons.image_not_supported, size: 40.0);
      }
    },
  );
}

// 각각의 카드 빌더 함수들 정의
Widget buildCard0(BuildContext context, Map<String, dynamic> markerPosition) {
  String overViewText = markerPosition['overview'] ?? "";
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0),
        // 제목을 이미지 위쪽에 배치
        Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 12.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                markerPosition['name'],
                style: FlutterFlowTheme.of(context).headlineLarge.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  letterSpacing: 0.0,
                ),
                maxLines: 1, // 한 줄로 제한
                overflow: TextOverflow.ellipsis, // 텍스트가 넘치면 '...'으로 표시
              ),
            )
        ),

        SizedBox(height: 50.0),

        // 이미지
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
          child: AspectRatio(
            aspectRatio: 16/9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: buildImageLoader([markerPosition], markerPosition['contentid'], g_districtCode!),
            ),
          ),
        ),
        // 설명 텍스트

        SizedBox(height: 50.0),

        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 0.0),
          child: Html(
            data: """
              <p style="font-family: 'Readex Pro', sans-serif; color: white; letter-spacing: 0px;">
                $overViewText
              </p>
            """,
            style: {
              "p": Style(
                fontFamily: 'Readex Pro',
                color: Colors.white,
                letterSpacing: 0.0,
                fontSize: FontSize.large, // labelLarge에 맞는 크기로 설정
              ),
            },
          ),
        ),
      ],
    ),
  );
}

Widget buildCard1(BuildContext context, Map<String, dynamic> markerPosition) {
  String overViewText = markerPosition['overview'] ?? "";
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0),
        // 제목을 이미지 위쪽에 배치
        Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 12.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                markerPosition['name'],
                style: FlutterFlowTheme.of(context).headlineLarge.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  letterSpacing: 0.0,
                ),
                maxLines: 1, // 한 줄로 제한
                overflow: TextOverflow.ellipsis, // 텍스트가 넘치면 '...'으로 표시
              ),
            )
        ),

        SizedBox(height: 50.0),

        // 이미지
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
          child: AspectRatio(
            aspectRatio: 16/9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: buildImageLoader([markerPosition], markerPosition['contentid'], g_districtCode!),
            ),
          ),
        ),
        // 설명 텍스트

        SizedBox(height: 50.0),

        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 0.0),
          child: Html(
            data: """
              <p style="font-family: 'Readex Pro', sans-serif; color: white; letter-spacing: 0px;">
                $overViewText
              </p>
            """,
            style: {
              "p": Style(
                fontFamily: 'Readex Pro',
                color: Colors.white,
                letterSpacing: 0.0,
                fontSize: FontSize.large, // labelLarge에 맞는 크기로 설정
              ),
            },
          ),
        ),
      ],
    ),
  );
}

Widget buildCard2(BuildContext context, Map<String, dynamic> markerPosition) {
  String overViewText = markerPosition['overview'] ?? "";
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0),
        // 제목을 이미지 위쪽에 배치
        Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 12.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                markerPosition['name'],
                style: FlutterFlowTheme.of(context).headlineLarge.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  letterSpacing: 0.0,
                ),
                maxLines: 1, // 한 줄로 제한
                overflow: TextOverflow.ellipsis, // 텍스트가 넘치면 '...'으로 표시
              ),
            )
        ),

        SizedBox(height: 50.0),

        // 이미지
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
          child: AspectRatio(
            aspectRatio: 16/9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: buildImageLoader([markerPosition], markerPosition['contentid'], g_districtCode!),
            ),
          ),
        ),
        // 설명 텍스트

        SizedBox(height: 50.0),

        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 0.0),
          child: Html(
            data: """
              <p style="font-family: 'Readex Pro', sans-serif; color: white; letter-spacing: 0px;">
                $overViewText
              </p>
            """,
            style: {
              "p": Style(
                fontFamily: 'Readex Pro',
                color: Colors.white,
                letterSpacing: 0.0,
                fontSize: FontSize.large, // labelLarge에 맞는 크기로 설정
              ),
            },
          ),
        ),
      ],
    ),
  );
}

Widget buildCard3(BuildContext context, Map<String, dynamic> markerPosition) {
  String overViewText = markerPosition['overview'] ?? "";
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0),
        // 제목을 이미지 위쪽에 배치
        Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 12.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                markerPosition['name'],
                style: FlutterFlowTheme.of(context).headlineLarge.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  letterSpacing: 0.0,
                ),
                maxLines: 1, // 한 줄로 제한
                overflow: TextOverflow.ellipsis, // 텍스트가 넘치면 '...'으로 표시
              ),
            )
        ),

        SizedBox(height: 50.0),

        // 이미지
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
          child: AspectRatio(
            aspectRatio: 16/9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: buildImageLoader([markerPosition], markerPosition['contentid'], g_districtCode!),
            ),
          ),
        ),
        // 설명 텍스트

        SizedBox(height: 50.0),

        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 0.0),
          child: Html(
            data: """
              <p style="font-family: 'Readex Pro', sans-serif; color: white; letter-spacing: 0px;">
                $overViewText
              </p>
            """,
            style: {
              "p": Style(
                fontFamily: 'Readex Pro',
                color: Colors.white,
                letterSpacing: 0.0,
                fontSize: FontSize.large, // labelLarge에 맞는 크기로 설정
              ),
            },
          ),
        ),
      ],
    ),
  );
}

Widget buildCard4(BuildContext context, Map<String, dynamic> markerPosition) {
  String overViewText = markerPosition['overview'] ?? "";
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0),
        // 제목을 이미지 위쪽에 배치
        Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 12.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                markerPosition['name'],
                style: FlutterFlowTheme.of(context).headlineLarge.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  letterSpacing: 0.0,
                ),
                maxLines: 1, // 한 줄로 제한
                overflow: TextOverflow.ellipsis, // 텍스트가 넘치면 '...'으로 표시
              ),
            )
        ),

        SizedBox(height: 50.0),

        // 이미지
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
          child: AspectRatio(
            aspectRatio: 16/9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: buildImageLoader([markerPosition], markerPosition['contentid'], g_districtCode!),
            ),
          ),
        ),
        // 설명 텍스트

        SizedBox(height: 50.0),

        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 0.0),
          child: Html(
            data: """
              <p style="font-family: 'Readex Pro', sans-serif; color: white; letter-spacing: 0px;">
                $overViewText
              </p>
            """,
            style: {
              "p": Style(
                fontFamily: 'Readex Pro',
                color: Colors.white,
                letterSpacing: 0.0,
                fontSize: FontSize.large, // labelLarge에 맞는 크기로 설정
              ),
            },
          ),
        ),
      ],
    ),
  );
}

Widget buildCard5(BuildContext context, Map<String, dynamic> markerPosition) {
  String overViewText = markerPosition['overview'] ?? "";
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0),
        // 제목을 이미지 위쪽에 배치
        Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 12.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                markerPosition['name'],
                style: FlutterFlowTheme.of(context).headlineLarge.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  letterSpacing: 0.0,
                ),
                maxLines: 1, // 한 줄로 제한
                overflow: TextOverflow.ellipsis, // 텍스트가 넘치면 '...'으로 표시
              ),
            )
        ),

        SizedBox(height: 50.0),

        // 이미지
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
          child: AspectRatio(
            aspectRatio: 16/9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: buildImageLoader([markerPosition], markerPosition['contentid'], g_districtCode!),
            ),
          ),
        ),
        // 설명 텍스트

        SizedBox(height: 50.0),

        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 0.0),
          child: Html(
            data: """
              <p style="font-family: 'Readex Pro', sans-serif; color: white; letter-spacing: 0px;">
                $overViewText
              </p>
            """,
            style: {
              "p": Style(
                fontFamily: 'Readex Pro',
                color: Colors.white,
                letterSpacing: 0.0,
                fontSize: FontSize.large, // labelLarge에 맞는 크기로 설정
              ),
            },
          ),
        ),
      ],
    ),
  );
}

Widget buildCard6(BuildContext context, Map<String, dynamic> markerPosition) {
  String overViewText = markerPosition['overview'] ?? "";
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0),
        // 제목을 이미지 위쪽에 배치
        Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 12.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                markerPosition['name'],
                style: FlutterFlowTheme.of(context).headlineLarge.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  letterSpacing: 0.0,
                ),
                maxLines: 1, // 한 줄로 제한
                overflow: TextOverflow.ellipsis, // 텍스트가 넘치면 '...'으로 표시
              ),
            )
        ),

        SizedBox(height: 50.0),

        // 이미지
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
          child: AspectRatio(
            aspectRatio: 16/9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: buildImageLoader([markerPosition], markerPosition['contentid'], g_districtCode!),
            ),
          ),
        ),
        // 설명 텍스트

        SizedBox(height: 50.0),

        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 0.0),
          child: Html(
            data: """
              <p style="font-family: 'Readex Pro', sans-serif; color: white; letter-spacing: 0px;">
                $overViewText
              </p>
            """,
            style: {
              "p": Style(
                fontFamily: 'Readex Pro',
                color: Colors.white,
                letterSpacing: 0.0,
                fontSize: FontSize.large, // labelLarge에 맞는 크기로 설정
              ),
            },
          ),
        ),
      ],
    ),
  );
}
