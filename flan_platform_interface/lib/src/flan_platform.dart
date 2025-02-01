import 'dart:async';

import 'package:flan_platform_interface/src/flan_api.dart';
import 'package:flan_platform_interface/src/flan_method_channel_platform.dart';
import 'package:flan_platform_interface/src/notification_authorization_options.dart';
import 'package:flan_platform_interface/src/notification_content.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of flan must implement.
///
/// Platform implementations should extend this class rather than implement it as `flan`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [FlanPlatform] methods.
abstract class FlanPlatform extends PlatformInterface implements FlanApi {
  /// Constructs a UrlLauncherPlatform.
  FlanPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlanPlatform _instance = FlanMethodChannelPlatform();

  /// The default instance of [FlanPlatform] to use.
  ///
  /// Defaults to [FlanMethodChannelPlatform].
  static FlanPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [FlanPlatform] when they register themselves.
  static set instance(FlanPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  @override
  Future<Map<String, dynamic>> getNotificationSettingsAsync() =>
      throw UnimplementedError(
        'getNotificationSettingsAsync() has not been implemented.',
      );

  @override
  Future<bool> requestAuthorizationAsync(
    List<NotificationAuthorizationOptions> options,
  ) =>
      throw UnimplementedError(
        'requestAuthorizationAsync() has not been implemented.',
      );

  @override
  Future<void> scheduleNotificationAsync(
    String id,
    DateTime target,
    NotificationContent content, {
    bool repeats = false,
  }) =>
      throw UnimplementedError(
        'scheduleNotificationAsync() has not been implemented.',
      );

  @override
  Future<void> cancelNotificationsAsync(Iterable<String> ids) =>
      throw UnimplementedError(
        'cancelNotificationsAsync() has not been implemented.',
      );

  @override
  Future<List<Map<String, dynamic>>> getScheduledNotificationsAsync() =>
      throw UnimplementedError(
        'getScheduledNotificationsAsync() has not been implemented.',
      );
}
