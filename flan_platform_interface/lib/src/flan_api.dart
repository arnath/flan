import 'package:flan_platform_interface/src/notification_authorization_options.dart';
import 'package:flan_platform_interface/src/notification_content.dart';

abstract interface class FlanApi {
  /// Retrieves the current notification settings as a map of key-value pairs.
  Future<Map<String, dynamic>> getNotificationSettingsAsync();

  /// Requests notification authorization from the user with specified options.
  ///
  /// [options] specifies the types of notifications the application wants to send.
  /// Each option is an instance of [NotificationAuthorizationOptions]. Options must
  /// not be specified more than once.
  Future<void> requestAuthorizationAsync(
    List<NotificationAuthorizationOptions> options,
  );

  /// Schedules a notification to be delivered at a specified [target] time.
  ///
  /// [id] is a unique identifier for the notification.
  /// [target] specifies the delivery time for the notification.
  /// [content] contains the details of the notification, such as title and body.
  /// [repeats] indicates whether the notification should repeat. Defaults to `false`.
  Future<void> scheduleNotificationAsync(
    String id,
    DateTime target,
    NotificationContent content, {
    bool repeats = false,
  });

  /// Cancels notifications with the specified [ids].
  ///
  /// [ids] is an iterable containing the unique identifiers of the notifications
  /// to be canceled.
  Future<void> cancelNotificationsAsync(Iterable<String> ids);

  /// Retrieves a list of all scheduled notifications.
  ///
  /// Returns a a list of maps, where each map represents the details of a
  /// scheduled notification.
  Future<List<Map<String, dynamic>>> getScheduledNotificationsAsync();
}
