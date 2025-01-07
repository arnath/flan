import 'package:dart_mappable/dart_mappable.dart';

part 'notification_content.mapper.dart';

@MappableClass()
class NotificationContent with NotificationContentMappable {
  NotificationContent({
    required this.title,
    this.subtitle,
    this.body,
  });

  final String title;
  final String? subtitle;
  final String? body;
}
