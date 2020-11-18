import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paytmkaro/paytmkaro.dart';

void main() {
  const MethodChannel channel = MethodChannel('paytmkaro');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Paytmkaro.platformVersion, '42');
  });
}
