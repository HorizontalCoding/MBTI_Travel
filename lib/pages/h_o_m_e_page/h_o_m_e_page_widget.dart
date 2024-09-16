import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'h_o_m_e_page_model.dart';
export 'h_o_m_e_page_model.dart';

class HOMEPageWidget extends StatefulWidget {
  const HOMEPageWidget({super.key});

  @override
  State<HOMEPageWidget> createState() => _HOMEPageWidgetState();
}

class _HOMEPageWidgetState extends State<HOMEPageWidget> {
  late HOMEPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding:
                  //     좌상오햐
                  EdgeInsetsDirectional.fromSTEB(10.0, 200.0, 10.0, 30.0),
                  child:Image.asset(
                    'assets/images/logo_files/MBTI_TRAVEL_LOGO.png', // 여기에 사용할 이미지 경로를 입력
                    width: 310.0,  // 이미지의 너비
                    height: 175.0, // 이미지의 높이
                    fit: BoxFit.cover, // 이미지를 어떻게 맞출지 설정 (cover로 설정하여 비율 유지)
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0,90.0, 0.0, 0.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    context.pushNamed('Selectpage');
                  },
                  text: '시작',
                  options: FFButtonOptions(
                    height: 40.0,
                    padding:
                    EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                    iconPadding:
                    EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: Colors.blue,
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
            ],
          ),
        ),
      ),
    );
  }
}
