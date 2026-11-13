import 'package:equatable/equatable.dart';

/// Item model for `POST /visitor/report`
/// // TODO(verify): Schema assumption for visitor report item
final class ReportItemModel extends Equatable {
  const ReportItemModel({
    required this.id,
    required this.visitorName,
    required this.purpose,
    required this.room,
    required this.status,
    this.checkInTime,
    this.checkOutTime,
    this.hostName,
  });

  final String id;
  final String visitorName;
  final String purpose;
  final String room;
  final String status;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? hostName;

  @override
  List<Object?> get props => [
        id,
        visitorName,
        purpose,
        room,
        status,
        checkInTime,
        checkOutTime,
        hostName,
      ];

  factory ReportItemModel.fromJson(Map<String, dynamic> json) {
    // TODO(verify): Verify fields in report response
    return ReportItemModel(
      id: json['id']?.toString() ?? '',
      visitorName:
          (json['visitorName'] ?? json['full_name'] ?? json['name'] ?? '')
              .toString()
              .trim(),
      purpose: (json['purpose'] as String?) ?? '',
      room: (json['meetingRoomName'] ?? json['room'] ?? json['room_code'] ?? '')
          .toString()
          .trim(),
      status: (json['statusName'] ?? json['status'] ?? 'upcoming')
          .toString()
          .trim(),
      checkInTime: json['checkInTime'] == null
          ? null
          : DateTime.tryParse(json['checkInTime'].toString()),
      checkOutTime: json['checkOutTime'] == null
          ? null
          : DateTime.tryParse(json['checkOutTime'].toString()),
      hostName: json['hostName'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'visitorName': visitorName,
        'purpose': purpose,
        'room': room,
        'status': status,
        'checkInTime': checkInTime?.toIso8601String(),
        'checkOutTime': checkOutTime?.toIso8601String(),
        'hostName': hostName,
      };
}
