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
  State<LocationexplainCopyWidget> createState() =>
      _LocationexplainCopyWidgetState();
}

class _LocationexplainCopyWidgetState extends State<LocationexplainCopyWidget>
    with TickerProviderStateMixin
{
  late LocationexplainCopyModel _model;



  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState()
  {
    super.initState(); // 부모 클래스의 initState를 먼저 호출

    // _model을 먼저 초기화한 후에 pageController를 초기화
    _model = createModel(context, () => LocationexplainCopyModel());

    // PageController 초기화
    _model.pageController = PageController();

    // 여기 수정함 2024-08-29 오후4:22
    // 다른 초기화 작업들f
    // _model.tabBarController = TabController(
    //   vsync: this,
    //   length: 3,
    //   initialIndex: 0,
    // )..addListener(() {
    //   setState(() {});
    // });

    //  여기 수정함 2024-08-31 오전11:00
    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(()
    {
      if (_model.tabBarController?.index != 0)
      {
        // 코스 탭이 아닌 경우에만 업데이트
        setState(() {});
      }
    });


    // 초기 좌표 정해줌.
    initializeKakaoMapPosition();

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    // 지도 스와이핑 코드
    // TabController에 리스너 추가
    _model.tabBarController?.addListener(()
    {
      final markerPositionsModel = Provider.of<MarkerPositionsModel>(context, listen: false);
      final mapModel = Provider.of<MapModel>(context, listen: false);
      final markerPositions = markerPositionsModel.markerPositions;

      // 업데이트 될 떄마다.
      if (_model.tabBarController?.index == 2)
      {
        // print("지도 실행");
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

    _initializeMarkersAndImages();


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

  // 모델 초기화 함수
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
      /*print('지도 초기화 완료!');

      print("tourkey 키[0] 값 : ${markerPositions[0]['tourkey']}");
      print("tourkey 키[1] 값 : ${markerPositions[1]['tourkey']}");
      print("tourkey 키[2] 값 : ${markerPositions[2]['tourkey']}");
      print("tourkey 키[3] 값 : ${markerPositions[3]['tourkey']}");
      print("tourkey 키[4] 값 : ${markerPositions[4]['tourkey']}");
      print("tourkey 키[5] 값 : ${markerPositions[5]['tourkey']}");
      print("tourkey 키[5] 값 : ${markerPositions[6]['tourkey']}");*/

    }
    else
    {
      print('지도 초기화 실패');
    }
  }

  Future<void> _initializeMarkersAndImages() async
  {
    final markerPositionsModel = Provider.of<MarkerPositionsModel>(context, listen: false);
    final markerPositions = markerPositionsModel.markerPositions;
    try
    {
      // TOUR API 키를 사용하여 데이터를 초기화 시점에서 받아옴
      await markerPositionsModel.fetchAndUpdateData(tourApiKey);
      print('받아온 데이터: ${markerPositions}');
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
                  if (shouldPop == true) {
                    // 사용자가 "예"를 선택했을 때 두 번 pop 수행
                    markerPositions.clear();
                    for (int popIndex = 0; popIndex < 2; popIndex++) {
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
                        /*여기 여행지 이름 들어갈 곳*/
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
                              Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 1.0),
                                      child: Container(
                                        width: 100.0,
                                        height: 148.0,
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 0.0,
                                              color: Color(0xFFE0E3E7),
                                              offset: Offset(
                                                0.0,
                                                1.0,
                                              ),
                                            )
                                          ],
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              4.0, 0.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 24.0,
                                                child: Stack(
                                                  alignment:
                                                  const AlignmentDirectional(
                                                      0.0, 0.0),
                                                  children: [
                                                    Align(
                                                      alignment:
                                                      const AlignmentDirectional(
                                                          0.0, -0.7),
                                                      child: Container(
                                                        width: 12.0,
                                                        height: 12.0,
                                                        decoration: BoxDecoration(
                                                          color:
                                                          FlutterFlowTheme.of(
                                                              context)
                                                              .primary,
                                                          shape: BoxShape.circle,
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                      MainAxisSize.max,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: [
                                                        VerticalDivider(
                                                          thickness: 2.0,
                                                          color:
                                                          FlutterFlowTheme.of(
                                                              context)
                                                              .primary,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(4.0, 30.0, 0.0, 0.0),
                                                child: Container(
                                                  width: 77.0,
                                                  height: 77.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                    FlutterFlowTheme.of(context)
                                                        .accent1,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: FlutterFlowTheme.of(
                                                          context)
                                                          .primary,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(50.0),
                                                    /*1번 썸네일 이미지*/
                                                    child: buildThumbnailLoader(context, markerPositions[0]['contentid'], markerPositionsModel),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      16.0, 16.0, 16.0, 12.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                        MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            /*첫 번째 장소 이름*/
                                                            '${markerPositions[0]['name']}'
                                                                .replaceAll(RegExp(r',\s*'), ',\n')
                                                                .trim(),
                                                            style: FlutterFlowTheme.of(context).displaySmall.override(
                                                              fontFamily: 'Outfit',
                                                              color: Colors.white,
                                                              fontSize: 16.0,
                                                              letterSpacing: 0.0,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 30.0,
                                                            0.0, 0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                          MainAxisSize.max,
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0.0,
                                                                    15.0,
                                                                    0.0,
                                                                    0.0),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    if (_model.tabBarController != null) {
                                                                      // '코스설명' 탭으로 이동
                                                                      _model.tabBarController!.animateTo(1);

                                                                      Future.delayed(Duration(milliseconds: 100), () {
                                                                        if (_model.pageController.hasClients && _model.pageController.page != 0) {
                                                                          // 현재 페이지가 0번이 아닌 경우에만 이동
                                                                          _model.pageController.animateToPage(
                                                                            0, // 0번 카드로 이동
                                                                            duration: Duration(milliseconds: 300), // 애니메이션 지속 시간
                                                                            curve: Curves.easeInOut, // 애니메이션 커브
                                                                          );
                                                                        } else {
                                                                          print("이미 0번째 카드에 있습니다.");
                                                                        }
                                                                      });
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                    '장소설명',
                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      fontFamily: 'Readex Pro',
                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0.0,
                                                                  15.0,
                                                                  0.0,
                                                                  0.0),
                                                              child: InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                Colors
                                                                    .transparent,
                                                                onTap: () async
                                                                {
                                                                  // 카카오맵 호출 코드
                                                                  // openKakaoMapAtCoordinates(1, markerPositions);
                                                                  if (_model.tabBarController != null)
                                                                  {
                                                                    _model.tabBarController!.animateTo(2); // "지도" 탭의 인덱스가 2
                                                                  }

                                                                  Provider.of<MapModel>(context, listen: false).updateCoordinates(
                                                                    markerPositions[0]['lat'],  // 새 lat 값
                                                                    markerPositions[0]['lng'],  // 새 lng 값
                                                                    3,                         // 새 zoomLevel 값
                                                                  );

                                                                  debugPrint("첫번쨰 카카오 클릭");
                                                                },
                                                                child: Text(
                                                                  'kakao map',
                                                                  style: FlutterFlowTheme
                                                                      .of(context)
                                                                      .labelMedium
                                                                      .override(
                                                                    fontFamily:
                                                                    'Readex Pro',
                                                                    letterSpacing:
                                                                    0.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0.0,
                                                                  15.0,
                                                                  0.0,
                                                                  0.0),
                                                              child: InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                Colors
                                                                    .transparent,
                                                                onTap: () async {},
                                                                child: Icon(
                                                                  Icons
                                                                      .chevron_right_rounded,
                                                                  color: FlutterFlowTheme
                                                                      .of(context)
                                                                      .secondaryText,
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
                                      ).animateOnPageLoad(animationsMap[
                                      'containerOnPageLoadAnimation1']!),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 1.0),
                                      child: Container(
                                        width: 100.0,
                                        height: 148.0,
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 0.0,
                                              color: Color(0xFFE0E3E7),
                                              offset: Offset(
                                                0.0,
                                                1.0,
                                              ),
                                            )
                                          ],
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              4.0, 0.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 24.0,
                                                child: Stack(
                                                  alignment:
                                                  const AlignmentDirectional(
                                                      0.0, 0.0),
                                                  children: [
                                                    Align(
                                                      alignment:
                                                      const AlignmentDirectional(
                                                          0.0, -0.7),
                                                      child: Container(
                                                        width: 12.0,
                                                        height: 12.0,
                                                        decoration: BoxDecoration(
                                                          color:
                                                          FlutterFlowTheme.of(
                                                              context)
                                                              .primary,
                                                          shape: BoxShape.circle,
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                      MainAxisSize.max,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: [
                                                        VerticalDivider(
                                                          thickness: 2.0,
                                                          color:
                                                          FlutterFlowTheme.of(
                                                              context)
                                                              .primary,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(4.0, 30.0, 0.0, 0.0),
                                                child: Container(
                                                  width: 77.0,
                                                  height: 77.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                    FlutterFlowTheme.of(context)
                                                        .accent1,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: FlutterFlowTheme.of(
                                                          context)
                                                          .primary,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(50.0),
                                                    /*2번 썸네일 이미지*/
                                                    child: buildThumbnailLoader(context, markerPositions[1]['contentid'], markerPositionsModel),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      16.0, 16.0, 16.0, 12.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                        MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            /*두 번째 장소 이름*/
                                                            '${markerPositions[1]['name']}'
                                                                .replaceAll(RegExp(r',\s*'), ',\n')
                                                                .trim(),
                                                            style: FlutterFlowTheme.of(context).displaySmall.override(
                                                              fontFamily: 'Outfit',
                                                              color: Colors.white,
                                                              fontSize: 16.0,
                                                              letterSpacing: 0.0,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 30.0,
                                                            0.0, 0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                          MainAxisSize.max,
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0.0,
                                                                    15.0,
                                                                    0.0,
                                                                    0.0),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    if (_model.tabBarController != null) {
                                                                      // '코스설명' 탭으로 이동
                                                                      _model.tabBarController!.animateTo(1);

                                                                      Future.delayed(Duration(milliseconds: 100), () {
                                                                        if (_model.pageController.hasClients && _model.pageController.page != 1) {
                                                                          // 현재 페이지가 1번이 아닌 경우에만 이동
                                                                          _model.pageController.animateToPage(
                                                                            1, // 1번 카드로 이동
                                                                            duration: Duration(milliseconds: 300), // 애니메이션 지속 시간
                                                                            curve: Curves.easeInOut, // 애니메이션 커브
                                                                          );
                                                                        } else {
                                                                          print("이미 1번째 카드에 있습니다.");
                                                                        }
                                                                      });
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                    '장소설명',
                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      fontFamily: 'Readex Pro',
                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                                                              child: InkWell(
                                                                splashColor: Colors.transparent,
                                                                focusColor: Colors.transparent,
                                                                hoverColor: Colors.transparent,
                                                                highlightColor: Colors.transparent,
                                                                onTap: ()
                                                                {
                                                                  // 여기에 원하는 동작을 추가합니다. 예시로 콘솔 출력:
                                                                  //openKakaoMapAtCoordinates(2, markerPositions);

                                                                  if (_model.tabBarController != null)
                                                                  {
                                                                    _model.tabBarController!.animateTo(2); // "지도" 탭의 인덱스가 2
                                                                  }

                                                                  Provider.of<MapModel>(context, listen: false).updateCoordinates(
                                                                    markerPositions[1]['lat'],  // 새 lat 값
                                                                    markerPositions[1]['lng'],  // 새 lng 값
                                                                    3,                         // 새 zoomLevel 값
                                                                  );

                                                                  debugPrint("두 번쨰 카카오 클릭");
                                                                },
                                                                child: Text(
                                                                  'kakao map',
                                                                  style: FlutterFlowTheme.
                                                                  of(context).
                                                                  labelMedium.
                                                                  override(
                                                                    fontFamily: 'Readex Pro',
                                                                    letterSpacing: 0.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0.0,
                                                                  15.0,
                                                                  0.0,
                                                                  0.0),
                                                              child: Icon(
                                                                Icons
                                                                    .chevron_right_rounded,
                                                                color: FlutterFlowTheme
                                                                    .of(context)
                                                                    .secondaryText,
                                                                size: 24.0,
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
                                      ).animateOnPageLoad(animationsMap[
                                      'containerOnPageLoadAnimation2']!),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 1.0),
                                      child: Container(
                                        width: 100.0,
                                        height: 148.0,
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 0.0,
                                              color: Color(0xFFE0E3E7),
                                              offset: Offset(
                                                0.0,
                                                1.0,
                                              ),
                                            )
                                          ],
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              4.0, 0.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 24.0,
                                                child: Stack(
                                                  alignment:
                                                  const AlignmentDirectional(
                                                      0.0, 0.0),
                                                  children: [
                                                    Align(
                                                      alignment:
                                                      const AlignmentDirectional(
                                                          0.0, -0.7),
                                                      child: Container(
                                                        width: 12.0,
                                                        height: 12.0,
                                                        decoration: BoxDecoration(
                                                          color:
                                                          FlutterFlowTheme.of(
                                                              context)
                                                              .primary,
                                                          shape: BoxShape.circle,
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                      MainAxisSize.max,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: [
                                                        VerticalDivider(
                                                          thickness: 2.0,
                                                          color:
                                                          FlutterFlowTheme.of(
                                                              context)
                                                              .primary,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(4.0, 30.0, 0.0, 0.0),
                                                child: Container(
                                                  width: 77.0,
                                                  height: 77.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                    FlutterFlowTheme.of(context)
                                                        .accent1,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: FlutterFlowTheme.of(
                                                          context)
                                                          .primary,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(50.0),
                                                    /*3번 썸네일 이미지*/
                                                    child: buildThumbnailLoader(context, markerPositions[2]['contentid'], markerPositionsModel),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      16.0, 16.0, 16.0, 12.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                        MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            /*세번째 장소 이름*/
                                                            '${markerPositions[2]['name']}'
                                                                .replaceAll(RegExp(r',\s*'), ',\n')
                                                                .trim(),
                                                            style: FlutterFlowTheme.of(context).displaySmall.override(
                                                              fontFamily: 'Outfit',
                                                              color: Colors.white,
                                                              fontSize: 16.0,
                                                              letterSpacing: 0.0,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 30.0,
                                                            0.0, 0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                          MainAxisSize.max,
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0.0,
                                                                    15.0,
                                                                    0.0,
                                                                    0.0),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    if (_model.tabBarController != null) {
                                                                      // '코스설명' 탭으로 이동
                                                                      _model.tabBarController!.animateTo(1);

                                                                      Future.delayed(Duration(milliseconds: 100), () {
                                                                        if (_model.pageController.hasClients && _model.pageController.page != 2) {
                                                                          // 현재 페이지가 2번이 아닌 경우에만 이동
                                                                          _model.pageController.animateToPage(
                                                                            2, // 2번 카드로 이동
                                                                            duration: Duration(milliseconds: 300), // 애니메이션 지속 시간
                                                                            curve: Curves.easeInOut, // 애니메이션 커브
                                                                          );
                                                                        } else {
                                                                          print("이미 2번째 카드에 있습니다.");
                                                                        }
                                                                      });
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                    '장소설명',
                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      fontFamily: 'Readex Pro',
                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                                                              child: InkWell(
                                                                splashColor: Colors.transparent,
                                                                focusColor: Colors.transparent,
                                                                hoverColor: Colors.transparent,
                                                                highlightColor: Colors.transparent,
                                                                onTap: ()
                                                                {
                                                                  // 여기에 원하는 동작을 추가합니다. 예시로 콘솔 출력:
                                                                  // openKakaoMapAtCoordinates(3, markerPositions);

                                                                  if (_model.tabBarController != null)
                                                                  {
                                                                    _model.tabBarController!.animateTo(2); // "지도" 탭의 인덱스가 2
                                                                  }

                                                                  Provider.of<MapModel>(context, listen: false).updateCoordinates(
                                                                    markerPositions[2]['lat'],  // 새 lat 값
                                                                    markerPositions[2]['lng'],  // 새 lng 값
                                                                    3,                         // 새 zoomLevel 값
                                                                  );

                                                                  debugPrint("세 번쨰 카카오 클릭");
                                                                },
                                                                child: Text(
                                                                  'kakao map',
                                                                  style: FlutterFlowTheme.
                                                                  of(context).
                                                                  labelMedium.
                                                                  override(
                                                                    fontFamily: 'Readex Pro',
                                                                    letterSpacing: 0.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0.0,
                                                                  15.0,
                                                                  0.0,
                                                                  0.0),
                                                              child: Icon(
                                                                Icons
                                                                    .chevron_right_rounded,
                                                                color: FlutterFlowTheme
                                                                    .of(context)
                                                                    .secondaryText,
                                                                size: 24.0,
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
                                      ).animateOnPageLoad(animationsMap[
                                      'containerOnPageLoadAnimation3']!),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 1.0),
                                      child: Container(
                                        width: 100.0,
                                        height: 148.0,
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 0.0,
                                              color: Color(0xFFE0E3E7),
                                              offset: Offset(
                                                0.0,
                                                1.0,
                                              ),
                                            )
                                          ],
                                        ),
                                        child: Align(
                                          alignment:
                                          const AlignmentDirectional(0.0, 0.0),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(4.0, 0.0, 0.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 24.0,
                                                  child: Stack(
                                                    alignment:
                                                    const AlignmentDirectional(
                                                        0.0, 0.0),
                                                    children: [
                                                      Align(
                                                        alignment:
                                                        const AlignmentDirectional(
                                                            0.0, -0.7),
                                                        child: Container(
                                                          width: 12.0,
                                                          height: 12.0,
                                                          decoration: BoxDecoration(
                                                            color:
                                                            FlutterFlowTheme.of(
                                                                context)
                                                                .primary,
                                                            shape: BoxShape.circle,
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                        MainAxisSize.max,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          VerticalDivider(
                                                            thickness: 2.0,
                                                            color:
                                                            FlutterFlowTheme.of(
                                                                context)
                                                                .primary,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      4.0, 30.0, 0.0, 0.0),
                                                  child: Container(
                                                    width: 77.0,
                                                    height: 77.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(
                                                          context)
                                                          .accent1,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: FlutterFlowTheme.of(
                                                            context)
                                                            .primary,
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                      /*4번 썸네일 이미지*/
                                                      child: buildThumbnailLoader(context, markerPositions[3]['contentid'], markerPositionsModel),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        16.0, 16.0, 16.0, 12.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                      MainAxisSize.max,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                          MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              /*네번째 장소 이름*/
                                                              '${markerPositions[3]['name']}'
                                                                  .replaceAll(RegExp(r',\s*'), ',\n')
                                                                  .trim(),
                                                              style: FlutterFlowTheme.of(context).displaySmall.override(
                                                                fontFamily: 'Outfit',
                                                                color: Colors.white,
                                                                fontSize: 16.0,
                                                                letterSpacing: 0.0,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0.0,
                                                              30.0, 0.0, 0.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                            MainAxisSize.max,
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                  padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      0.0,
                                                                      15.0,
                                                                      0.0,
                                                                      0.0),
                                                                  child: InkWell(
                                                                    onTap: () {
                                                                      if (_model.tabBarController != null) {
                                                                        // '코스설명' 탭으로 이동
                                                                        _model.tabBarController!.animateTo(1);

                                                                        Future.delayed(Duration(milliseconds: 100), () {
                                                                          if (_model.pageController.hasClients && _model.pageController.page != 3) {
                                                                            // 현재 페이지가 3번이 아닌 경우에만 이동
                                                                            _model.pageController.animateToPage(
                                                                              3, // 3번 카드로 이동
                                                                              duration: Duration(milliseconds: 300), // 애니메이션 지속 시간
                                                                              curve: Curves.easeInOut, // 애니메이션 커브
                                                                            );
                                                                          } else {
                                                                            print("이미 3번째 카드에 있습니다.");
                                                                          }
                                                                        });
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                      '장소설명',
                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                        fontFamily: 'Readex Pro',
                                                                        color: FlutterFlowTheme.of(context).primary,
                                                                        letterSpacing: 0.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(

                                                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                                                                child: InkWell(
                                                                  splashColor: Colors.transparent,
                                                                  focusColor: Colors.transparent,
                                                                  hoverColor: Colors.transparent,
                                                                  highlightColor: Colors.transparent,
                                                                  onTap: ()
                                                                  {
                                                                    // 여기에 원하는 동작을 추가합니다. 예시로 콘솔 출력:
                                                                    // openKakaoMapAtCoordinates(4, markerPositions);

                                                                    if (_model.tabBarController != null)
                                                                    {
                                                                      _model.tabBarController!.animateTo(2); // "지도" 탭의 인덱스가 2
                                                                    }

                                                                    Provider.of<MapModel>(context, listen: false).updateCoordinates(
                                                                      markerPositions[3]['lat'],  // 새 lat 값
                                                                      markerPositions[3]['lng'],  // 새 lng 값
                                                                      3,                         // 새 zoomLevel 값
                                                                    );

                                                                    debugPrint("네 번쨰 카카오 클릭");
                                                                  },
                                                                  child: Text(
                                                                    'kakao map',
                                                                    style: FlutterFlowTheme.
                                                                    of(context).
                                                                    labelMedium.
                                                                    override(
                                                                      fontFamily: 'Readex Pro',
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0.0,
                                                                    15.0,
                                                                    0.0,
                                                                    0.0),
                                                                child: InkWell(
                                                                  splashColor: Colors
                                                                      .transparent,
                                                                  focusColor: Colors
                                                                      .transparent,
                                                                  hoverColor: Colors
                                                                      .transparent,
                                                                  highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                                  onTap:
                                                                      () async {},
                                                                  child: Icon(
                                                                    Icons
                                                                        .chevron_right_rounded,
                                                                    color: FlutterFlowTheme.of(
                                                                        context)
                                                                        .secondaryText,
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
                                      ).animateOnPageLoad(animationsMap[
                                      'containerOnPageLoadAnimation4']!),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 1.0),
                                      child: Container(
                                        width: 100.0,
                                        height: 148.0,
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 0.0,
                                              color: Color(0xFFE0E3E7),
                                              offset: Offset(
                                                0.0,
                                                1.0,
                                              ),
                                            )
                                          ],
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              4.0, 0.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 24.0,
                                                child: Stack(
                                                  alignment:
                                                  const AlignmentDirectional(
                                                      0.0, 0.0),
                                                  children: [
                                                    Align(
                                                      alignment:
                                                      const AlignmentDirectional(
                                                          0.0, -0.7),
                                                      child: Container(
                                                        width: 12.0,
                                                        height: 12.0,
                                                        decoration: BoxDecoration(
                                                          color:
                                                          FlutterFlowTheme.of(
                                                              context)
                                                              .primary,
                                                          shape: BoxShape.circle,
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                      MainAxisSize.max,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: [
                                                        VerticalDivider(
                                                          thickness: 2.0,
                                                          color:
                                                          FlutterFlowTheme.of(
                                                              context)
                                                              .primary,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(4.0, 30.0, 0.0, 0.0),
                                                child: Container(
                                                  width: 77.0,
                                                  height: 77.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                    FlutterFlowTheme.of(context)
                                                        .accent1,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: FlutterFlowTheme.of(
                                                          context)
                                                          .primary,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(50.0),
                                                    /*5번 썸네일 이미지*/
                                                    child: buildThumbnailLoader(context, markerPositions[4]['contentid'], markerPositionsModel),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      16.0, 16.0, 16.0, 12.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                        MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            /*다섯번째 장소 이름*/
                                                            '${markerPositions[4]['name']}'
                                                                .replaceAll(RegExp(r',\s*'), ',\n')
                                                                .trim(),
                                                            style: FlutterFlowTheme.of(context).displaySmall.override(
                                                              fontFamily: 'Outfit',
                                                              color: Colors.white,
                                                              fontSize: 16.0,
                                                              letterSpacing: 0.0,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 30.0,
                                                            0.0, 0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                          MainAxisSize.max,
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0.0,
                                                                    15.0,
                                                                    0.0,
                                                                    0.0),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    if (_model.tabBarController != null) {
                                                                      // '코스설명' 탭으로 이동
                                                                      _model.tabBarController!.animateTo(1);

                                                                      Future.delayed(Duration(milliseconds: 100), () {
                                                                        if (_model.pageController.hasClients && _model.pageController.page != 4) {
                                                                          // 현재 페이지가 4번이 아닌 경우에만 이동
                                                                          _model.pageController.animateToPage(
                                                                            4, // 4번 카드로 이동
                                                                            duration: Duration(milliseconds: 300), // 애니메이션 지속 시간
                                                                            curve: Curves.easeInOut, // 애니메이션 커브
                                                                          );
                                                                        } else {
                                                                          print("이미 4번째 카드에 있습니다.");
                                                                        }
                                                                      });
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                    '장소설명',
                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      fontFamily: 'Readex Pro',
                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(

                                                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                                                              child: InkWell(
                                                                splashColor: Colors.transparent,
                                                                focusColor: Colors.transparent,
                                                                hoverColor: Colors.transparent,
                                                                highlightColor: Colors.transparent,
                                                                onTap: ()
                                                                {
                                                                  // 여기에 원하는 동작을 추가합니다. 예시로 콘솔 출력:
                                                                  // openKakaoMapAtCoordinates(5, markerPositions);

                                                                  if (_model.tabBarController != null)
                                                                  {
                                                                    _model.tabBarController!.animateTo(2); // "지도" 탭의 인덱스가 2
                                                                  }

                                                                  Provider.of<MapModel>(context, listen: false).updateCoordinates(
                                                                    markerPositions[4]['lat'],  // 새 lat 값
                                                                    markerPositions[4]['lng'],  // 새 lng 값
                                                                    3,                         // 새 zoomLevel 값
                                                                  );

                                                                  debugPrint("다섯 번쨰 카카오 클릭");
                                                                },
                                                                child: Text(
                                                                  'kakao map',
                                                                  style: FlutterFlowTheme.
                                                                  of(context).
                                                                  labelMedium.
                                                                  override(
                                                                    fontFamily: 'Readex Pro',
                                                                    letterSpacing: 0.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0.0,
                                                                  15.0,
                                                                  0.0,
                                                                  0.0),
                                                              child: Icon(
                                                                Icons
                                                                    .chevron_right_rounded,
                                                                color: FlutterFlowTheme
                                                                    .of(context)
                                                                    .secondaryText,
                                                                size: 24.0,
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
                                      ).animateOnPageLoad(animationsMap[
                                      'containerOnPageLoadAnimation5']!),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 1.0),
                                      child: Container(
                                        width: 100.0,
                                        height: 148.0,
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 0.0,
                                              color: Color(0xFFE0E3E7),
                                              offset: Offset(
                                                0.0,
                                                1.0,
                                              ),
                                            )
                                          ],
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              4.0, 0.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 24.0,
                                                child: Stack(
                                                  alignment:
                                                  const AlignmentDirectional(
                                                      0.0, 0.0),
                                                  children: [
                                                    Align(
                                                      alignment:
                                                      const AlignmentDirectional(
                                                          0.0, -0.7),
                                                      child: Container(
                                                        width: 12.0,
                                                        height: 12.0,
                                                        decoration: BoxDecoration(
                                                          color:
                                                          FlutterFlowTheme.of(
                                                              context)
                                                              .primary,
                                                          shape: BoxShape.circle,
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                      MainAxisSize.max,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: [
                                                        VerticalDivider(
                                                          thickness: 2.0,
                                                          color:
                                                          FlutterFlowTheme.of(
                                                              context)
                                                              .primary,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(4.0, 30.0, 0.0, 0.0),
                                                child: Container(
                                                  width: 77.0,
                                                  height: 77.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                    FlutterFlowTheme.of(context)
                                                        .accent1,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: FlutterFlowTheme.of(
                                                          context)
                                                          .primary,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(50.0),
                                                    /*6번 썸네일 이미지*/
                                                    child: buildThumbnailLoader(context, markerPositions[5]['contentid'], markerPositionsModel),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      16.0, 16.0, 16.0, 12.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                        MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            /*여섯번째 장소 이름*/
                                                            '${markerPositions[5]['name']}'
                                                                .replaceAll(RegExp(r',\s*'), ',\n')
                                                                .trim(),
                                                            style: FlutterFlowTheme.of(context).displaySmall.override(
                                                              fontFamily: 'Outfit',
                                                              color: Colors.white,
                                                              fontSize: 16.0,
                                                              letterSpacing: 0.0,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 30.0,
                                                            0.0, 0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                          MainAxisSize.max,
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0.0,
                                                                    15.0,
                                                                    0.0,
                                                                    0.0),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    if (_model.tabBarController != null) {
                                                                      // '코스설명' 탭으로 이동
                                                                      _model.tabBarController!.animateTo(1);

                                                                      Future.delayed(Duration(milliseconds: 100), () {
                                                                        if (_model.pageController.hasClients && _model.pageController.page != 5) {
                                                                          // 현재 페이지가 5번이 아닌 경우에만 이동
                                                                          _model.pageController.animateToPage(
                                                                            5, // 5번 카드로 이동
                                                                            duration: Duration(milliseconds: 300), // 애니메이션 지속 시간
                                                                            curve: Curves.easeInOut, // 애니메이션 커브
                                                                          );
                                                                        } else {
                                                                          print("이미 5번째 카드에 있습니다.");
                                                                        }
                                                                      });
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                    '장소설명',
                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      fontFamily: 'Readex Pro',
                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                                                              child: InkWell(
                                                                splashColor: Colors.transparent,
                                                                focusColor: Colors.transparent,
                                                                hoverColor: Colors.transparent,
                                                                highlightColor: Colors.transparent,
                                                                onTap: ()
                                                                {
                                                                  // 여기에 원하는 동작을 추가합니다. 예시로 콘솔 출력:
                                                                  // openKakaoMapAtCoordinates(6, markerPositions);

                                                                  if (_model.tabBarController != null)
                                                                  {
                                                                    _model.tabBarController!.animateTo(2); // "지도" 탭의 인덱스가 2
                                                                  }

                                                                  Provider.of<MapModel>(context, listen: false).updateCoordinates(
                                                                    markerPositions[5]['lat'],  // 새 lat 값
                                                                    markerPositions[5]['lng'],  // 새 lng 값
                                                                    3,                         // 새 zoomLevel 값
                                                                  );

                                                                  debugPrint("여섯 번쨰 카카오 클릭");
                                                                },
                                                                child: Text(
                                                                  'kakao map',
                                                                  style: FlutterFlowTheme.
                                                                  of(context).
                                                                  labelMedium.
                                                                  override(
                                                                    fontFamily: 'Readex Pro',
                                                                    letterSpacing: 0.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0.0,
                                                                  15.0,
                                                                  0.0,
                                                                  0.0),
                                                              child: Icon(
                                                                Icons
                                                                    .chevron_right_rounded,
                                                                color: FlutterFlowTheme
                                                                    .of(context)
                                                                    .secondaryText,
                                                                size: 24.0,
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
                                      ).animateOnPageLoad(animationsMap[
                                      'containerOnPageLoadAnimation6']!),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 1.0),
                                      child: Container(
                                        width: 100.0,
                                        height: 148.0,
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 0.0,
                                              color: Color(0xFFE0E3E7),
                                              offset: Offset(
                                                0.0,
                                                1.0,
                                              ),
                                            )
                                          ],
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              4.0, 0.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 24.0,
                                                child: Stack(
                                                  alignment:
                                                  const AlignmentDirectional(
                                                      0.0, 0.0),
                                                  children: [
                                                    Align(
                                                      alignment:
                                                      const AlignmentDirectional(
                                                          0.0, -0.7),
                                                      child: Container(
                                                        width: 12.0,
                                                        height: 12.0,
                                                        decoration: BoxDecoration(
                                                          color:
                                                          FlutterFlowTheme.of(
                                                              context)
                                                              .primary,
                                                          shape: BoxShape.circle,
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                      MainAxisSize.max,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: [
                                                        VerticalDivider(
                                                          thickness: 2.0,
                                                          color:
                                                          FlutterFlowTheme.of(
                                                              context)
                                                              .primary,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(4.0, 30.0, 0.0, 0.0),
                                                child: Container(
                                                  width: 77.0,
                                                  height: 77.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                    FlutterFlowTheme.of(context)
                                                        .accent1,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: FlutterFlowTheme.of(
                                                          context)
                                                          .primary,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(50.0),
                                                    /*7번 썸네일 이미지*/
                                                    child: buildThumbnailLoader(context, markerPositions[6]['contentid'], markerPositionsModel),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      16.0, 16.0, 16.0, 12.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                        MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            /*일곱번째 장소 이름*/
                                                            '${markerPositions[6]['name']}'
                                                                .replaceAll(RegExp(r',\s*'), ',\n')
                                                                .trim(),
                                                            style: FlutterFlowTheme.of(context).displaySmall.override(
                                                              fontFamily: 'Outfit',
                                                              color: Colors.white,
                                                              fontSize: 16.0,
                                                              letterSpacing: 0.0,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 30.0,
                                                            0.0, 0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                          MainAxisSize.max,
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0.0,
                                                                    15.0,
                                                                    0.0,
                                                                    0.0),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    if (_model.tabBarController != null) {
                                                                      // '코스설명' 탭으로 이동
                                                                      _model.tabBarController!.animateTo(1);

                                                                      Future.delayed(Duration(milliseconds: 100), () {
                                                                        if (_model.pageController.hasClients && _model.pageController.page != 6) {
                                                                          // 현재 페이지가 6번이 아닌 경우에만 이동
                                                                          _model.pageController.animateToPage(
                                                                            6, // 6번 카드로 이동
                                                                            duration: Duration(milliseconds: 300), // 애니메이션 지속 시간
                                                                            curve: Curves.easeInOut, // 애니메이션 커브
                                                                          );
                                                                        } else {
                                                                          print("이미 6번째 카드에 있습니다.");
                                                                        }
                                                                      });
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                    '장소설명',
                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      fontFamily: 'Readex Pro',
                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(

                                                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                                                              child: InkWell(
                                                                splashColor: Colors.transparent,
                                                                focusColor: Colors.transparent,
                                                                hoverColor: Colors.transparent,
                                                                highlightColor: Colors.transparent,
                                                                onTap: () {
                                                                  // 여기에 원하는 동작을 추가합니다. 예시로 콘솔 출력:
                                                                  // openKakaoMapAtCoordinates(7, markerPositions);

                                                                  if (_model.tabBarController != null)
                                                                  {
                                                                    _model.tabBarController!.animateTo(2); // "지도" 탭의 인덱스가 2
                                                                  }

                                                                  Provider.of<MapModel>(context, listen: false).updateCoordinates(
                                                                    markerPositions[6]['lat'],  // 새 lat 값
                                                                    markerPositions[6]['lng'],  // 새 lng 값
                                                                    3,                         // 새 zoomLevel 값
                                                                  );

                                                                  debugPrint("일곱 번쨰 카카오 클릭");
                                                                },
                                                                child: Text(
                                                                  'kakao map',
                                                                  style: FlutterFlowTheme.
                                                                  of(context).
                                                                  labelMedium.
                                                                  override(
                                                                    fontFamily: 'Readex Pro',
                                                                    letterSpacing: 0.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0.0,
                                                                  15.0,
                                                                  0.0,
                                                                  0.0),
                                                              child: Icon(
                                                                Icons
                                                                    .chevron_right_rounded,
                                                                color: FlutterFlowTheme
                                                                    .of(context)
                                                                    .secondaryText,
                                                                size: 24.0,
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
                                      ).animateOnPageLoad(animationsMap[
                                      'containerOnPageLoadAnimation7']!),
                                    ),
                                  ],
                                ),
                              ),
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
                                            _model.currentIndex = index;
                                          });
                                        },
                                          // PageView.builder에서 각 카드 함수 호출
                                          itemBuilder: (context, index)
                                          {
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
                                              // 이 경로에 도달할 가능성이 없지만, Dart의 null safety 요구사항을 만족시키기 위해 반환값 추가
                                              throw Exception('Invalid index: $index');
                                            }
                                          }
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

/*2024-09-02 썸네일 이미지 로딩 개선(빠른 캐시 로딩)*/
// 공통된 로딩 인디케이터 위젯
Widget buildThumbnailLoader(BuildContext context, String contentId, MarkerPositionsModel markerPositionsModel) {
  if (!markerPositionsModel.isDataLoaded) {
    // 데이터가 로드되지 않았을 때 공통 로딩 인디케이터 사용
    return _buildLoadingIndicator();
  }

  // 데이터가 로드되었으면 이미지를 표시
  return FutureBuilder<String>(
    future: getThumbnailUrl(markerPositionsModel.markerPositions, contentId, ''),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return _buildLoadingIndicator();
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

Widget _buildLoadingIndicator() {
  return Center(
    child: SizedBox(
      width: 24.0,
      height: 24.0,
      child: CircularProgressIndicator(strokeWidth: 2.0),
    ),
  );
}

Widget _buildNetworkImage(String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return CachedNetworkImage(
      imageUrl: 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Thumb_images/%EB%94%94%ED%8F%B4%ED%8A%B8.jpg',
      width: 40.0,
      height: 40.0,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildLoadingIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  return CachedNetworkImage(
    imageUrl: imageUrl,
    width: 40.0,
    height: 40.0,
    fit: BoxFit.cover,
    placeholder: (context, url) => _buildLoadingIndicator(),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}

// 각각의 카드 빌더 함수들 정의
Widget buildCard0(BuildContext context, Map<String, dynamic> markerPosition) {
  String overViewText = markerPosition['overview'] ?? "";
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: buildImageLoader([markerPosition], markerPosition['contentid'], g_districtCode!),
              // markerPosition을 List로 감싸서 전달
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
          child: Text(
            markerPosition['name'],
            style: FlutterFlowTheme.of(context).headlineLarge.override(
              fontFamily: 'Outfit',
              color: Colors.white,
              letterSpacing: 0.0,
            ),
          ),
        ),
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
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: buildImageLoader([markerPosition], markerPosition['contentid'], g_districtCode!),
              // markerPosition을 List로 감싸서 전달
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
          child: Text(
            markerPosition['name'],
            style: FlutterFlowTheme.of(context).headlineLarge.override(
              fontFamily: 'Outfit',
              color: Colors.white,
              letterSpacing: 0.0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
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
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: buildImageLoader([markerPosition], markerPosition['contentid'], g_districtCode!),
              // markerPosition을 List로 감싸서 전달
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
          child: Text(
            markerPosition['name'],
            style: FlutterFlowTheme.of(context).headlineLarge.override(
              fontFamily: 'Outfit',
              color: Colors.white,
              letterSpacing: 0.0,
            ),
          ),
        ),
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
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: buildImageLoader([markerPosition], markerPosition['contentid'], g_districtCode!),
              // markerPosition을 List로 감싸서 전달
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
          child: Text(
            markerPosition['name'],
            style: FlutterFlowTheme.of(context).headlineLarge.override(
              fontFamily: 'Outfit',
              color: Colors.white,
              letterSpacing: 0.0,
            ),
          ),
        ),
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
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: buildImageLoader([markerPosition], markerPosition['contentid'], g_districtCode!),
              // markerPosition을 List로 감싸서 전달
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
          child: Text(
            markerPosition['name'],
            style: FlutterFlowTheme.of(context).headlineLarge.override(
              fontFamily: 'Outfit',
              color: Colors.white,
              letterSpacing: 0.0,
            ),
          ),
        ),
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
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: buildImageLoader([markerPosition], markerPosition['contentid'], g_districtCode!),
              // markerPosition을 List로 감싸서 전달
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
          child: Text(
            markerPosition['name'],
            style: FlutterFlowTheme.of(context).headlineLarge.override(
              fontFamily: 'Outfit',
              color: Colors.white,
              letterSpacing: 0.0,
            ),
          ),
        ),
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
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: buildImageLoader([markerPosition], markerPosition['contentid'], g_districtCode!),
              // markerPosition을 List로 감싸서 전달
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
          child: Text(
            markerPosition['name'],
            style: FlutterFlowTheme.of(context).headlineLarge.override(
              fontFamily: 'Outfit',
              color: Colors.white,
              letterSpacing: 0.0,
            ),
          ),
        ),
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
