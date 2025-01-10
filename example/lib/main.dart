import 'package:flan/flan.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ksuid/ksuid.dart';

void main() {
  GetIt.instance.registerSingleton<FlanPlatformApi>(FlanPlatformApi());
  runApp(const FlanExampleApp());
}

class FlanExampleApp extends StatefulWidget {
  const FlanExampleApp({super.key});

  @override
  State<FlanExampleApp> createState() => _FlanExampleAppState();
}

class _FlanExampleAppState extends State<FlanExampleApp> {
  static final FlanPlatformApi _flan = GetIt.instance<FlanPlatformApi>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            spacing: 8,
            children: [
              OutlinedButton(
                child: Text('Request notification authorization'),
                onPressed: () async {
                  await _flan.requestAuthorizationAsync(
                    [
                      NotificationAuthorizationOptions.alert,
                    ],
                  );
                },
              ),
              OutlinedButton(
                child: Text('Schedule notification in 10 seconds'),
                onPressed: () async {
                  DateTime target = DateTime.now().add(Duration(seconds: 10));
                  NotificationContent content = NotificationContent(
                    title: 'Example notification from Flan',
                    body: 'Hi from Flan!',
                  );

                  await _flan.scheduleNotificationAsync(
                    KSUID.generate().asString,
                    target,
                    content,
                    repeats: false,
                  );
                },
              ),
              OutlinedButton(
                  child: Text('Get notification settings'),
                  onPressed: () async {
                    print(await _flan.getNotificationSettingsAsync());
                  })
            ],
          ),
        ),
      ),
    );
  }
}
