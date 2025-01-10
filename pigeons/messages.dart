import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/messages.g.dart',
  swiftOut: 'darwin/flan_darwin/Sources/flan_darwin/messages.g.swift',
))
enum NotificationAuthorizationOptions {
  badge,
  sound,
  alert,
  carPlay,
  criticalAlert,
  providesAppNotificationSettings,
  provisional,
}

class NotificationContent {
  NotificationContent({
    required this.title,
    this.subtitle,
    this.body,
  });

  final String title;
  final String? subtitle;
  final String? body;
}

@HostApi()
abstract class FlanApi {
  /// Retrieves the current notification settings as a map of key-value pairs.
  @async
  Map<String, dynamic> getNotificationSettingsAsync();

  /// Requests notification authorization from the user with specified options.
  ///
  /// [options] specifies the types of notifications the application wants to send.
  /// Each option is an instance of [NotificationAuthorizationOptions]. Options must
  /// not be specified more than once.
  @async
  void requestAuthorizationAsync(
    List<NotificationAuthorizationOptions> options,
  );

  /// Schedules a notification to be delivered at a specified [target] time.
  ///
  /// [id] is a unique identifier for the notification.
  /// [targetTimestamp] specifies the delivery time for the notification as an ISO8601 date string.
  /// [content] contains the details of the notification, such as title and body.
  /// [repeats] indicates whether the notification should repeat. Defaults to `false`.
  @async
  void scheduleNotificationAsync(
    String id,
    String targetTimestamp,
    NotificationContent content, {
    bool repeats = false,
  });

  /// Cancels notifications with the specified [ids].
  ///
  /// [ids] is a list containing the unique identifiers of the notifications
  /// to be canceled.
  @async
  void cancelNotificationsAsync(List<String> ids);

  /// Retrieves a list of all scheduled notifications.
  ///
  /// Returns a list of maps, where each map represents the details of a
  /// scheduled notification.
  @async
  List<Map<String, dynamic>> getScheduledNotificationsAsync();
}
