import 'package:flutter/material.dart';
import 'package:payhive/constants/urls.dart';
import 'package:payhive/services/network/api_result.dart';
import 'package:payhive/services/network/network.dart';

import '../di/di.dart';

class BBPSAuthToken {
  static const _ttl = Duration(minutes: 4);

  static getBBPSAuthToken() async {
    try {
      final now = DateTime.now();

      final bool shouldCall;
      if (bbPSAuthTokenTime == null) {
        shouldCall = true;
      } else {
        final elapsed = now.difference(bbPSAuthTokenTime!);
        shouldCall = elapsed >= _ttl;
      }

      if (!shouldCall) {
        return false;
      }

      final res =
          await Network().postDataWithJson(endPoint: URLs.bbpsAuthToken);
      if (res is ApiSuccess) {
        final token = res.data?['data']?['token'];
        if (token is String && token.isNotEmpty) {
          bbPSAuthToken = token;
          bbPSAuthTokenTime = now;
          return true;
        }
      }
    } catch (exception, stackTrace) {
      debugPrint('getBBPSAuthToken error: $exception $stackTrace');
    }
    return false;
  }
}
