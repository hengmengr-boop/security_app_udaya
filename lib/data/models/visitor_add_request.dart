import 'package:equatable/equatable.dart';

/// POST `/visitor/add` payload based on the visitor fields in the API sample.
/// TODO(verify): Confirm add-request keys and whether room/facility IDs are required.
final class VisitorAddRequest extends Equatable {
  const VisitorAddRequest({
    required this.visitorName,
    required this.visitDate,
    required this.timeFrom,
    required this.timeTo,
    required this.purpose,
    this.gender = 1,
    this.member = 1,
    this.phoneNumber,
    this.licensePlate,
    this.hrBookingFacilityId,
  });

  final String visitorName;
  final int gender;
  final int member;
  final String? phoneNumber;
  final String? licensePlate;
  final String visitDate;
  final String timeFrom;
  final String timeTo;
  final String purpose;
  final int? hrBookingFacilityId;

  @override
  List<Object?> get props => [
        visitorName,
        gender,
        member,
        phoneNumber,
        licensePlate,
        visitDate,
        timeFrom,
        timeTo,
        purpose,
        hrBookingFacilityId,
      ];

  Map<String, dynamic> toJson() => {
        'visitorName': visitorName,
        'gender': gender,
        'member': member,
        if (phoneNumber != null && phoneNumber!.isNotEmpty)
          'phoneNumber': phoneNumber,
        if (licensePlate != null && licensePlate!.isNotEmpty)
          'licensePlate': licensePlate,
        'visitDate': visitDate,
        'timeFrom': timeFrom,
        'timeTo': timeTo,
        'purpose': purpose,
        if (hrBookingFacilityId != null)
          'hrBookingFacilityId': hrBookingFacilityId,
      };

  factory VisitorAddRequest.fromVisitorJson(Map<String, dynamic> visitor) {
    final start = DateTime.parse(visitor['startTime'].toString());
    final end = DateTime.parse(visitor['endTime'].toString());
    String date(DateTime value) =>
        '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
    String time(DateTime value) =>
        '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';

    return VisitorAddRequest(
      visitorName:
          (visitor['name'] ?? visitor['visitorName'] ?? '').toString().trim(),
      gender: int.tryParse('${visitor['gender'] ?? 1}') ?? 1,
      member: int.tryParse('${visitor['member'] ?? 1}') ?? 1,
      phoneNumber: visitor['phone']?.toString(),
      licensePlate: visitor['licensePlate']?.toString(),
      visitDate: date(start),
      timeFrom: time(start),
      timeTo: time(end),
      purpose: (visitor['purpose'] ?? '').toString().trim(),
      hrBookingFacilityId:
          int.tryParse('${visitor['hrBookingFacilityId'] ?? ''}'),
    );
  }
}
