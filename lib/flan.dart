import 'package:flan/models/notification_content.dart';
import 'package:flan/models/notification_schedule.dart';

abstract interface class Flan {
  Future<bool> scheduleNotificationAsync(
    String id,
    NotificationContent content,
    NotificationSchedule schedule,
  );
}
