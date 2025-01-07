import 'package:flan/flan.dart';
import 'package:flan/models/notification_content.dart';
import 'package:flan/models/notification_schedule.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MethodChannelFlan extends PlatformInterface implements Flan {
  MethodChannelFlan({required super.token});

  @visibleForTesting
  final methodChannel = const MethodChannel('flan');

  @override
  Future<void> scheduleNotificationAsync(
    String id,
    NotificationContent content,
    NotificationSchedule schedule,
  ) async {
    await methodChannel.invokeMethod(
      'scheduleNotificationAsync',
      {
        'id': id,
        'content': content.toJson(),
        'schedule': schedule.toJson(),
      },
    );
  }

  @override
  Future<void> cancelNotificationAsync(String id) async {
    await methodChannel.invokeMethod(
      'cancelNotificationAsync',
      {'id': id},
    );
  }

  @override
  Future<List<String>> getScheduledNotificationsAsync() async {
    return await methodChannel.invokeMethod('getScheduledNotificationsAsync');
  }
}
