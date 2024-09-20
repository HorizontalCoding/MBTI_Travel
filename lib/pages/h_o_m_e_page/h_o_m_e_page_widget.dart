import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'h_o_m_e_page_model.dart';


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
                      padding: EdgeInsetsDirectional.fromSTEB(10.0, 60.0, 10.0, 30.0),
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
                        padding: EdgeInsets.only(top: 310.0), // 텍스트를 아래로 내리기 위한 여백 추가
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
    );
  }
}
