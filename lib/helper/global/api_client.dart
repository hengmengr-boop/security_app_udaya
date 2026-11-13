import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:udaya_visitor/helper/global/api_constants.dart';
import 'package:udaya_visitor/helper/global/secure_storage_helper.dart';
import 'package:udaya_visitor/helper/preference/app_preference.dart';

/// Shared API client for the UT HR System backend.
final class ApiClient {
  ApiClient({String? baseUrl, Dio? dio, this.onUnauthorized})
      : _dio = dio ?? Dio() {
    _dio.options.baseUrl = baseUrl ?? ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    _dio.options.sendTimeout = const Duration(seconds: 15);
    _dio.options.headers = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final path = options.path.toLowerCase();
        final isPublic = path == ApiConstants.authLogin ||
            path.startsWith('/visitor/public/') ||
            path.startsWith('/visitor/find/');
        if (!isPublic) {
          final token = await SecureStorageHelper.instance.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] =
                token.startsWith('Bearer ') ? token : 'Bearer $token';
          }
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await SecureStorageHelper.instance.clearTokens();
          await AppPreference.clearCredential();
          onUnauthorized?.call();
        }
        handler.next(error);
      },
    ));
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestHeader: false,
        responseHeader: false,
        requestBody: true,
        responseBody: true,
      ));
    }
  }

  static final ApiClient shared = ApiClient();

  final Dio _dio;
  VoidCallback? onUnauthorized;
  Dio get dio => _dio;

  Future<Response<T>> post<T>(String path,
      {Object? data, Map<String, dynamic>? queryParameters, Options? options}) {
    return _dio.post<T>(path,
        data: data, queryParameters: queryParameters, options: options);
  }
}

/// Validates the backend `{header, body}` envelope and returns its body.
abstract final class ApiResponseParser {
  static Map<String, dynamic> body(Map<String, dynamic>? response) {
    final payload = response ?? const <String, dynamic>{};
    final header = payload['header'];
    if (header is Map) {
      final statusCode = int.tryParse('${header['statusCode'] ?? ''}');
      if (header['result'] == false ||
          (statusCode != null && statusCode >= 400)) {
        throw FormatException(_message(payload));
      }
    }
    final rawBody = payload['body'];
    if (rawBody is! Map) {
      if (rawBody is List) return {'data': rawBody};
      return payload;
    }
    final parsedBody = Map<String, dynamic>.from(rawBody);
    if (parsedBody['status'] == false) {
      throw FormatException(_message(parsedBody));
    }
    return parsedBody;
  }

  static String _message(Map data) {
    final message = data['message'] ?? data['error'] ?? data['msg'];
    if (message != null && message.toString().trim().isNotEmpty) {
      return message.toString().trim();
    }
    return 'The server rejected the request.';
  }
}
