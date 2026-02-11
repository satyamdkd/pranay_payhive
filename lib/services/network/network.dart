import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as network;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:payhive/constants/urls.dart';
import 'package:payhive/services/di/di.dart';
import 'package:payhive/services/network/api_result.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/widgets/snackbar.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class Network {
  final network.Dio _dio;
  static final String _baseUrl = URLs.baseURl;

  Network()
      : _dio = network.Dio()
          ..options = network.BaseOptions(
            baseUrl: _baseUrl,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
              'X-BBPS-TOKEN': bbPSAuthToken,
            },
          )
          ..interceptors.addAll([
            PrettyDioLogger(
              requestHeader: true,
              requestBody: true,
              responseBody: true,
              request: true,
              responseHeader: true,
            ),
            network.InterceptorsWrapper(
              onRequest: (options, handler) => handler.next(options),
            ),
          ]);

  getData({
    Map<String, dynamic>? queryParameters,
    required String endPoint,
  }) async {
    if (kDebugMode) {
      debugPrint(token);
    }

    try {
      final response = await _dio.get(
        _baseUrl + endPoint,
        queryParameters: queryParameters,
      );
      return returnResponse(response);
    } on SocketException {
      return ApiFailure('Socket Exception');
    } on FormatException {
      return ApiFailure('Format Exception');
    } on network.DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiFailure('Unexpected Error');
    }
  }

  Future<ApiResults> postData({
    dynamic data,
    required String endPoint,
  }) async {
    try {
      final response = await _dio.post(
        endPoint,
        data: network.FormData.fromMap(data ?? {}),
      );
      return returnResponse(response);
    } on SocketException {
      return ApiFailure('Socket Exception');
    } on FormatException {
      return ApiFailure('Format Exception');
    } on network.DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiFailure('Unexpected Error');
    }
  }

  Future<ApiResults> postDataWithJson({
    dynamic data,
    required String endPoint,
  }) async {
    try {
      final response = await _dio.post(
        endPoint,
        data: json.encode(data ?? {}),
      );
      return returnResponse(response);
    } on SocketException {
      return ApiFailure('Socket Exception');
    } on FormatException {
      return ApiFailure('Format Exception');
    } on network.DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiFailure('Unexpected Error');
    }
  }

  postDataWithFilesNew(
      {Map<String, dynamic>? data,
      required String endPoint,
      required network.FormData formData,
      callback}) async {
    try {
      final response = await _dio.post(
        _baseUrl + endPoint,
        queryParameters: data,
        data: formData,
        onSendProgress: (int sent, int total) {
          double percent = sent / total * 100;
          percentage = percent.toString().split(".").first;
          debugPrint('UPLOADED - ${percent.toString().split(".").first}');
          callback;
        },
      );

      return returnResponse(response);
    } on SocketException {
      return ApiFailure('Socket Exception');
    } on FormatException {
      return ApiFailure('Format Exception');
    } on network.DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiFailure('Unexpected Error');
    }
  }

  String _cleanErrorMessage(dynamic data) {
    if (data == null) return "The error message was empty.";

    final regex = RegExp(r'[{}:\[\]]|\b(errors|error)\b', caseSensitive: false);

    return data.toString().replaceAll(regex, '').trim();
  }

  ApiResults returnResponse(network.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint("Successful response received: ${response.statusCode}");
      dynamic responseData = response.data;

      if (responseData is String) {
        try {
          responseData = json.decode(responseData);
        } catch (e) {
          return ApiFailure(
              title: 'JSON Parsing Error', 'Failed to decode response string.');
        }
      }

      if (responseData is Map<String, dynamic> || responseData is List) {
        return ApiSuccess(responseData, response.statusCode);
      } else {
        return ApiFailure(
          title: 'Unexpected Response Format',
          'Received data of type: ${responseData.runtimeType}',
        );
      }
    }

    final errorMessage = _cleanErrorMessage(response.data);

    switch (response.statusCode) {
      case 400:
        return ApiFailure(title: "Bad Request", errorMessage);
      case 401:
        return ApiFailure(
            title: "Token Expired or Invalid Credentials!", errorMessage);
      case 403:
        return ApiFailure(title: "Token Error", errorMessage);
      case 422:
        return ApiFailure(title: "Invalid Data", errorMessage);
      case 404:
        return ApiFailure(
            title: "Resource Not Found",
            "The requested endpoint was not found.");
      case 500:
        return ApiFailure(
            title: "Internal Server Error", "An issue occurred on the server.");
      default:
        return ApiFailure(
          title: 'Server Communication Error',
          'Error with status code: ${response.statusCode}',
        );
    }
  }

  ApiResults _handleDioError(network.DioException e) {
    if (e.response != null) {
      return returnResponse(e.response!);
    } else {
      switch (e.type) {
        case network.DioExceptionType.connectionTimeout:
          return ApiFailure('Connection Timeout');
        case network.DioExceptionType.receiveTimeout:
          return ApiFailure('Receive Timeout');
        case network.DioExceptionType.connectionError:
          showSnackBar(
            message: "Something went wrong, PLease try after some time",
            title: "Error",
            color: Colors.red,
          );
          return ApiFailure('No Internet');
        default:
          return ApiFailure('Unknown Error: ${e.message}');
      }
    }
  }
}
