// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'notification_content.dart';

class NotificationContentMapper extends ClassMapperBase<NotificationContent> {
  NotificationContentMapper._();

  static NotificationContentMapper? _instance;
  static NotificationContentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotificationContentMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'NotificationContent';

  static String _$title(NotificationContent v) => v.title;
  static const Field<NotificationContent, String> _f$title =
      Field('title', _$title);
  static String? _$subtitle(NotificationContent v) => v.subtitle;
  static const Field<NotificationContent, String> _f$subtitle =
      Field('subtitle', _$subtitle, opt: true);
  static String? _$body(NotificationContent v) => v.body;
  static const Field<NotificationContent, String> _f$body =
      Field('body', _$body, opt: true);

  @override
  final MappableFields<NotificationContent> fields = const {
    #title: _f$title,
    #subtitle: _f$subtitle,
    #body: _f$body,
  };

  static NotificationContent _instantiate(DecodingData data) {
    return NotificationContent(
        title: data.dec(_f$title),
        subtitle: data.dec(_f$subtitle),
        body: data.dec(_f$body));
  }

  @override
  final Function instantiate = _instantiate;

  static NotificationContent fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NotificationContent>(map);
  }

  static NotificationContent fromJson(String json) {
    return ensureInitialized().decodeJson<NotificationContent>(json);
  }
}

mixin NotificationContentMappable {
  String toJson() {
    return NotificationContentMapper.ensureInitialized()
        .encodeJson<NotificationContent>(this as NotificationContent);
  }

  Map<String, dynamic> toMap() {
    return NotificationContentMapper.ensureInitialized()
        .encodeMap<NotificationContent>(this as NotificationContent);
  }

  NotificationContentCopyWith<NotificationContent, NotificationContent,
          NotificationContent>
      get copyWith => _NotificationContentCopyWithImpl(
          this as NotificationContent, $identity, $identity);
  @override
  String toString() {
    return NotificationContentMapper.ensureInitialized()
        .stringifyValue(this as NotificationContent);
  }

  @override
  bool operator ==(Object other) {
    return NotificationContentMapper.ensureInitialized()
        .equalsValue(this as NotificationContent, other);
  }

  @override
  int get hashCode {
    return NotificationContentMapper.ensureInitialized()
        .hashValue(this as NotificationContent);
  }
}

extension NotificationContentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NotificationContent, $Out> {
  NotificationContentCopyWith<$R, NotificationContent, $Out>
      get $asNotificationContent =>
          $base.as((v, t, t2) => _NotificationContentCopyWithImpl(v, t, t2));
}

abstract class NotificationContentCopyWith<$R, $In extends NotificationContent,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? title, String? subtitle, String? body});
  NotificationContentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _NotificationContentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NotificationContent, $Out>
    implements NotificationContentCopyWith<$R, NotificationContent, $Out> {
  _NotificationContentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NotificationContent> $mapper =
      NotificationContentMapper.ensureInitialized();
  @override
  $R call({String? title, Object? subtitle = $none, Object? body = $none}) =>
      $apply(FieldCopyWithData({
        if (title != null) #title: title,
        if (subtitle != $none) #subtitle: subtitle,
        if (body != $none) #body: body
      }));
  @override
  NotificationContent $make(CopyWithData data) => NotificationContent(
      title: data.get(#title, or: $value.title),
      subtitle: data.get(#subtitle, or: $value.subtitle),
      body: data.get(#body, or: $value.body));

  @override
  NotificationContentCopyWith<$R2, NotificationContent, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _NotificationContentCopyWithImpl($value, $cast, t);
}
