import 'package:flutter/foundation.dart';

@immutable
class NotificationContent {
  const NotificationContent({
    required this.title,
    this.subtitle,
    this.body,
  });

  final String title;
  final String? subtitle;
  final String? body;

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'title': title,
      'subtitle': subtitle,
      'body': body,
    };
  }
}
