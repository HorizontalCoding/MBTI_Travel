// import 'package:flutter/gestures.dart';
// import 'index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/nav/nav.dart';
import 'package:flutter/services.dart';

// 세로 모드 헤더 파일
// import 'package:flutter/services.dart';

// Provider 관련 파일들 추가
import 'package:provider/provider.dart';
import 'pages/selectpage/mbti_model.dart';  // MBTIModel 클래스 파일 가져오기
import 'pages/courseselect/location_model.dart'; // LocationModel 클래스 파일 가져오기
import 'package:mbtitravel/data_frame/data_frame.dart';
import 'pages/locationexplain_copy/map_model.dart'; // MapModel이 정의된 파일
import 'package:kakaomap_webview/kakaomap_webview.dart'; // view_Size 정의된 파일

void main() async {

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // 에러 발생 시 프로그래스 인디케이터 표시
      ),
    );
  };

  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await FlutterFlowTheme.initialize();
  // ##세로 모드 설정##
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    // Provider를 사용하여 MyApp을 래핑
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MBTIModel()),

          ChangeNotifierProvider(create: (context) => LocationModel()),  // LocationModel 추가

          ChangeNotifierProvider(create: (_) => MarkerPositionsModel()),

          ChangeNotifierProvider(create: (context) => KakaoViewSize()), // KakaoViewSize 추가

          ChangeNotifierProvider(
            create: (context) => MapModel(
              lat: 0.0, // 초기 위도 값
              lng: 0.0, // 초기 경도 값
              zoomLevel: 0, // 초기 줌 레벨 값
            ),
          ),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;
  static const platform = MethodChannel('com.mycompany.mbtitravel/api_key');

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  bool displaySplashImage = true;

  @override
  void initState() {
    super.initState();
    _loadApiKeys();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    Future.delayed(const Duration(milliseconds: 1000),
            () => setState(() => _appStateNotifier.stopShowingSplashImage()));
  }

  Future<void> _loadApiKeys() async {
    try {
      final String T_key1 = await platform.invokeMethod('get_Tour_Api_Key');
      final String K_key2 = await platform.invokeMethod('get_Kakao_Api_Key');
      final String T_key3 = await platform.invokeMethod('get_Tour_Encoding_key');

      final String PUBLIC_URL = await platform.invokeMethod('GET_PUBLIC_PROD_URL');
      final String LOCAL_URL = await platform.invokeMethod('GET_LOCAL_DEV_URL');

      setState(() {
        PROD_URL = PUBLIC_URL;
        DEV_URL = LOCAL_URL;
        tourApiKey = T_key1;
        kakaoMapKey = K_key2;
        tourApi_Encoding_key = T_key3;
      });
    } on PlatformException catch (e)
    {
      print("Failed to get API keys: '${e.message}'.");
    }
  }

  void setThemeMode(ThemeMode mode) => setState(() {
    _themeMode = mode;
    FlutterFlowTheme.saveThemeMode(mode);
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MBTITRAVEL',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}
