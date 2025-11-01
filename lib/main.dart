
import 'package:flutter/material.dart';

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
        fontFamily: 'Pretendard', // A modern and clean font
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

  @override
  void dispose() {
    _heartRateController.dispose();
    _respiratoryRateController.dispose();
    _bodyTempController.dispose();
    super.dispose();
  }

  void _saveData() {
    // In a real app, you would save the data here.
    // For this example, we'll just show a confirmation message.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('정보가 성공적으로 저장되었습니다.'),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Clear the fields after saving
    _heartRateController.clear();
    _respiratoryRateController.clear();
    _bodyTempController.clear();
    // Unfocus to hide the keyboard
    FocusScope.of(context).unfocus();
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
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _saveData,
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
          child: const Text('저장하기'),
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
              keyboardType: TextInputType.number,
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
