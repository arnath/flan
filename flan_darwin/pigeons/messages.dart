import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/messages.g.dart',
  swiftOut: 'darwin/flan_darwin/Sources/flan_darwin/messages.g.swift',
))

/// The purpose of this Pigeon-defined API is basically to ensure type safety
/// of the primitive types when going between Dart and Swift and to provide
/// a slightly cleaner interface. As such, the API uses primitive types in
/// places of some real Dart types.
@HostApi()
abstract class FlanDarwinApi {
  @async
  Map<String, String> getNotificationSettingsAsync();

  @async
  void requestAuthorizationAsync(
    List<String> options,
  );

  @async
  void scheduleNotificationAsync(
    String id,
    String targetTimestamp,
    Map<String, Object?> content,
    bool repeats,
  );

  void cancelNotifications(List<String> ids);

  @async
  List<Map<String, Object?>> getScheduledNotificationsAsync();
}
