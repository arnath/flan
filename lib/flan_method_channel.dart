import 'package:flan/flan.dart';
import 'package:flan/flan_method_codec.dart';
import 'package:flan/models/notification_authorization_options.dart';
import 'package:flan/models/notification_content.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MethodChannelFlan extends PlatformInterface implements Flan {
  MethodChannelFlan({required super.token});

  @visibleForTesting
  final methodChannel = const MethodChannel('flan', FlanMethodCodec());

  @override
  Future<Map<String, dynamic>> getNotificationSettingsAsync() async {
    var result = await methodChannel
        .invokeMethod<dynamic>('getNotificationSettingsAsync');
    return result!;
  }

  @override
  Future<void> requestAuthorizationAsync(
    List<NotificationAuthorizationOptions> options,
  ) async {
    await methodChannel.invokeMethod(
      'requestAuthorizationAsync',
      {'options': options.map((e) => e.name).toList()},
    );
  }

  @override
  Future<void> scheduleNotificationAsync(
    String id,
    DateTime target,
    NotificationContent content, {
    bool repeats = false,
  }) async {
    await methodChannel.invokeMethod(
      'scheduleNotificationAsync',
      {
        'id': id,
        'content': content.toMap(),
        'targetEpochSeconds': target.millisecondsSinceEpoch / 1000,
        'repeats': repeats,
      },
    );
  }

  @override
  Future<void> cancelNotificationAsync(String id) async {
    await methodChannel.invokeMethod(
      'cancelNotificationAsync',
      {'id': id},
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getScheduledNotificationsAsync() async {
    List<Object?>? result = await methodChannel.invokeMethod<List<Object?>>(
      'getScheduledNotificationsAsync',
    );

    return result!.map((e) => e as Map<String, dynamic>).toList();
  }
}
