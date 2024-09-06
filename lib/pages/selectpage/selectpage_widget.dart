import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'selectpage_model.dart';
export 'selectpage_model.dart';

import 'mbti_model.dart'; // MBTIModel 클래스 가져오기

// StatefulWidget으로 상태를 관리하는 위젯 생성

// 상태를 관리하는 위젯입니다. 이 위젯은 사용자가 MBTI를 선택하고,
// "START TRAVEL" 버튼을 눌러 다음 페이지로 이동하는 기능을 제공합니다.
class SelectpageWidget extends StatefulWidget {
  const SelectpageWidget({super.key});

  @override
  State<SelectpageWidget> createState() => _SelectpageWidgetState();
}

class _SelectpageWidgetState extends State<SelectpageWidget> {
  late SelectpageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // initState 모댈(기능) 초기화
  @override
  void initState() {
    super.initState();
    //  모델 초기화
    _model = createModel(context, () => SelectpageModel());

    // 처음 로드될 때 팝업창을 자동으로 띄움
    // WidgetsBinding.instance.addPostFrameCallback((_)
    // {
    //   // 팝업창을 띄우는 함수 호출
    //   _showFullScreenPopup(context);
    // });
  }
  // 위젯(객체)이 사용되다가 필요없을 때 해제 해주는 기능(객체) C++로 생각하면,객체를 만들었고,
  // 다 쓰면 기능(객체)을 해제한다고 보면됨
  // 유형은 리소스, 이벤트 리스너, 모델(위젯) 정리 등
  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }
  //  위젯을 띄우는 함수
  void _showFullScreenPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // 터치하면 팝업창이 사라지도록 설정
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // 팝업창 닫기
          },
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.8), // 배경 색상 설정
            body: Center(
              child: Image.asset(
                'assets/images/MBTI_Scripts.png', // 여기에 삽입할 이미지 경로를 설정
                fit: BoxFit.contain, // 이미지를 화면에 맞게 조정
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 전역적으로 MBTI 값을 관리하기 위해 Provider에서 MBTIModel을 가져옴(final) <= 상수
    final mbtiModel = Provider.of<MBTIModel>(context, listen: false);

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        // 전체 배경색을 검정색으로 설정
        backgroundColor: Colors.black,
        appBar: AppBar(
          // 앱바의 배경색을 설정.
          backgroundColor: const Color(0xFF0C0202),
          automaticallyImplyLeading: false,
          // 아이콘 위젯 부분(뒤로 가기 Arrow 버튼)
          leading: FlutterFlowIconButton(
            // 아이콘 버튼의 경계선 색상 안 보일 것 투명.
            borderColor: Colors.transparent,
            // 아이콘 버튼의 모서리 둥글기
            borderRadius: 30.0,
            //  아이콘 버튼의 경계선 두께
            borderWidth: 1.0,
            // 아이콘 버튼의 크기
            buttonSize: 60.0,
            // 아이콘 지정
            icon: const Icon(
              // 뒤로가기 아이콘
              Icons.arrow_back_rounded,
              // 뒤로가기 아이콘 색상(하얀색)
              color: Colors.white,
              // 아이콘 크기
              size: 30.0,
            ),
            // 뒤로가기 아이콘을 클릭했을 때.
            //  async : 비동기적으로 작업을 처리하겠다.
            //  예를 들어서
            //  1. 버튼을 눌렀다. -> '스택 페이지에서 하나 빼줘!'
            //  2. 'Okey! 알았어! 작업이 완료 되면 실행 할테니, 난 그동안 다른 작업을 하고 있을께!'
            onPressed: () async {
              // context.pushNamed('HOMEPage');
              // 스택 페이지에서 하나 빼라.
              Navigator.pop(context);
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
              Form(
                key: _model.formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 170.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 10.0),
                          child: Text(
                            'MBTI',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              color: Colors.white,
                              fontSize: 20.0,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 30.0),
                          child: Container(
                            width: 191.0, // 너비를 191.0으로 설정
                            child: DropdownButtonFormField<String>(
                              value: _model.dropDownValue,
                              onChanged: (value) async {
                                setState(() => _model.dropDownValue = value);
                                // print("선택된 MBTI 값(selectpage_widget.dart): $value");
                                if (_model.formKey.currentState == null ||
                                    !_model.formKey.currentState!.validate()) {
                                  return;
                                }
                                if (_model.dropDownValue == null) {
                                  return;
                                }
                                // Provider를 통해 전역 MBTI 값 설정
                                if (value != null) {
                                  mbtiModel.setMBTI(value);
                                }
                              },
                              items: [
                                'ISTJ',
                                'ISFJ',
                                'INFJ',
                                'INTJ',
                                'ISTP',
                                'ISFP',
                                'INFP',
                                'INTP',
                                'ESTP',
                                'ESFP',
                                'ENFP',
                                'ENTP',
                                'ESTJ',
                                'ESFJ',
                                'ENFJ',
                                'ENTJ',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                hintText: '당신의 MBTI는?',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).alternate,
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.all(16.0),
                              ),
                              // 드롭다운에서 최대 4개 항목만 보여주고 나머지는 스크롤 가능하게 설정
                              isDense: true,
                              iconSize: 24,
                              menuMaxHeight: 200, // 드롭다운 메뉴의 최대 높이를 설정하여 표시되는 항목 수 제한
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 40.0, 0.0, 0.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              if (_model.dropDownValue != null) {
                                context.pushNamed(
                                  'courseselect',
                                  extra: <String, dynamic>{
                                    'mbti': _model.dropDownValue, // 선택한 MBTI 값을 전달
                                  },
                                );
                                // print("(상수)_model.dropDownValue(selectpage_widget.dart): ${_model.dropDownValue}");
                              }
                            },
                            text: 'START TRAVEL',
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                              color: Colors.black,
                              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                              ),
                              elevation: 3.0,
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).info,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        // 'START TRAVEL'과 아래줄하고의 간격 (일단은 30)
                        const SizedBox(height: 30.0),
                        /* Flutter에서 제스처(터치, 스와이프, 더블탭, 드래그 등) 이벤트를 감지하기 위해 사용하는 위젯입니다. */
                        GestureDetector(
                          onTap: () => _showFullScreenPopup(context),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'MBTI에 대해서 잘 모르시나요?',
                                style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                              const SizedBox(height: 2), // 텍스트와 밑줄 사이의 간격 조정
                              Container(
                                width: 200,
                                height: 0.5, // 밑줄의 두께 조정
                                color: Colors.white, // 밑줄의 색상
                              ),
                            ],
                          ),
                        ),
                      ],
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
