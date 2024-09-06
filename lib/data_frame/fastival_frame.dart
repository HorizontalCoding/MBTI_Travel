import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

late final List<Map<String, dynamic>> g_markerPositions = [];

Future<void> loadCSV() async {
  // CSV 파일 읽기
  final csvData = await rootBundle.loadString('assets/csv/festival_info.csv');

  // CSV 파싱
  List<List<dynamic>> rows = const CsvToListConverter().convert(csvData);

  // CSV 데이터 첫 번째 행은 헤더이므로 제외
  for (int i = 1; i < rows.length; i++) {
    g_markerPositions.add({
      'id': rows[i][0],               // unique_id
      'region': rows[i][1],           // region
      'city_name': rows[i][2],        // city_name
      'festival_name': rows[i][3],    // festival_name
      'festival_month': rows[i][4],   // festival_month
      'intro': rows[i][5],            // intro
      'website_url': rows[i][6],      // website_url
    });
  }
}
