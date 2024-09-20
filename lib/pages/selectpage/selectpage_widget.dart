import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../flutter_flow/flutter_flow_model.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'selectpage_model.dart';
import 'mbti_model.dart'; // MBTIModel 클래스 가져오기
import 'package:mbtitravel/data_frame/data_frame.dart';

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
    'assets/images/Mbti_Tile_Images/ISTJ.png',
    'assets/images/Mbti_Tile_Images/ISFJ.png',
    'assets/images/Mbti_Tile_Images/INFJ.png',
    'assets/images/Mbti_Tile_Images/INTJ.png',
    'assets/images/Mbti_Tile_Images/ISTP.png',
    'assets/images/Mbti_Tile_Images/ISFP.png',
    'assets/images/Mbti_Tile_Images/INFP.png',
    'assets/images/Mbti_Tile_Images/INTP.png',
    'assets/images/Mbti_Tile_Images/ESTP.png',
    'assets/images/Mbti_Tile_Images/ESFP.png',
    'assets/images/Mbti_Tile_Images/ENFP.png',
    'assets/images/Mbti_Tile_Images/ENTP.png',
    'assets/images/Mbti_Tile_Images/ESTJ.png',
    'assets/images/Mbti_Tile_Images/ESFJ.png',
    'assets/images/Mbti_Tile_Images/ENFJ.png',
    'assets/images/Mbti_Tile_Images/ENTJ.png',
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

  Color getMbtiColor(String? mbti) {
    switch (mbti) {
      case 'ISTJ':
        return Color(0xFFFF8787);
      case 'ISTP':
        return Color(0xFFFE9886);
      case 'ISFJ':
        return Color(0xFFFFCFAD);
      case 'ISFP':
        return Color(0xFFFFF2BC);
      case 'INTP':
        return Color(0xFFB7FE9E);
      case 'INFJ':
        return Color(0xFF88FFAC);
      case 'ESTJ':
        return Color(0xFF78EBFF);
      case 'INFP':
        return Color(0xFF99F8EC);
      case 'ESTP':
        return Color(0xFFA1E0FF);
      case 'INTJ':
        return Color(0xFF88F4C2);
      case 'ESFJ':
        return Color(0xFFA6BFFE);
      case 'ESFP':
        return Color(0xFFD0B8FF);
      case 'ENTJ':
        return Color(0xFFE289FF);
      case 'ENTP':
        return Color(0xFFE6AAFA);
      case 'ENFJ':
        return Color(0xFFF9AEF7);
      case 'ENFP':
        return Color(0xFFFFA1C6);
      default:
        return Colors.black; // 기본 색상
    }
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF7996BE),
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
            'MBTI 선택',
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
          child: SingleChildScrollView( // 추가: 스크롤 가능하게 처리
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0), // 상단/하단 패딩을 10으로 줄임
                ),
                GridView.builder(
                  shrinkWrap: true, // 추가: GridView 크기 조절
                  physics: const NeverScrollableScrollPhysics(), // GridView 자체 스크롤을 비활성화
                  padding: const EdgeInsets.all(15.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // 4열로 이미지 배치
                    crossAxisSpacing: 5.0, // 이미지 간의 가로 간격
                    mainAxisSpacing: 10.0, // 이미지 간의 세로 간격 (행 간격)
                    childAspectRatio: 1.0, // 이미지 비율을 1:1로 설정
                  ),
                  itemCount: mbtiTypes.length,
                  itemBuilder: (context, index) {
                    final mbti = mbtiTypes[index];
                    final image = mbtiImages[index];
                    final isSelected = selectedMbti == mbti;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          g_mbtiStringValue = mbti;
                          selectedMbti = mbti;
                        });
                        mbtiModel.setMBTI(mbti); // 전역 상태 업데이트
                      },
                      child: Container(
                        width: 100, // 이미지 크기와 동일하게 설정
                        height: 100, // 이미지 크기와 동일하게 설정
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.transparent,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ClipRRect( // 이미지의 모서리도 둥글게 설정
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(image, width: 100.0, height: 100.0, fit: BoxFit.cover), // 이미지를 꽉 채워 표시
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 70.0, 0.0, 15.0),
                  child: Container(
                    padding: const EdgeInsets.all(12.0), // 텍스트와 테두리 사이 여백
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedMbti != null ? getMbtiColor(selectedMbti) : Colors.grey[600]!, // 테두리 색상 선택
                        width: 2.0, // 테두리 두께
                      ),
                      borderRadius: BorderRadius.circular(12.0), // 테두리 둥글게
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black, // 기본 텍스트 색상
                        ),
                        children: [
                          if (selectedMbti != null) ...[
                            TextSpan(
                              text: 'MBTI  :  ', // 'MBTI :' 텍스트만 회색으로 변경
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.grey[600], // 'MBTI :' 색상 변경
                              ),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline, // 기준선을 맞추는 속성
                              baseline: TextBaseline.alphabetic, // 텍스트의 baseline을 사용
                              child: selectedMbti == 'ISFP'
                                  ? Stack(
                                children: <Widget>[
                                  // 외곽선 텍스트
                                  Text(
                                    '$selectedMbti',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 0.5 // 외곽선 두께
                                        ..color = Colors.black, // 테두리 색상
                                    ),
                                  ),
                                  // 내부 채운 텍스트
                                  Text(
                                    '$selectedMbti',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: getMbtiColor(selectedMbti), // 텍스트 색상
                                    ),
                                  ),
                                ],
                              )
                                  : Text(
                                '$selectedMbti',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: getMbtiColor(selectedMbti), // 텍스트 색상
                                ),
                              ),
                            ),
                          ] else ...[
                            TextSpan(
                              text: '당신의 MBTI를 선택해주세요.', // 기본 텍스트
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.grey[600], // 기본 텍스트 색상
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 50.0, 0.0, 0.0),
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
                    text: '다음',
                    options: FFButtonOptions(
                      // 버튼 높이
                      height: 50.0,
                      // 버튼 쪽 사이즈
                      padding: const EdgeInsetsDirectional.fromSTEB(34.0, 0.0, 34.0, 0.0),
                      // 선택된 MBTI에 따라 색상 변경, 선택되지 않았을 때 투명
                      color: selectedMbti != null ? getMbtiColor(selectedMbti) : Colors.transparent,
                      textStyle: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,  // 텍스트 색상은 항상 하얀색으로 유지
                        fontSize: 18.0, // 폰트 크기 설정
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      // 투명할 때에도 경계가 보이도록 테두리 설정
                      borderSide: BorderSide(
                        color: selectedMbti != null ? getMbtiColor(selectedMbti) : Colors.white, // 선택되지 않았을 때 하얀색 테두리
                        width: 2.0, // 테두리 두께
                      ),
                      elevation: 0.0, // 그림자 제거
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
