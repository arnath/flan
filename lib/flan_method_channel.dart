import 'package:flan/flan_platform_interface.dart';
import 'package:flan/models/notification_content.dart';
import 'package:flan/models/notification_schedule.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MethodChannelFlan extends FlanPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('flan');

  @override
  Future<bool> scheduleNotificationAsync(
    String id,
    NotificationContent content,
    NotificationSchedule schedule,
  ) async {
    bool? success = await methodChannel.invokeMethod<bool>(
      'scheduleNotificationAsync',
      {
        'id': id,
        'content': content.toJson(),
        'schedule': schedule.toJson(),
      },
    );

    return success ?? false;
  }
}
