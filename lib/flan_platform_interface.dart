import 'package:flan/flan.dart';
import 'package:flan/flan_method_channel.dart';
import 'package:flan/models/notification_content.dart';
import 'package:flan/models/notification_schedule.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FlanPlatform extends PlatformInterface implements Flan {
  FlanPlatform() : super(token: _token);

  static final FlanPlatform instance = MethodChannelFlan();
  static final Object _token = Object();

  @override
  Future<bool> scheduleNotificationAsync(
    String id,
    NotificationContent content,
    NotificationSchedule schedule,
  );
}
