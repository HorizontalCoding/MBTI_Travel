import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../flutter_flow/flutter_flow_model.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'selectpage_model.dart';
import 'mbti_model.dart'; // MBTIModel 클래스 가져오기

class SelectpageWidget extends StatefulWidget {
  const SelectpageWidget({super.key});

  @override
  State<SelectpageWidget> createState() => _SelectpageWidgetState();
}

class _SelectpageWidgetState extends State<SelectpageWidget> {
  late SelectpageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // MBTI 리스트 (이미지 경로와 함께)
  final List<String> mbtiTypes = [
    'ISTJ', 'ISFJ', 'INFJ', 'INTJ',
    'ISTP', 'ISFP', 'INFP', 'INTP',
    'ESTP', 'ESFP', 'ENFP', 'ENTP',
    'ESTJ', 'ESFJ', 'ENFJ', 'ENTJ',
  ];

  final List<String> mbtiImages = [
    'assets/mbti/istj.png', 'assets/mbti/isfj.png', 'assets/mbti/infj.png', 'assets/mbti/intj.png',
    'assets/mbti/istp.png', 'assets/mbti/isfp.png', 'assets/mbti/infp.png', 'assets/mbti/intp.png',
    'assets/mbti/estp.png', 'assets/mbti/esfp.png', 'assets/mbti/enfp.png', 'assets/mbti/entp.png',
    'assets/mbti/estj.png', 'assets/mbti/esfj.png', 'assets/mbti/enfj.png', 'assets/mbti/entj.png',
  ];

  String? selectedMbti; // 선택된 MBTI 값을 저장

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectpageModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mbtiModel = Provider.of<MBTIModel>(context, listen: false);

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: const Color(0xFF0C0202),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'MBTI TRAVEL',
            style: TextStyle(
              fontFamily: 'Outfit',
              color: Colors.white,
              fontSize: 22.0,
            ),
          ),
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 50.0, 0.0, 20.0),
                child: Text(
                  'MBTI 선택',
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // 4열로 이미지 배치
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: mbtiTypes.length,
                  itemBuilder: (context, index) {
                    final mbti = mbtiTypes[index];
                    final image = mbtiImages[index];
                    final isSelected = selectedMbti == mbti;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMbti = mbti;
                        });
                        mbtiModel.setMBTI(mbti); // 전역 상태 업데이트
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.transparent,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(image, width: 50.0, height: 50.0),
                            const SizedBox(height: 10.0),
                            Text(
                              mbti,
                              style: TextStyle(
                                color: isSelected ? Colors.blue : Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 80.0),
                child: Text(
                  selectedMbti != null
                      ? 'MBTI는 $selectedMbti가 선택되었습니다'
                      : '당신의 MBTI를 선택해주세요.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 80.0),
                child: FFButtonWidget(
                  onPressed: selectedMbti != null
                      ? () {
                    context.pushNamed(
                      'courseselect',
                      extra: <String, dynamic>{
                        'mbti': selectedMbti,
                      },
                    );
                  }
                      : null, // 선택된 MBTI 없으면 비활성화
                  text: 'NEXT',
                  options: FFButtonOptions(
                    height: 40.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                    color: selectedMbti != null ? Colors.blue : Colors.grey,
                    textStyle: const TextStyle(
                      fontFamily: 'Readex Pro',
                      color: Colors.white,
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