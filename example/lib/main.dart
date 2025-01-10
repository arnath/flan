import 'package:flan/flan.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static final FlanPlatformApi _flan = FlanPlatformApi();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Row(
            spacing: 8,
            children: [
              TextButton(
                  child: Text('Print notification settings'),
                  onPressed: () async =>
                      _flan.getNotificationSettingsAsync().then(print)),
            ],
          ),
        ),
      ),
    );
  }
}
