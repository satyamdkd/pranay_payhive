import 'package:flutter/services.dart';

class PhoneNumberPicker {
  static const MethodChannel _channel = MethodChannel('phone_number_picker');

  static Future getPhoneNumber() async {
    final String? result = await _channel.invokeMethod('getPhoneNumber');
    return result;
  }
}
