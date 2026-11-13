import 'package:udaya_visitor/data/data_export.dart';
import 'package:udaya_visitor/helper/global/api_client.dart';
import 'package:udaya_visitor/helper/global/api_constants.dart';

/// Visitor Management REST API Client for Module 31 (ALL POST endpoints).
class VisitorApi {
  VisitorApi({ApiClient? apiClient}) : _client = apiClient ?? ApiClient.shared;

  final ApiClient _client;

  Map<String, dynamic> _apiBody(Map<String, dynamic>? response) {
    return ApiResponseParser.body(response);
  }

  Map<String, dynamic> _firstData(Map<String, dynamic>? response) {
    final body = _apiBody(response);
    final data = body['data'];
    if (data is List && data.isNotEmpty && data.first is Map<String, dynamic>) {
      return data.first as Map<String, dynamic>;
    }
    if (data is Map<String, dynamic>) return data;
    return body;
  }

  List<dynamic> _dataList(Map<String, dynamic>? response) {
    final body = _apiBody(response);
    final data = body['data'] ?? body['items'] ?? body['visitors'];
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final nested = data['items'] ?? data['visitors'] ?? data['data'];
      if (nested is List) return nested;
    }
    return const [];
  }

  int _numericId(String id) => int.parse(id);

  /// POST /visitor/add - Add new visitor 🔒
  Future<VisitorModel> addVisitor(Map<String, dynamic> body) async {
    final request = VisitorAddRequest.fromVisitorJson(body);
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.visitorAdd,
      data: request.toJson(),
    );
    return VisitorModel.fromJson(_firstData(response.data));
  }

  /// POST /visitor/check-in/{id} - Check in visitor 🔒
  Future<VisitorModel> checkIn(String id, {Map<String, dynamic>? body}) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.visitorCheckIn(_numericId(id)),
      data: body ?? {},
    );
    return VisitorModel.fromJson(_firstData(response.data));
  }

  /// POST /visitor/check-out/{id} - Check out visitor 🔒
  Future<VisitorModel> checkOut(String id, {Map<String, dynamic>? body}) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.visitorCheckOut(_numericId(id)),
      data: body ?? {},
    );
    return VisitorModel.fromJson(_firstData(response.data));
  }

  /// POST /visitor/count-badge - Count visitors by status 🔒
  Future<BadgeCountModel> countBadge({Map<String, dynamic>? filter}) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.visitorCountBadge,
      data: filter ?? {},
    );
    return BadgeCountModel.fromJson(_firstData(response.data));
  }

  /// POST /visitor/find/{id} - Find visitor by id
  Future<VisitorModel> findById(String id, {Map<String, dynamic>? body}) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.visitorFind(_numericId(id)),
      data: body ?? {},
    );
    return VisitorModel.fromJson(_firstData(response.data));
  }

  /// POST /visitor/link-facility - Link visitor to facility room booking 🔒
  Future<Map<String, dynamic>> linkFacility(LinkFacilityRequest request) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.visitorLinkFacility,
      data: request.toJson(),
    );
    return _apiBody(response.data);
  }

  /// POST /visitor/list - List visitors by filter 🔒
  Future<List<VisitorModel>> getList(VisitorListFilterRequest request) async {
    final response = await _client.post(
      ApiConstants.visitorList,
      data: request.toJson(),
    );
    return _dataList(response.data)
        .whereType<Map<String, dynamic>>()
        .map(VisitorModel.fromJson)
        .toList();
  }

  /// POST /visitor/public/check-in - Public self check-in/out via Webview
  Future<VisitorModel> publicCheckIn(PublicCheckInRequest request) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.visitorPublicCheckIn,
      data: request.toJson(),
    );
    return VisitorModel.fromJson(_firstData(response.data));
  }

  /// POST /visitor/public/verify-pin - Public verify PIN for Webview
  Future<PinVerifyResponse> publicVerifyPin(PinVerifyRequest request) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.visitorPublicVerifyPin,
      data: request.toJson(),
    );
    return PinVerifyResponse.fromJson(_apiBody(response.data));
  }

  /// POST /visitor/qr-code/{id} - Get QR code for visitor 🔒
  Future<QrResponseModel> getQrCode(String id,
      {Map<String, dynamic>? body}) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiConstants.visitorQrCode(_numericId(id)),
      data: body ?? {},
    );
    return QrResponseModel.fromJson(_firstData(response.data));
  }

  /// POST /visitor/report - Admin visitor report 🔒
  Future<List<ReportItemModel>> getReport(Map<String, dynamic> body) async {
    final response = await _client.post(
      ApiConstants.visitorReport,
      data: body,
    );
    return _dataList(response.data)
        .whereType<Map<String, dynamic>>()
        .map(ReportItemModel.fromJson)
        .toList();
  }
}
