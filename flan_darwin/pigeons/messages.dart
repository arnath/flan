import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/messages.g.dart',
  swiftOut: 'darwin/flan_darwin/Sources/flan_darwin/messages.g.swift',
))

/// The purpose of this Pigeon-defined API is basically to ensure type safety
/// of the primitive types when going between Dart and Swift and to provide
/// a slightly cleaner interface. As such, this is similar to but not the same
/// as the FlanApi. It replaces a lot of types with primitives supported by the
/// standard method codec.
@HostApi()
abstract class FlanDarwinApi {
  @async
  Map<String, String> getNotificationSettings();

  @async
  void requestAuthorization(
    List<String> options,
  );

  @async
  void scheduleNotification(
    String id,
    int targetEpochSeconds,
    Map<String, Object?> content,
    bool repeats,
  );

  void cancelNotifications(List<String> ids);

  @async
  List<Map<String, Object?>> getScheduledNotifications();
}
