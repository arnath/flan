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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'subtitle': subtitle,
      'body': body,
    };
  }
}
