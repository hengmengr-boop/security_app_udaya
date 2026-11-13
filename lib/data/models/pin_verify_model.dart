import 'package:equatable/equatable.dart';
import 'package:udaya_visitor/data/models/visitor_model.dart';

/// Request model for `POST /visitor/public/verify-pin`
final class PinVerifyRequest extends Equatable {
  const PinVerifyRequest({
    required this.pin,
    required this.visitorId,
  });

  final String pin;
  final int visitorId;

  @override
  List<Object?> get props => [pin, visitorId];

  Map<String, dynamic> toJson() => {
        'pin': pin,
        'visitorId': visitorId,
      };
}

/// Response model for `POST /visitor/public/verify-pin`
/// // TODO(verify): Schema assumption for PIN verification response
final class PinVerifyResponse extends Equatable {
  const PinVerifyResponse({
    required this.isValid,
    this.message,
    this.visitor,
  });

  final bool isValid;
  final String? message;
  final VisitorModel? visitor;

  @override
  List<Object?> get props => [isValid, message, visitor];

  factory PinVerifyResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final data = rawData is List &&
            rawData.isNotEmpty &&
            rawData.first is Map<String, dynamic>
        ? rawData.first as Map<String, dynamic>
        : rawData is Map<String, dynamic>
            ? rawData
            : null;
    return PinVerifyResponse(
      isValid: _asBool(json['status'] ?? json['isValid'] ?? json['valid']),
      message: (json['message'] ?? json['msg'])?.toString(),
      visitor: json['visitor'] != null
          ? VisitorModel.fromJson(json['visitor'] as Map<String, dynamic>)
          : data != null
              ? VisitorModel.fromJson(data)
              : null,
    );
  }

  static bool _asBool(dynamic value) =>
      value == true || value == 1 || value?.toString().toLowerCase() == 'true';
}
