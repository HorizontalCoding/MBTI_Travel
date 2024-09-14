import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'dart:async';  // 이 줄을 추가합니다.
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:provider/provider.dart';
import 'courseselect_model.dart';
export 'courseselect_model.dart';

// MBTI 값을 전역적으로 담는 클래스
import 'package:mbtitravel/pages/selectpage/mbti_model.dart';
import 'package:mbtitravel/pages/courseselect/location_model.dart';
import 'package:mbtitravel/data_frame/data_frame.dart';

class CourseselectWidget extends StatefulWidget {
  const CourseselectWidget({super.key});

  @override
  State<CourseselectWidget> createState() => _CourseselectWidgetState();
}

class _CourseselectWidgetState extends State<CourseselectWidget> {
  late CourseselectModel _model;
  late String mbtiValue; // 전역적으로 관리되는 MBTI 값을 저장하는 변수
  late ConnectivityResult _connectivityResult;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  final scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState()
  {
    super.initState();
    _model = createModel(context, () => CourseselectModel());

    // Provider를 통해 전역적으로 관리되는 MBTI 값을 가져옴
    mbtiValue = Provider.of<MBTIModel>(context, listen: false).mbti;

    // 만약 MBTI 값이 설정되지 않았다면, 기본값 설정
    if (mbtiValue.isEmpty) {
      mbtiValue = "ENTJ"; // 기본값으로 ENTJ 설정 (필요시 다른 기본값 설정 가능)
    }

    // 앱 시작 시 네트워크 상태 확인
    checkInitialConnectivity();

    /*네트워크 상태 감시 시작*/
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _connectivityResult = result;
      if (_connectivityResult == ConnectivityResult.none) {
        Fluttertoast.showToast(
          msg: "네트워크 연결이 없습니다.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _model.dispose();
    super.dispose();
  }

  /*처음 코스선택 씬으로 들어갔을 때*/
  void checkInitialConnectivity() async {
    _connectivityResult = await Connectivity().checkConnectivity();
    if (_connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(
        msg: "네트워크 연결이 없습니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  /*이미지 새로 고침을 눌렀는데 네트워크 연결이 안되어 있을 경우*/
  void refreshImage(String baseUrl) {
    if (_connectivityResult == ConnectivityResult.none) {
      // 네트워크 연결이 없을 때 토스트 메시지 표시
      Fluttertoast.showToast(
        msg: "네트워크 연결이 없습니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      setState(() {
        baseUrl = '$baseUrl?${DateTime.now().millisecondsSinceEpoch}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFEDEDED),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1BA004),
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
              Navigator.pop(context);
            },
          ),
          title: Text(
            '지역 선택',
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
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: const AlignmentDirectional(-1.0, 0.0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 20.0),
                      child: Text(
                        '추천 코스',
                        style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: 'Readex Pro',
                          color: Colors.black, // Sets the text color to black
                          letterSpacing: 0.0,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 370.0,
                      height: 50.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEDEDED),
                        shape: BoxShape.rectangle,
                      ),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: [
                          buildCourseCard(
                            context,
                            title: '',
                            location: '춘천시',
                            imageUrl: 'assets/images/course_select_images/춘천시_로고.jpg',
                            selectedDistrictCode: 13,
                            startLat: 37.88470677305922,
                            startLng: 127.71679141252581,
                          ),
                          buildCourseCard(
                            context,
                            title: '',
                            location: '원주시',
                            imageUrl: 'assets/images/course_select_images/원주시_로고.jpg',
                            selectedDistrictCode: 9,
                            startLat: 37.3159015380525,
                            startLng: 127.92228268413562,
                          ),
                          buildCourseCard(
                            context,
                            title: '',
                            location: '강릉시',
                            imageUrl: 'assets/images/course_select_images/강릉시_로고.jpg',
                            selectedDistrictCode: 1,
                            startLat: 37.764520030046846,
                            startLng: 128.8996229241861,
                          ),
                          buildCourseCard(
                            context,
                            title: '',
                            location: '동해시',
                            imageUrl: 'assets/images/course_select_images/동해시_로고.jpg',
                            selectedDistrictCode: 3,
                            startLat: 37.498190615619805,
                            startLng: 129.12440454753516,
                          ),
                          buildCourseCard(
                            context,
                            title: '',
                            location: '태백시',
                            imageUrl: 'assets/images/course_select_images/태백시_로고.jpg',
                            selectedDistrictCode: 14,
                            startLat: 37.17610744592908,
                            startLng: 128.98470899267895,
                          ),
                          buildCourseCard(
                            context,
                            title: '',
                            location: '속초시',
                            imageUrl: 'assets/images/course_select_images/속초시_로고.png',
                            selectedDistrictCode: 5,
                            startLat: 38.190449858239184,
                            startLng: 128.59877121870406,
                          ),
                          buildCourseCard(
                            context,
                            title: '',
                            location: '삼척시',
                            imageUrl: 'assets/images/course_select_images/삼척시_로고.png',
                            selectedDistrictCode: 4,
                            startLat: 37.43030318159421,
                            startLng: 129.1778133554294,
                          ),
                          buildCourseCard(
                            context,
                            title: '',
                            location: '양양군',
                            imageUrl: 'assets/images/course_select_images/양양군_로고.png',
                            selectedDistrictCode: 7,
                            startLat: 38.077475,
                            startLng: 128.625875,
                          ),
                          buildCourseCard(
                            context,
                            title: '',
                            location: '홍천군',
                            imageUrl: 'assets/images/course_select_images/홍천군_로고.jpg',
                            selectedDistrictCode: 16,
                            startLat: 37.689032,
                            startLng: 127.878637,
                          ),
                          buildCourseCard(
                            context,
                            title: '',
                            location: '횡성군',
                            imageUrl: 'assets/images/course_select_images/횡성군_로고.jpg',
                            selectedDistrictCode: 18,
                            startLat: 37.4831961,
                            startLng: 128.0085071,
                          ),
                          buildCourseCard(
                            context,
                            title: '',
                            location: '영월군',
                            imageUrl: 'assets/images/course_select_images/영월군_로고.jpg',
                            selectedDistrictCode: 8,
                            startLat: 37.182433,
                            startLng: 128.480746,
                          ),
                          buildCourseCard(
                            context,
                            title: '',
                            location: '평창군',
                            imageUrl: 'assets/images/course_select_images/평창군_로고.jpg',
                            selectedDistrictCode: 15,
                            startLat: 37.5620242,
                            startLng: 128.4292237,
                          ),
                          buildCourseCard(
                            context,
                            title: '',
                            location: '정선군',
                            imageUrl: 'assets/images/course_select_images/정선군_로고.jpg',
                            selectedDistrictCode: 11,
                            startLat: 37.378957,
                            startLng: 128.650469,
                          ),
                          buildCourseCard(
                            context,
                            title: '',
                            location: '철원군',
                            imageUrl: 'assets/images/course_select_images/철원군_로고.jpg',
                            selectedDistrictCode: 12,
                            startLat: 38.2078046,
                            startLng: 127.2179496,
                          ),
                          buildCourseCard(
                            context,
                            title: '',
                            location: '화천군',
                            imageUrl: 'assets/images/course_select_images/화천군_로고.jpg',
                            selectedDistrictCode: 17,
                            startLat: 38.104466,
                            startLng: 127.70385,
                          ),
                          buildCourseCard(
                            context,
                            title: '',
                            location: '양구군',
                            imageUrl: 'assets/images/course_select_images/양구군_로고.jpg',
                            selectedDistrictCode: 6,
                            startLat: 38.1076432,
                            startLng: 127.9893656,
                          ),
                          buildCourseCard(
                            context,
                            title: '',
                            location: '인제군',
                            imageUrl: 'assets/images/course_select_images/인제군_로고.png',
                            selectedDistrictCode: 10,
                            startLat: 38.065777,
                            startLng: 128.175128,
                          ),
                          buildCourseCard(
                            context,
                            title: '',
                            location: '고성군',
                            imageUrl: 'assets/images/course_select_images/고성군_로고.jpg',
                            selectedDistrictCode: 2,
                            startLat: 38.378973,
                            startLng: 128.47258,
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
    );
  }

  Widget buildCourseCard(
      BuildContext context, {
        required String title,
        required String location,
        required String imageUrl,
        required int selectedDistrictCode,
        required double startLat,
        required double startLng,
      }) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 3.0,
              color: Color(0x411D2429),
              offset: Offset(
                0.0,
                1.0,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              // 경고 대화 상자를 띄우고 사용자가 '예'를 선택한 경우에만 이동 처리
              bool? confirmed = await showDialog<bool>(
                context: context,
                builder: (alertDialogContext) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // 모서리 둥글기 설정
                    ),
                    title: Text(
                      'AI 분석\n',
                      textAlign: TextAlign.center,
                    ),
                    content: RichText(
                      textAlign: TextAlign.center, // 텍스트 가운데 정렬
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'AI 분석을 위한 확인 부탁드리겠습니다. \n\n\n',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          TextSpan(
                            text: '선택한 지역   :     ',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          TextSpan(
                            text: '$location\n\n', // 사용자가 선택한 지역
                            style: TextStyle(
                              color: Colors.lightBlue[300], // 텍스트 강조 색상 변경
                              fontSize: 22, // 더 큰 폰트 사이즈
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'MBTI 유형   :     ',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          TextSpan(
                            text: '$mbtiValue', // 사용자의 MBTI
                            style: TextStyle(
                              color: Colors.red[300], // 강조 색상
                              fontSize: 22, // 더 큰 폰트 사이즈
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '(주의: AI 분석 시에는 뒤로가기 불가능합니다. \n한번 더 확인해주세요.)\n\n',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange, // 강조를 위해 빨간색으로 설정
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center, // 버튼 중앙 정렬
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(alertDialogContext, true),
                                child: Text('예'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(alertDialogContext, false),
                                child: Text('아니오'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );

              // 사용자가 '예'를 선택한 경우에만 실행
              if (confirmed == true) {
                // 선택한 지역 이름을 전역적으로 저장
                Provider.of<LocationModel>(context, listen: false).setLocation(location);

                g_districtCode = selectedDistrictCode;
                g_kakaoMapStartLat = startLat;
                g_kakaoMapStartLng = startLng;
                g_locationName = location;
                // 로딩 화면으로 이동
                context.pushNamed('rottiepage');
              }
            },
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 1.0, 10.0), // 이미지 위쪽에 10.0의 패딩 추가
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: Container(
                        decoration: BoxDecoration(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 이미지와 아이콘을 양쪽에 배치
                          children: [
                            SizedBox(width: 10.0), // 이미지를 오른쪽으로 이동시키기 위해 왼쪽에 여백 추가
                            Image.asset(
                              imageUrl, // 로컬 이미지 경로 사용
                              width: 200.0, // 이미지의 너비를 적절히 설정
                              height: 50.0, // 이미지 높이는 유지
                              fit: BoxFit.contain,
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0), // 아이콘 주위에 여백을 추가
                              child: const Icon(
                                Icons.chevron_right_rounded,
                                color: Color(0xFF57636C),
                                size: 24.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (title.isNotEmpty) // title이 비어있지 않으면 렌더링
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 0.0, 0.0),
                      child: Text(
                        title,
                        style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: 'Outfit',
                          letterSpacing: 0.0,
                        ),
                      ),
                    ),
                ],
              )
          ),
        ),
      ),
    );
  }
}