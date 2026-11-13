import 'dart:convert';
import 'package:equatable/equatable.dart';

enum VisitorStatus { upcoming, onSite, checkedOut }

/// A scheduled visitor model compatible with the company API response formats.
class VisitorModel extends Equatable {
  const VisitorModel({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.purpose,
    this.status = VisitorStatus.upcoming,
    this.checkInAt,
    this.checkOutAt,
    this.company,
    this.phone,
    this.gender = 1,
    this.member = 1,
    this.licensePlate,
    this.initialsOverride,
    this.genderName,
    this.statusName,
    this.hrBookingFacilityId,
    this.hostId,
    this.hostName,
    this.hostRole,
    this.hostPhoto,
    this.hostPhoneNumber,
    this.hostEmail,
    this.publicWebviewUrl,
    this.duration,
    this.createdBy,
    this.createdByName,
    this.created,
  });

  final String id;
  final String name;
  final DateTime startTime;
  final DateTime endTime;

  /// Room code or room title, e.g. `HOGF`
  final String room;
  final String purpose;
  final VisitorStatus status;
  final DateTime? checkInAt;
  final DateTime? checkOutAt;
  final String? company;
  final String? phone;

  /// API values: 1 male, 2 female, 3 other.
  final int gender;
  final int member;
  final String? licensePlate;
  final String? initialsOverride;
  final String? genderName;
  final String? statusName;
  final int? hrBookingFacilityId;
  final int? hostId;
  final String? hostName;
  final String? hostRole;
  final String? hostPhoto;
  final String? hostPhoneNumber;
  final String? hostEmail;
  final String? publicWebviewUrl;
  final String? duration;
  final int? createdBy;
  final String? createdByName;
  final DateTime? created;

  @override
  List<Object?> get props => [
        id,
        name,
        startTime,
        endTime,
        room,
        purpose,
        status,
        checkInAt,
        checkOutAt,
        company,
        phone,
        gender,
        member,
        licensePlate,
        initialsOverride,
        genderName,
        statusName,
        hrBookingFacilityId,
        hostId,
        hostName,
        hostRole,
        hostPhoto,
        hostPhoneNumber,
        hostEmail,
        publicWebviewUrl,
        duration,
        createdBy,
        createdByName,
        created,
      ];

  /// First letters of the first two words, e.g. `Jonathan Simmons` -> `JS`.
  String get initials {
    if (initialsOverride?.trim().isNotEmpty ?? false) {
      return initialsOverride!.trim();
    }
    final parts =
        name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    String first(String s) => String.fromCharCode(s.runes.first);
    final value =
        parts.length > 1 ? first(parts[0]) + first(parts[1]) : first(parts[0]);
    return value.toUpperCase();
  }

  /// Payload encoded into the visitor QR code (scanned at gate).
  String get qrData => 'UDAYA-VISITOR:$id';

