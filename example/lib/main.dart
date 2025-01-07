import 'package:flan/flan.dart';
import 'package:flan/flan_method_channel.dart';
import 'package:flan/models/notification_content.dart';
import 'package:flan/models/notification_schedule.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ksuid/ksuid.dart';

void main() {
  GetIt.instance.registerSingleton<Flan>(MethodChannelFlan(token: Object()));
  runApp(const FlanExampleApp());
}

class FlanExampleApp extends StatefulWidget {
  const FlanExampleApp({super.key});

  @override
  State<FlanExampleApp> createState() => _FlanExampleAppState();
}

class _FlanExampleAppState extends State<FlanExampleApp> {
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
          child: OutlinedButton(
            child: Text('Schedule notification in 10 seconds'),
            onPressed: () async {
              DateTime target = DateTime.now().add(Duration(seconds: 10));
              NotificationSchedule schedule = NotificationSchedule(
                year: target.year,
                month: target.month,
                day: target.day,
                hour: target.hour,
                minute: target.minute,
                second: target.second,
                repeats: false,
              );

              NotificationContent content = NotificationContent(
                title: 'Example notification from Flan',
                body: 'Hi from Flan!',
              );

              await GetIt.instance<Flan>().scheduleNotificationAsync(
                KSUID.generate().asString,
                content,
                schedule,
              );
            },
          ),
        ),
      ),
    );
  }
}
