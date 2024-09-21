import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';  // 토스트 메시지를 위해 import
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'h_o_m_e_page_model.dart';
import 'package:flutter/services.dart'; // SystemNavigator.pop() 사용을 위해 추가


class HOMEPageWidget extends StatefulWidget {
  const HOMEPageWidget({super.key});

  @override
  State<HOMEPageWidget> createState() => _HOMEPageWidgetState();
}

class _HOMEPageWidgetState extends State<HOMEPageWidget> {
  late HOMEPageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HOMEPageModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // 커스텀 토스트 메시지를 보여주는 함수
  void showCustomToast(String message) {
    final fToast = FToast();
    fToast.init(context);

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.black,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/toasticon.png',  // 앱 아이콘 경로
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 12.0),  // 아이콘과 텍스트 사이의 간격
          Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );

    fToast.showToast(
        child: toast,
        toastDuration: const Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                child: child,
                bottom: 80,  // 토스트 메시지가 화면 아래 100px 위치에 표시
              ),
            ],
          );
        }
    );
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    if (currentBackPressTime == null || currentTime.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = currentTime;
      showCustomToast("'뒤로' 버튼을 한 번 더 누르시면 종료됩니다.");
      return false;
    }
    SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop, // WillPopScope로 뒤로 가기 버튼 동작을 제어
      child: GestureDetector(
        onTap: () async {
          context.pushNamed('Selectpage');
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          body: SafeArea(
            top: true,
            child: Stack(
              children: [
                // 배경 이미지
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/background/StartBackgroundImages.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(10.0, 60.0, 10.0, 30.0),
                        child: Image.asset(
                          'assets/images/logo_files/MBTI_TRAVEL_LOGO.png',
                          width: 200.0,
                          height: 175.0,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 310.0), // 텍스트를 아래로 내리기 위한 여백 추가
                          child: Text(
                            '터치하면 다음으로 넘어갑니다',
                            style: FlutterFlowTheme.of(context).titleSmall.override(
                              fontFamily: 'Readex Pro',
                              color: Colors.white,
                              fontSize: 13.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w300, // 얇은 글꼴
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
