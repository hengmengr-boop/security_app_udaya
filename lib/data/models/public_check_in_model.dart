import 'package:equatable/equatable.dart';

/// Request model for `POST /visitor/public/check-in`
final class PublicCheckInRequest extends Equatable {
  const PublicCheckInRequest({
    required this.status,
    required this.visitorId,
    this.pin,
  });

  /// 1 checks in, 2 checks out.
  final int status;
  final int visitorId;
  final String? pin;

  @override
  List<Object?> get props => [status, visitorId, pin];

  Map<String, dynamic> toJson() => {
        'status': status,
        'visitorId': visitorId,
        if (pin != null) 'pin': pin,
      };
}
