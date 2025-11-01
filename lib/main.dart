import 'package:flutter/material.dart';
import 'api_service.dart'; // ApiService 파일을 임포트합니다.

void main() {
  runApp(const HealthApp());
}

class HealthApp extends StatelessWidget {
  const HealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '건강 정보 기록',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        fontFamily: 'Pretendard',
      ),
      home: const HealthInputScreen(),
    );
  }
}

class HealthInputScreen extends StatefulWidget {
  const HealthInputScreen({super.key});

  @override
  State<HealthInputScreen> createState() => _HealthInputScreenState();
}

class _HealthInputScreenState extends State<HealthInputScreen> {
  final _heartRateController = TextEditingController();
  final _respiratoryRateController = TextEditingController();
  final _bodyTempController = TextEditingController();

  // API 호출 상태 및 결과 관리를 위한 변수 추가
  String _analysisResult = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _heartRateController.dispose();
    _respiratoryRateController.dispose();
    _bodyTempController.dispose();
    super.dispose();
  }

  // ✅ _saveData 함수를 서버 통신 로직으로 수정
  void _analyzeData() async {
    // 입력값 유효성 검사
    if (_heartRateController.text.isEmpty ||
        _respiratoryRateController.text.isEmpty ||
        _bodyTempController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 값을 입력해주세요.')),
      );
      return;
    }

    // 키보드 숨기기
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _analysisResult = '서버에서 수면 상태를 분석 중입니다...';
    });

    try {
      // 1. 입력된 텍스트를 숫자로 변환
      final int heartRate = int.parse(_heartRateController.text);
      final int respiratoryRate = int.parse(_respiratoryRateController.text);
      final double bodyTemperature = double.parse(_bodyTempController.text);

      // 2. ApiService 호출 (수면 시간은 예시로 현재 시간 기준 8시간 전으로 설정)
      final response = await ApiService.recordAndAnalyzeSleep(
        sleepStartTime: DateTime.now().subtract(const Duration(hours: 8)),
        sleepEndTime: DateTime.now(),
        heartRate: heartRate,
        respiratoryRate: respiratoryRate,
        bodyTemperature: bodyTemperature,
      );

      // 3. 성공 시, 서버로부터 받은 결과 메시지를 화면에 표시
      setState(() {
        _analysisResult = response['summaryMessage'] ?? '분석 결과를 받지 못했습니다.';
      });
    } catch (e) {
      // 4. 실패 시, 에러 메시지를 화면에 표시
      setState(() {
        _analysisResult = '오류 발생: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false; // 로딩 종료
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('건강 정보 기록', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildInfoCard(
              controller: _heartRateController,
              icon: Icons.favorite,
              iconColor: Colors.red,
              label: '심박수',
              hint: '분당 심박수',
              suffix: 'BPM',
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              controller: _respiratoryRateController,
              icon: Icons.air,
              iconColor: Colors.blue,
              label: '호흡수',
              hint: '분당 호흡수',
              suffix: '회/분',
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              controller: _bodyTempController,
              icon: Icons.thermostat,
              iconColor: Colors.orange,
              label: '체온',
              hint: '섭씨 온도',
              suffix: '°C',
            ),
            const SizedBox(height: 24),
            // ✅ 결과 표시 영역 추가
            if (_analysisResult.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _analysisResult,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        // ✅ 로딩 상태에 따라 버튼 비활성화
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                onPressed: _analyzeData, // ✅ 호출할 함수 변경
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('분석하기'), // ✅ 버튼 텍스트 변경
              ),
      ),
    );
  }

  Widget _buildInfoCard({
    required TextEditingController controller,
    required IconData icon,
    required Color iconColor,
    required String label,
    required String hint,
    required String suffix,
  }) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 28),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: hint,
                suffixText: suffix,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}