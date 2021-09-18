import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lebo/lebo.dart';

void main() {
  const MethodChannel channel = MethodChannel('lebo');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('enableLog', () async {
    // Lebo.enableLog(
    //   enable: true,
    // );
  });

  test('getPlatformVersion', () async {});
}
