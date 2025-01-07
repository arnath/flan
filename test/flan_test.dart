import 'package:flutter_test/flutter_test.dart';
import 'package:flan/flan.dart';
import 'package:flan/flan_platform_interface.dart';
import 'package:flan/flan_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlanPlatform
    with MockPlatformInterfaceMixin
    implements FlanPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlanPlatform initialPlatform = FlanPlatform.instance;

  test('$MethodChannelFlan is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlan>());
  });

  test('getPlatformVersion', () async {
    Flan flanPlugin = Flan();
    MockFlanPlatform fakePlatform = MockFlanPlatform();
    FlanPlatform.instance = fakePlatform;

    expect(await flanPlugin.getPlatformVersion(), '42');
  });
}
