import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../flutter_flow/flutter_flow_model.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'selectpage_model.dart';
import 'mbti_model.dart'; // MBTIModel 클래스 가져오기
import 'package:mbtitravel/data_frame/data_frame.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectpageWidget extends StatefulWidget
{
  const SelectpageWidget({super.key});

  @override
  State<SelectpageWidget> createState() => _SelectpageWidgetState();
}

class _SelectpageWidgetState extends State<SelectpageWidget>
{
  late SelectpageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // MBTI_URL 함수
  Future<void> _launchURL( ) async
  {
    const String MBTI_URL = 'https://www.16personalities.com/ko/';
    final Uri _url = Uri.parse(MBTI_URL);
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) { // 외부 브라우저에서 열기
      throw 'Could not launch $MBTI_URL';
    }
  }

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
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 30.0),
                // 상단 MBTI 텍스트는 단순 출력만 함
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 15.0),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    width: 300.0, // 원하는 너비를 직접 설정
                    constraints: const BoxConstraints(
                      minHeight: 60.0, // 최소 높이를 유지
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedMbti != null ? getMbtiColor(selectedMbti) : Colors.grey[600]!, // 테두리 색상
                        width: 2.0, // 테두리 두께
                      ),
                      borderRadius: BorderRadius.circular(12.0), // 테두리 둥글게
                    ),
                    child: Container(
                      alignment: Alignment.center, // 텍스트 중앙 정렬
                      child: RichText(
                        textAlign: TextAlign.center, // 텍스트 가로 중앙 정렬
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
                                alignment: PlaceholderAlignment.middle, // 텍스트 중앙 정렬
                                child: Text(
                                  '$selectedMbti',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: getMbtiColor(selectedMbti), // 텍스트 색상
                                    height: 1.2, // 텍스트 높이 조정
                                  ),
                                ),
                              ),
                            ] else ...[
                              TextSpan(
                                text: '당신의 MBTI를 선택해주세요.', // 기본 텍스트
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.grey[600], // 기본 텍스트 색상
                                  height: 1.2, // 텍스트 높이 조정
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30.0),

                // GridView
                GridView.builder(
                  shrinkWrap: true,
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
                            width: 2.5,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(image, width: 100.0, height: 100.0, fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                ),

                // "다음으로" 버튼
                Padding(
                  padding: const EdgeInsets.only(top: 20.0), // 버튼을 아래로 내리기 위해 상단 여백 설정
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedMbti != null ? getMbtiColor(selectedMbti) : Colors.grey[400]!, // 배경 색상
                            fixedSize: const Size(180, 50), // 버튼의 고정된 너비와 높이를 설정
                            padding: EdgeInsets.zero, // 패딩 제거
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0), // 버튼 모서리 둥글게
                            ),
                          ),
                          child: Container(
                            alignment: Alignment.center, // 텍스트를 버튼 내부에서 중앙에 배치
                            child: const Text(
                              '다음',
                              style: TextStyle(
                                fontSize: 22, // 텍스트 크기
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // 텍스트 색상
                                fontFamily: '맑은고딕', // 특정 글꼴 설정
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10), // 버튼과 텍스트 사이의 간격
                        TextButton(
                          onPressed: () => _launchURL( ), // 원하는 URL로 이동
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(10.0), // 터치 영역을 넓히기 위한 패딩
                            backgroundColor: Colors.transparent, // 버튼 배경 투명하게
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero, // 외곽선 없애기
                              side: BorderSide(color: Colors.transparent), // 외곽선 투명하게 설정
                            ),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.blue, // 밑줄 색상
                                  width: 1.0, // 밑줄 두께
                                ),
                              ),
                            ),
                            child: const Text(
                              'MBTI에 대해서 모르시나요?',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue, // 텍스트 색상
                              ),
                            ),
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
      ),
    );
  }
}
