import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math'; // 랜덤 선택을 위해 추가
import 'h_o_m_e_page_model.dart';
import 'package:mbtitravel/data_frame/fastival_frame.dart';
export 'h_o_m_e_page_model.dart';

class HOMEPageWidget extends StatefulWidget {
  const HOMEPageWidget({super.key});

  @override
  State<HOMEPageWidget> createState() => _HOMEPageWidgetState();
}

class _HOMEPageWidgetState extends State<HOMEPageWidget> {
  late HOMEPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String festivalIntro = ''; // 필터링된 축제의 intro를 저장할 변수

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HOMEPageModel());

    // CSV 데이터를 불러온 후 intro 값을 필터링하는 함수
    _loadFestivalIntro();
  }

  void _loadFestivalIntro() {
    // 현재 월 가져오기
    int currentMonth = DateTime.now().month;

    // 현재 월과 일치하는 축제들 필터링
    final matchingFestivals = g_markerPositions.where(
          (festival) => festival['festival_month'] == currentMonth,
    ).toList();

    if (matchingFestivals.isNotEmpty) {
      // 랜덤으로 하나의 축제를 선택
      final randomFestival = matchingFestivals[Random().nextInt(matchingFestivals.length)];

      setState(() {
        // 필터링된 축제의 intro 저장
        festivalIntro = randomFestival['intro'];
      });
    } else {
      setState(() {
        festivalIntro = '이번 달에 해당하는 축제가 없습니다.';
      });
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 200.0, 0.0, 30.0),
                  child: Text(
                    'MBTI TRAVEL',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Readex Pro',
                      color: Colors.white,
                      fontSize: 50.0,
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    context.pushNamed('Selectpage');
                  },
                  text: 'start',
                  options: FFButtonOptions(
                    height: 40.0,
                    padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Colors.black,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Readex Pro',
                      color: Colors.white,
                      letterSpacing: 0.0,
                    ),
                    elevation: 3.0,
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.center, // 텍스트를 화면 중간에 위치
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0), // 하단 패딩을 줄여 텍스트를 조금 위로 올림
                    child: Text(
                      festivalIntro, // 필터링된 축제의 intro 출력
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
