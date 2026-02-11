import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeBiometricAuthService {
  static const MethodChannel _channel = MethodChannel('native_biometric_auth');

  static Future<AuthResult> authenticate() async {
    try {
      final result = await _channel.invokeMethod('authenticateWithBiometrics');
      return AuthResult(isAuthenticated: result == true);
    } on PlatformException catch (e) {
      debugPrint('Authentication errorrr: ${e.code} - ${e.message}');
      return AuthResult(
        isAuthenticated: false,
        encounteredError: true,
        errorCode: e.code,
        errorMessage: e.message ?? 'Unknown error',
      );
    }
  }

  static Future<bool> canCheckBiometrics() async {
    try {
      final result = await _channel.invokeMethod('canCheckBiometrics');
      return result == true;
    } catch (e) {
      return false;
    }
  }

  static Future<List<String>> getAvailableBiometrics() async {
    try {
      final result = await _channel.invokeMethod('getAvailableBiometrics');
      return List<String>.from(result ?? []);
    } catch (e) {
      return [];
    }
  }

  static Future<bool> isDeviceSupported() async {
    try {
      final result = await _channel.invokeMethod('isDeviceSupported');
      return result == true;
    } catch (e) {
      return false;
    }
  }
}

class AuthResult {
  final bool isAuthenticated;
  final bool? encounteredError;
  final String? errorCode;
  final String? errorMessage;

  AuthResult({
    required this.isAuthenticated,
    this.errorCode,
    this.encounteredError,
    this.errorMessage,
  });

  bool get isSuccess => isAuthenticated;

  String get friendlyMessage {
    if (isAuthenticated) return 'Authentication successful';

    switch (errorCode) {
      case 'USER_CANCEL':
        return 'Authentication was cancelled';
      case 'BIOMETRY_LOCKOUT':
        return 'Too many failed attempts. Try again later';
      case 'BIOMETRY_NOT_ENROLLED':
        return 'No biometric authentication is set up';
      case 'BIOMETRIC_NOT_AVAILABLE':
        return 'Biometric authentication is not available';
      case 'DEVICE_CREDENTIAL_NOT_AVAILABLE':
        return 'Device lock screen is not set up';
      default:
        return errorMessage ?? 'Authentication failed';
    }
  }
}
