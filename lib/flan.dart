import 'package:flan/models/notification_content.dart';
import 'package:flan/models/notification_schedule.dart';

abstract interface class Flan {
  Future<void> scheduleNotificationAsync(
    String id,
    NotificationContent content,
    NotificationSchedule schedule,
  );

  Future<void> cancelNotificationAsync(String id);

  Future<List<String>> getScheduledNotificationsAsync();
}
