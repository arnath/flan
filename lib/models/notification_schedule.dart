import 'package:dart_mappable/dart_mappable.dart';

part 'notification_schedule.mapper.dart';

@MappableClass()
class NotificationSchedule with NotificationScheduleMappable {
  NotificationSchedule({
    this.repeats = false,
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
    this.weekOfMonth,
    this.weekOfYear,
    this.weekday,
  });

  final int? year;
  final int? month;
  final int? day;

  final int? hour;
  final int? minute;
  final int? second;

  final int? weekOfMonth;
  final int? weekOfYear;
  final int? weekday;

  final bool repeats;
}
