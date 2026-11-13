import 'dart:io';
import 'package:dio/dio.dart';
import 'package:udaya_visitor/data/api/visitor_api.dart';
import 'package:udaya_visitor/data/models/badge_count_model.dart';
import 'package:udaya_visitor/data/models/link_facility_model.dart';
import 'package:udaya_visitor/data/models/pin_verify_model.dart';
import 'package:udaya_visitor/data/models/public_check_in_model.dart';
import 'package:udaya_visitor/data/models/qr_response_model.dart';
import 'package:udaya_visitor/data/models/report_item_model.dart';
import 'package:udaya_visitor/data/models/visitor_list_filter_request.dart';
import 'package:udaya_visitor/data/models/visitor_model.dart';

/// Custom Exception wrapper for Visitor API operations.
final class VisitorException implements Exception {
  const VisitorException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

/// Visitor Repository bridging UI/BLoC to API and error parsing.
class VisitorRepository {
  VisitorRepository({VisitorApi? api}) : _api = api ?? VisitorApi();

  final VisitorApi _api;

  Future<List<VisitorModel>> getVisitors(
      VisitorListFilterRequest filter) async {
    return _guard(() => _api.getList(filter));
  }

  Future<VisitorModel> addVisitor(VisitorModel visitor) async {
    return _guard(() => _api.addVisitor(visitor.toJson()));
  }

  Future<VisitorModel> checkIn(String id) async {
    return _guard(() => _api.checkIn(id));
  }

  Future<VisitorModel> checkOut(String id) async {
    return _guard(() => _api.checkOut(id));
  }

  Future<BadgeCountModel> countBadge({Map<String, dynamic>? filter}) async {
    return _guard(() => _api.countBadge(filter: filter));
  }

  Future<VisitorModel> findById(String id) async {
    return _guard(() => _api.findById(id));
  }

  Future<Map<String, dynamic>> linkFacility(LinkFacilityRequest request) async {
    return _guard(() => _api.linkFacility(request));
  }

  Future<VisitorModel> publicCheckIn(PublicCheckInRequest request) async {
    return _guard(() => _api.publicCheckIn(request));
  }

  Future<PinVerifyResponse> publicVerifyPin(PinVerifyRequest request) async {
    return _guard(() => _api.publicVerifyPin(request));
  }

  Future<QrResponseModel> getQrCode(String id) async {
    return _guard(() => _api.getQrCode(id));
  }

  Future<List<ReportItemModel>> getReport(Map<String, dynamic> body) async {
    return _guard(() => _api.getReport(body));
  }

  /// Helper to convert exceptions into user-friendly [VisitorException].
  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is VisitorException) rethrow;
      throw const VisitorException(
        'The server could not complete the request. Please try again later.',
      );
    }
  }

  VisitorException _handleDioError(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const VisitorException('Connection timeout. Please try again.',
          statusCode: 408);
    }

    if (error.error is SocketException ||
        error.type == DioExceptionType.connectionError) {
      return const VisitorException(
          'No internet connection. Please check your network.',
          statusCode: 0);
    }

    if (statusCode != null && statusCode >= 500) {
      return VisitorException(
        'Server error occurred. Please try again later.',
        statusCode: statusCode,
      );
    }

    if (response?.data != null && response!.data is Map<String, dynamic>) {
      final msg = response.data['message'] ??
          response.data['error'] ??
          response.data['msg'];
      if (msg != null && msg.toString().isNotEmpty) {
        return VisitorException(msg.toString(), statusCode: statusCode);
      }
    }

    switch (statusCode) {
      case 401:
        return const VisitorException(
            'Unauthorized access. Please sign in again.',
            statusCode: 401);
      case 403:
        return const VisitorException('Access forbidden.', statusCode: 403);
      case 404:
        return const VisitorException(
            'Requested visitor or endpoint not found.',
            statusCode: 404);
      case 500:
      case 502:
      case 503:
        return const VisitorException(
            'Server error occurred. Please try again later.',
            statusCode: 500);
      default:
        return VisitorException(error.message ?? 'An unknown error occurred.',
            statusCode: statusCode);
    }
  }
}
