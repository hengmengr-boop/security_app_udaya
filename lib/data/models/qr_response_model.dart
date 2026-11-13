import 'package:equatable/equatable.dart';

/// Response model for `POST /visitor/qr-code/{id}`
/// // TODO(verify): Schema assumption for QR code response
final class QrResponseModel extends Equatable {
  const QrResponseModel({
    required this.qrToken,
    this.rawString,
    this.base64Image,
  });

  final String qrToken;
  final String? rawString;
  final String? base64Image;

  @override
  List<Object?> get props => [qrToken, rawString, base64Image];

  factory QrResponseModel.fromJson(Map<String, dynamic> json) {
    // TODO(verify): Verify QR response keys
    return QrResponseModel(
      qrToken: (json['qrToken'] ??
              json['token'] ??
              json['qrCode'] ??
              json['code'] ??
              '')
          .toString(),
      rawString: json['rawString']?.toString(),
      base64Image: json['base64Image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'qrToken': qrToken,
        if (rawString != null) 'rawString': rawString,
        if (base64Image != null) 'base64Image': base64Image,
      };
}
