import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ❗️서버의 IP 주소를 입력하세요.
  static const String _baseUrl = "http://13.237.113.165:8080"; 

  // 수면 데이터 기록 및 분석 API 호출 함수
  static Future<Map<String, dynamic>> recordAndAnalyzeSleep({
    required DateTime sleepStartTime,
    required DateTime sleepEndTime,
    required int heartRate,
    required int respiratoryRate,
    required double bodyTemperature,
  }) async {
    final url = Uri.parse('$_baseUrl/api/sleep/record-and-analyze');

    final body = jsonEncode({
      'sleepStartTime': sleepStartTime.toUtc().toIso8601String(),
      'sleepEndTime': sleepEndTime.toUtc().toIso8601String(),
      'heartRate': heartRate,
      'respiratoryRate': respiratoryRate,
      'bodyTemperature': bodyTemperature,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 201) {
        // UTF-8로 디코딩하여 한글 깨짐   
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        // 서버에서 보낸 에러 메시지가 있다면 함께 표시
        final errorBody = jsonDecode(utf8.decode(response.bodyBytes));
        throw Exception('서버 응답 실패: ${response.statusCode}, 메시지: ${errorBody['message']}');
      }
    } catch (e) {
      throw Exception('API 요청 중 오류 발생: $e');
    }
  }
}