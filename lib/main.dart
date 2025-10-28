import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep Data Logger',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          labelStyle: TextStyle(fontSize: 18),
        ),
      ),
      home: const SleepDataInputScreen(),
    );
  }
}

class SleepDataInputScreen extends StatefulWidget {
  const SleepDataInputScreen({super.key});

  @override
  State<SleepDataInputScreen> createState() => _SleepDataInputScreenState();
}

class _SleepDataInputScreenState extends State<SleepDataInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _totalSleepTimeController = TextEditingController();
  final _sleepEfficiencyController = TextEditingController();
  final _heartRateController = TextEditingController();

  String? _selectedSleepStage;
  final List<String> _sleepStages = ['Awake', 'Light', 'Deep', 'REM'];

  @override
  void dispose() {
    _totalSleepTimeController.dispose();
    _sleepEfficiencyController.dispose();
    _heartRateController.dispose();
    super.dispose();
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'totalSleepTime': _totalSleepTimeController.text,
        'sleepStage': _selectedSleepStage,
        'sleepEfficiency': _sleepEfficiencyController.text,
        'heartRate': _heartRateController.text,
      };

      // Print data to console
      print('Submitted Data: $data');

      // Show a confirmation dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Submission Successful'),
          content: Text('The following data has been submitted:\n\n'
              'Total Sleep Time: ${data['totalSleepTime']}\n'
              'Sleep Stage: ${data['sleepStage']}\n'
              'Sleep Efficiency: ${data['sleepEfficiency']}%\n'
              'Heart Rate: ${data['heartRate']} bpm'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Clear the form
                _formKey.currentState!.reset();
                _totalSleepTimeController.clear();
                _sleepEfficiencyController.clear();
                _heartRateController.clear();
                setState(() {
                  _selectedSleepStage = null;
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Sleep Data'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _totalSleepTimeController,
                  decoration: const InputDecoration(
                    labelText: '총 수면 시간 (Total Sleep Time)',
                    hintText: 'e.g., 8h 30m',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter total sleep time';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedSleepStage,
                  decoration: const InputDecoration(
                    labelText: '수면 단계 (Sleep Stage)',
                  ),
                  items: _sleepStages.map((String stage) {
                    return DropdownMenuItem<String>(
                      value: stage,
                      child: Text(stage),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedSleepStage = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a sleep stage';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _sleepEfficiencyController,
                  decoration: const InputDecoration(
                    labelText: '수면 효율 (Sleep Efficiency)',
                    suffixText: '%',
                    hintText: 'e.g., 95',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter sleep efficiency';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _heartRateController,
                  decoration: const InputDecoration(
                    labelText: '심박수 (Heart Rate)',
                    suffixText: 'bpm',
                    hintText: 'e.g., 60',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter heart rate';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Submit Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}