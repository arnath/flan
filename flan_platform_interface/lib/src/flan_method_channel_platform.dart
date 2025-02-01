import 'package:flan_platform_interface/src/flan_platform.dart';
import 'package:flan_platform_interface/src/notification_authorization_options.dart';
import 'package:flan_platform_interface/src/notification_content.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FlanMethodChannelPlatform extends FlanPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel(
    'dev.vijayp.flan',
    JSONMethodCodec(),
  );

  @override
  Future<Map<String, dynamic>> getNotificationSettingsAsync() async {
    var result = await methodChannel.invokeMethod(
      'getNotificationSettingsAsync',
    );

    return result!;
  }

  @override
  Future<bool> requestAuthorizationAsync(
    List<NotificationAuthorizationOptions> options,
  ) async {
    var result = await methodChannel.invokeMethod(
      'requestAuthorizationAsync',
      {'options': options.map((e) => e.name).toList()},
    );

    return result!;
  }

  @override
  Future<void> scheduleNotificationAsync(
    String id,
    DateTime target,
    NotificationContent content, {
    bool repeats = false,
    bool timeSensitive = false,
  }) async {
    await methodChannel.invokeMethod(
      'scheduleNotificationAsync',
      {
        'id': id,
        'content': content.toMap(),
        'targetEpochSeconds': target.millisecondsSinceEpoch / 1000,
        'repeats': repeats,
        'timeSensitive': timeSensitive,
      },
    );
  }

  @override
  Future<void> cancelNotificationsAsync(Iterable<String> ids) async {
    await methodChannel.invokeMethod(
      'cancelNotificationsAsync',
      {'ids': ids.toList()},
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getScheduledNotificationsAsync() async {
    var result = await methodChannel.invokeMethod(
      'getScheduledNotificationsAsync',
    );

    return result!;
  }
}
