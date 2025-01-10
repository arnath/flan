// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flan_platform_interface/flan_platform_interface.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;

import 'src/messages.g.dart';

/// An implementation of [FlanPlatform] for iOS.
class FlanDarwin extends FlanPlatform {
  /// Creates a new plugin implementation instance.
  FlanDarwin({
    @visibleForTesting FlanDarwinApi? api,
  }) : _hostApi = api ?? FlanDarwinApi();

  final FlanDarwinApi _hostApi;

  /// Registers this class as the default instance of [FlanPlatform].
  static void registerWith() {
    FlanPlatform.instance = FlanDarwin();
  }

  @override
  Future<Map<String, String>> getNotificationSettingsAsync() {
    return _hostApi.getNotificationSettings();
  }

  @override
  Future<void> requestAuthorizationAsync(
    List<NotificationAuthorizationOptions> options,
  ) {
    return _hostApi.requestAuthorization(
      options.map((e) => e.name).toList(),
    );
  }

  @override
  Future<void> scheduleNotificationAsync(
    String id,
    DateTime target,
    NotificationContent content, {
    bool repeats = false,
  }) {
    return _hostApi.scheduleNotification(
      id,
      target.toIso8601String(),
      content.toMap(),
      repeats,
    );
  }

  @override
  Future<void> cancelNotificationsAsync(Iterable<String> ids) {
    return _hostApi.cancelNotifications(ids.toList());
  }

  @override
  Future<List<Map<String, dynamic>>> getScheduledNotificationsAsync() {
    return _hostApi.getScheduledNotifications();
  }
}
