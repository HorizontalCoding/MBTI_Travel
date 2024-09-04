import 'dart:async'; // 추가: StreamSubscription을 사용하기 위한 패키지 임포트
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
//import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'rottiepage_model.dart';
export 'rottiepage_model.dart';

import 'package:mbtitravel/pages/selectpage/mbti_model.dart';
import 'package:mbtitravel/pages/courseselect/location_model.dart';
import 'package:mbtitravel/data_frame/data_frame.dart';
import 'package:mbtitravel/function_manager.dart'; // markerPositions이 정의된 파일을 import

import 'package:connectivity_plus/connectivity_plus.dart'; // 네트워크 상태 확인을 위한 패키지
import 'package:fluttertoast/fluttertoast.dart'; // 토스트 메시지 표시를 위한 패키지

class RottiepageWidget extends StatefulWidget {
  const RottiepageWidget({super.key});

  @override
  State<RottiepageWidget> createState() => _RottiepageWidgetState();
}

class _RottiepageWidgetState extends State<RottiepageWidget> {
  late RottiepageModel _model;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription; // 네트워크 상태 변화 감지

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true; // 서버 요청 중인지 여부를 나타내는 변수
  bool _isNavigating = false; // 화면 전환 중인지 여부를 나타내는 변수

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RottiepageModel());

    // 페이지 로드 시 서버와 통신을 시작합니다.
    print("initState called");
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // 네트워크 상태를 확인하는 함수 호출
      await checkNetworkAndNavigate();
    });

    // 네트워크 상태 변화를 감지
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        // 네트워크 연결이 끊어졌을 때 처리
        Fluttertoast.showToast(
          msg: "네트워크 연결이 끊어졌습니다. 코스선택 화면으로 돌아갑니다.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context); // 코스선택 화면으로 돌아가기
      }
    });
  }

  // 네트워크 상태를 확인하고, 네트워크가 없으면 이전 화면으로 이동
  Future<void> checkNetworkAndNavigate() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    // 네트워크 연결이 없을 경우 이전 화면으로 이동
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(
        msg: "네트워크에 연결되어 있지 않습니다.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.pop(context); // 현재 화면을 닫고 이전 화면으로 돌아감
    } else {
      // 네트워크 연결이 있을 경우 서버로 데이터 전송 시작
      print("fetchRecommendations called");
      await fetchRecommendations();
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel(); // 네트워크 상태 변화 감지 구독 해제
    super.dispose();
  }

  // 서버로 데이터를 전송하는 함수
  Future<void> fetchRecommendations() async {
    final url = Uri.parse(PROD_URL);
    final mbtiValue = Provider.of<MBTIModel>(context, listen: false).mbti;
    final selectedArea = Provider.of<LocationModel>(context, listen: false).selectedLocation;
    final markerPositionsModel = Provider.of<MarkerPositionsModel>(context, listen: false);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'mbti': mbtiValue, 'search_word': selectedArea}),
      );

      if (response.statusCode == 200) {
        print('Data sent to server successfully.');
        final jsonResponse = json.decode(response.body);

        // 서버에서 받은 데이터를 기존과 같은 방식으로 처리
        final markerPositions = List<Map<String, dynamic>>.from(
          jsonResponse.asMap().entries.map((entry) => {
            'id': entry.key + 1, // id는 1부터 시작
            'name': entry.value['VISIT_AREA_NM'],
            'lat': entry.value['Y_COORD'],
            'lng': entry.value['X_COORD'],
            'tourkey': entry.value['TOUR_KEYWORD'],
          }),
        );

        // Provider를 통해 상태를 업데이트
        markerPositionsModel.updateMarkerPositions(markerPositions);

        // debugPrint("들어온 DATA : ${markerPositions}"); // 업데이트 된 markerPositions 리스트 디버깅
        // debugPrint("들어온 MBTI DATA : ${mbtiValue}"); // 업데이트 된 MBTI 데이터 디버깅
        // debugPrint("들어온 여행 지역 DATA : ${selectedArea}"); // 업데이트 된 여행지역 디버깅

        // 화면 전환 중 플래그 설정
        setState(() {
          _isNavigating = true;
        });

        // 화면 전환
        await context.pushNamed('locationexplainCopy');

        // 화면 전환이 완료되면 로딩 상태 해제
        setState(() {
          _isLoading = false;
          _isNavigating = false;
        });
      } else {
        print('Failed to send data to the server.');
      }
    } catch (e) {
      print('Error sending data to server: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 서버 요청 중이거나 화면 전환 중일 때는 뒤로 가기 동작을 막음
        if (_isLoading || _isNavigating) {
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: GestureDetector(
        onTap: () => _model.unfocusNode.canRequestFocus
            ? FocusScope.of(context).requestFocus(_model.unfocusNode)
            : FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            actions: [],
            centerTitle: false,
            elevation: 2.0,
          ),
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Lottie.network(
                    'https://lottie.host/9c880513-ce22-4092-83a1-fb2163431bcb/X5eYZ8iT6u.json',
                    width: 400.0,
                    height: 250.0,
                    fit: BoxFit.contain,
                    animate: true,
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, 30.0),
                  child: Text(
                    '추천 여행지를 불러오는 중입니다...',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Readex Pro',
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}