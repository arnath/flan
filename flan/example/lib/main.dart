import 'package:flan/flan.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ksuid/ksuid.dart';

void main() {
  GetIt.instance.registerSingleton<FlanApi>(FlanPlatformApi());
  runApp(const FlanExampleApp());
}

class FlanExampleApp extends StatefulWidget {
  const FlanExampleApp({super.key});

  @override
  State<FlanExampleApp> createState() => _FlanExampleAppState();
}

class _FlanExampleAppState extends State<FlanExampleApp> {
  static final FlanApi _flan = GetIt.instance<FlanApi>();

  bool? authorized;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flan example app'),
        ),
        body: Center(
          child: Column(
            spacing: 8,
            children: [
              Text('Authorization status: ${authorized ?? 'Unknown'}'),
              OutlinedButton(
                child: Text('Request notification authorization'),
                onPressed: () async {
                  var result = await _flan.requestAuthorizationAsync(
                    [
                      NotificationAuthorizationOptions.alert,
                    ],
                  );
                  setState(() => authorized = result);
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
                child: Text('Print notification settings'),
                onPressed: () async =>
                    _flan.getNotificationSettingsAsync().then(print),
              )
            ],
          ),
        ),
      ),
    );
  }
}
