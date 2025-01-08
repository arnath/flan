import 'package:flan/models/notification_authorization_options.dart';
import 'package:flan/models/notification_content.dart';

abstract interface class Flan {
  Future getNotificationSettingsAsync();

  Future<void> requestAuthorizationAsync(
    List<NotificationAuthorizationOptions> options,
  );

  Future<void> scheduleNotificationAsync(
    String id,
    DateTime target,
    NotificationContent content, {
    bool repeats = false,
  });

  Future<void> cancelNotificationsAsync(Iterable<String> ids);

  Future<List<Map<String, dynamic>>> getScheduledNotificationsAsync();
}
