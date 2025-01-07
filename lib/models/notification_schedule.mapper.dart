// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'notification_schedule.dart';

class NotificationScheduleMapper extends ClassMapperBase<NotificationSchedule> {
  NotificationScheduleMapper._();

  static NotificationScheduleMapper? _instance;
  static NotificationScheduleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotificationScheduleMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'NotificationSchedule';

  static bool _$repeats(NotificationSchedule v) => v.repeats;
  static const Field<NotificationSchedule, bool> _f$repeats =
      Field('repeats', _$repeats, opt: true, def: false);
  static int? _$year(NotificationSchedule v) => v.year;
  static const Field<NotificationSchedule, int> _f$year =
      Field('year', _$year, opt: true);
  static int? _$month(NotificationSchedule v) => v.month;
  static const Field<NotificationSchedule, int> _f$month =
      Field('month', _$month, opt: true);
  static int? _$day(NotificationSchedule v) => v.day;
  static const Field<NotificationSchedule, int> _f$day =
      Field('day', _$day, opt: true);
  static int? _$hour(NotificationSchedule v) => v.hour;
  static const Field<NotificationSchedule, int> _f$hour =
      Field('hour', _$hour, opt: true);
  static int? _$minute(NotificationSchedule v) => v.minute;
  static const Field<NotificationSchedule, int> _f$minute =
      Field('minute', _$minute, opt: true);
  static int? _$second(NotificationSchedule v) => v.second;
  static const Field<NotificationSchedule, int> _f$second =
      Field('second', _$second, opt: true);
  static int? _$weekOfMonth(NotificationSchedule v) => v.weekOfMonth;
  static const Field<NotificationSchedule, int> _f$weekOfMonth =
      Field('weekOfMonth', _$weekOfMonth, opt: true);
  static int? _$weekOfYear(NotificationSchedule v) => v.weekOfYear;
  static const Field<NotificationSchedule, int> _f$weekOfYear =
      Field('weekOfYear', _$weekOfYear, opt: true);
  static int? _$weekday(NotificationSchedule v) => v.weekday;
  static const Field<NotificationSchedule, int> _f$weekday =
      Field('weekday', _$weekday, opt: true);

  @override
  final MappableFields<NotificationSchedule> fields = const {
    #repeats: _f$repeats,
    #year: _f$year,
    #month: _f$month,
    #day: _f$day,
    #hour: _f$hour,
    #minute: _f$minute,
    #second: _f$second,
    #weekOfMonth: _f$weekOfMonth,
    #weekOfYear: _f$weekOfYear,
    #weekday: _f$weekday,
  };

  static NotificationSchedule _instantiate(DecodingData data) {
    return NotificationSchedule(
        repeats: data.dec(_f$repeats),
        year: data.dec(_f$year),
        month: data.dec(_f$month),
        day: data.dec(_f$day),
        hour: data.dec(_f$hour),
        minute: data.dec(_f$minute),
        second: data.dec(_f$second),
        weekOfMonth: data.dec(_f$weekOfMonth),
        weekOfYear: data.dec(_f$weekOfYear),
        weekday: data.dec(_f$weekday));
  }

  @override
  final Function instantiate = _instantiate;

  static NotificationSchedule fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NotificationSchedule>(map);
  }

  static NotificationSchedule fromJson(String json) {
    return ensureInitialized().decodeJson<NotificationSchedule>(json);
  }
}

mixin NotificationScheduleMappable {
  String toJson() {
    return NotificationScheduleMapper.ensureInitialized()
        .encodeJson<NotificationSchedule>(this as NotificationSchedule);
  }

  Map<String, dynamic> toMap() {
    return NotificationScheduleMapper.ensureInitialized()
        .encodeMap<NotificationSchedule>(this as NotificationSchedule);
  }

  NotificationScheduleCopyWith<NotificationSchedule, NotificationSchedule,
          NotificationSchedule>
      get copyWith => _NotificationScheduleCopyWithImpl(
          this as NotificationSchedule, $identity, $identity);
  @override
  String toString() {
    return NotificationScheduleMapper.ensureInitialized()
        .stringifyValue(this as NotificationSchedule);
  }

  @override
  bool operator ==(Object other) {
    return NotificationScheduleMapper.ensureInitialized()
        .equalsValue(this as NotificationSchedule, other);
  }

  @override
  int get hashCode {
    return NotificationScheduleMapper.ensureInitialized()
        .hashValue(this as NotificationSchedule);
  }
}

extension NotificationScheduleValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NotificationSchedule, $Out> {
  NotificationScheduleCopyWith<$R, NotificationSchedule, $Out>
      get $asNotificationSchedule =>
          $base.as((v, t, t2) => _NotificationScheduleCopyWithImpl(v, t, t2));
}

abstract class NotificationScheduleCopyWith<
    $R,
    $In extends NotificationSchedule,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {bool? repeats,
      int? year,
      int? month,
      int? day,
      int? hour,
      int? minute,
      int? second,
      int? weekOfMonth,
      int? weekOfYear,
      int? weekday});
  NotificationScheduleCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _NotificationScheduleCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NotificationSchedule, $Out>
    implements NotificationScheduleCopyWith<$R, NotificationSchedule, $Out> {
  _NotificationScheduleCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NotificationSchedule> $mapper =
      NotificationScheduleMapper.ensureInitialized();
  @override
  $R call(
          {bool? repeats,
          Object? year = $none,
          Object? month = $none,
          Object? day = $none,
          Object? hour = $none,
          Object? minute = $none,
          Object? second = $none,
          Object? weekOfMonth = $none,
          Object? weekOfYear = $none,
          Object? weekday = $none}) =>
      $apply(FieldCopyWithData({
        if (repeats != null) #repeats: repeats,
        if (year != $none) #year: year,
        if (month != $none) #month: month,
        if (day != $none) #day: day,
        if (hour != $none) #hour: hour,
        if (minute != $none) #minute: minute,
        if (second != $none) #second: second,
        if (weekOfMonth != $none) #weekOfMonth: weekOfMonth,
        if (weekOfYear != $none) #weekOfYear: weekOfYear,
        if (weekday != $none) #weekday: weekday
      }));
  @override
  NotificationSchedule $make(CopyWithData data) => NotificationSchedule(
      repeats: data.get(#repeats, or: $value.repeats),
      year: data.get(#year, or: $value.year),
      month: data.get(#month, or: $value.month),
      day: data.get(#day, or: $value.day),
      hour: data.get(#hour, or: $value.hour),
      minute: data.get(#minute, or: $value.minute),
      second: data.get(#second, or: $value.second),
      weekOfMonth: data.get(#weekOfMonth, or: $value.weekOfMonth),
      weekOfYear: data.get(#weekOfYear, or: $value.weekOfYear),
      weekday: data.get(#weekday, or: $value.weekday));

  @override
  NotificationScheduleCopyWith<$R2, NotificationSchedule, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _NotificationScheduleCopyWithImpl($value, $cast, t);
}
