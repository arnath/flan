import 'package:flan_platform_interface/flan_platform_interface.dart';

class FlanPlatformApi implements FlanApi {
  @override
  Future<void> cancelNotificationsAsync(Iterable<String> ids) {
    return FlanPlatform.instance.cancelNotificationsAsync(ids);
  }

  @override
  Future<Map<String, dynamic>> getNotificationSettingsAsync() {
    return FlanPlatform.instance.getNotificationSettingsAsync();
  }

  @override
  Future<List<Map<String, dynamic>>> getScheduledNotificationsAsync() {
    return FlanPlatform.instance.getScheduledNotificationsAsync();
  }

  @override
  Future<bool> requestAuthorizationAsync(
    List<NotificationAuthorizationOptions> options,
  ) {
    return FlanPlatform.instance.requestAuthorizationAsync(options);
  }

  @override
  Future<void> scheduleNotificationAsync(
    String id,
    DateTime target,
    NotificationContent content, {
    bool repeats = false,
    bool timeSensitive = false,
  }) {
    return FlanPlatform.instance.scheduleNotificationAsync(
      id,
      target,
      content,
      repeats: repeats,
      timeSensitive: timeSensitive,
    );
  }
}
