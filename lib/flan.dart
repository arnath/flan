import 'package:flan/models/notification_authorization_options.dart';
import 'package:flan/models/notification_content.dart';

abstract interface class Flan {
  Future<void> requestAuthorizationAsync(
      List<NotificationAuthorizationOptions> options);

  Future<void> scheduleNotificationAsync(
    String id,
    DateTime target,
    NotificationContent content, {
    bool repeats = false,
  });

  Future<void> cancelNotificationAsync(String id);

  Future<List<Map<String, dynamic>>> getScheduledNotificationsAsync();
}