  VisitorModel copyWith({
    String? name,
    DateTime? startTime,
    DateTime? endTime,
    String? room,
    String? purpose,
    VisitorStatus? status,
    DateTime? checkInAt,
    DateTime? checkOutAt,
    String? company,
    String? phone,
    int? gender,
    int? member,
    String? licensePlate,
    String? initialsOverride,
    String? genderName,
    String? statusName,
    int? hrBookingFacilityId,
    int? hostId,
    String? hostName,
    String? hostRole,
    String? hostPhoto,
    String? hostPhoneNumber,
    String? hostEmail,
    String? publicWebviewUrl,
    String? duration,
    int? createdBy,
    String? createdByName,
    DateTime? created,
  }) {
    return VisitorModel(
      id: id,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      room: room ?? this.room,
      purpose: purpose ?? this.purpose,
      status: status ?? this.status,
      checkInAt: checkInAt ?? this.checkInAt,
      checkOutAt: checkOutAt ?? this.checkOutAt,
      company: company ?? this.company,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      member: member ?? this.member,
      licensePlate: licensePlate ?? this.licensePlate,
      initialsOverride: initialsOverride ?? this.initialsOverride,
      genderName: genderName ?? this.genderName,
      statusName: statusName ?? this.statusName,
      hrBookingFacilityId: hrBookingFacilityId ?? this.hrBookingFacilityId,
      hostId: hostId ?? this.hostId,
      hostName: hostName ?? this.hostName,
      hostRole: hostRole ?? this.hostRole,
      hostPhoto: hostPhoto ?? this.hostPhoto,
      hostPhoneNumber: hostPhoneNumber ?? this.hostPhoneNumber,
      hostEmail: hostEmail ?? this.hostEmail,
      publicWebviewUrl: publicWebviewUrl ?? this.publicWebviewUrl,
      duration: duration ?? this.duration,
      createdBy: createdBy ?? this.createdBy,
      createdByName: createdByName ?? this.createdByName,
      created: created ?? this.created,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'room': room,
        'purpose': purpose,
        'status': status.name,
        'checkInAt': checkInAt?.toIso8601String(),
        'checkOutAt': checkOutAt?.toIso8601String(),
        if (company != null) 'company': company,
        if (phone != null) 'phone': phone,
        'gender': gender,
        'member': member,
        if (licensePlate != null) 'licensePlate': licensePlate,
      };

  factory VisitorModel.fromJson(Map<String, dynamic> json) {
    // Handles both API formats: production uses mixed cases, local uses snake_case
    final rawId = json['id'] ?? json['_id'] ?? json['visitorId'] ?? '';
    final id = rawId.toString();
    final name = (json['visitorName'] ??
            json['name'] ??
            json['full_name'] ??
            json['fullName'] ??
            '')
        .toString();

    DateTime parseDate(dynamic value, {dynamic time}) {
      final parsed = value is DateTime
          ? value
          : DateTime.tryParse(value?.toString() ?? '');
      final base = parsed ?? DateTime.now();
      final timeText = time?.toString() ?? '';
      final parts = timeText.split(':');
      if (parts.length >= 2) {
        return DateTime(
          base.year,
          base.month,
          base.day,
          int.tryParse(parts[0]) ?? 0,
          int.tryParse(parts[1]) ?? 0,
        );
      }
      return base;
    }

    final rawStatus = (json['statusName'] ?? json['status'] ?? '')
        .toString()
        .trim()
        .toLowerCase();
    final statusCode = int.tryParse('${json['status'] ?? ''}');
    VisitorStatus parsedStatus = VisitorStatus.upcoming;
    if (rawStatus.contains('site') ||
        rawStatus.contains('onsite') ||
        rawStatus.contains('on_site')) {
      parsedStatus = VisitorStatus.onSite;
    } else if (rawStatus.contains('out') ||
        rawStatus.contains('checkout') ||
        rawStatus.contains('checked_out')) {
      parsedStatus = VisitorStatus.checkedOut;
    } else if (statusCode == 2) {
      // Production API: status code 2 = On-Site
      parsedStatus = VisitorStatus.onSite;
    } else if (statusCode == 3) {
      // Production API: status code 3 = Checked-Out
      parsedStatus = VisitorStatus.checkedOut;
    }

    return VisitorModel(
      id: id,
      name: name,
      startTime: parseDate(
        json['startTime'] ?? json['visitDate'] ?? json['visit_date'],
        time: json['timeFrom'],
      ),
      endTime: parseDate(
        json['endTime'] ?? json['visitDate'] ?? json['visit_date'],
        time: json['timeTo'],
      ),
      room: (json['meetingRoomName'] ??
              json['room'] ??
              json['room_code'] ??
              json['roomName'] ??
              '')
          .toString()
          .trim(),
      purpose: (json['purpose'] ?? '').toString().trim(),
      status: parsedStatus,
      checkInAt: json['checkInAt'] == null
          ? null
          : DateTime.tryParse(json['checkInAt'].toString()),
      checkOutAt: json['checkOutAt'] == null
          ? null
          : DateTime.tryParse(json['checkOutAt'].toString()),
      company: (json['companyName'] ?? json['company'])?.toString().trim(),
      phone: (json['phone'] ?? json['phoneNumber'])?.toString().trim(),
      gender: int.tryParse('${json['gender'] ?? 1}') ?? 1,
      member: int.tryParse('${json['member'] ?? 1}') ?? 1,
      licensePlate: json['licensePlate']?.toString().trim(),
      initialsOverride: json['initials']?.toString().trim(),
      genderName: json['genderName']?.toString().trim(),
      statusName: json['statusName']?.toString().trim(),
      hrBookingFacilityId: int.tryParse('${json['hrBookingFacilityId'] ?? ''}'),
      hostId: int.tryParse('${json['hostId'] ?? ''}'),
      hostName: json['hostName']?.toString().trim(),
      hostRole: json['hostRole']?.toString().trim(),
      hostPhoto: json['hostPhoto']?.toString().trim(),
      hostPhoneNumber: json['hostPhoneNumber']?.toString().trim(),
      hostEmail: json['hostEmail']?.toString().trim(),
      publicWebviewUrl: json['publicWebviewUrl']?.toString().trim(),
      duration: json['duration']?.toString().trim(),
      createdBy: int.tryParse('${json['createdBy'] ?? ''}'),
      createdByName: json['createdByName']?.toString().trim(),
      created: json['created'] == null
          ? null
          : DateTime.tryParse(json['created'].toString()),
    );
  }

  static String encodeList(List<VisitorModel> list) =>
      jsonEncode(list.map((e) => e.toJson()).toList());

  static List<VisitorModel> decodeList(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    try {
      final data = jsonDecode(raw) as List<dynamic>;
      return data
          .map((e) => VisitorModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
