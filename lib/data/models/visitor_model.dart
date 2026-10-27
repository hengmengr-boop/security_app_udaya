import 'dart:convert';

enum VisitorStatus { upcoming, onSite, checkedOut }

/// A scheduled visitor. Plain Dart model, hand-written toJson/fromJson
/// (no build_runner needed).
final class VisitorModel {
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
  });

  final String id;
  final String name;
  final DateTime startTime;
  final DateTime endTime;

  /// Room code only, e.g. `A` (the UI prefixes it with the localized "Room").
  final String room;
  final String purpose;
  final VisitorStatus status;
  final DateTime? checkInAt;
  final DateTime? checkOutAt;

  /// First letters of the first two words, e.g. `Jonathan Simmons` -> `JS`.
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    String first(String s) => String.fromCharCode(s.runes.first);
    final value = parts.length > 1 ? first(parts[0]) + first(parts[1]) : first(parts[0]);
    return value.toUpperCase();
  }

  /// Payload encoded into the visitor QR code (scanned at the gate).
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
  };

  factory VisitorModel.fromJson(Map<String, dynamic> json) {
    return VisitorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      room: json['room'] as String,
      purpose: (json['purpose'] as String?) ?? '',
      status: VisitorStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => VisitorStatus.upcoming,
      ),
      checkInAt: json['checkInAt'] == null ? null : DateTime.parse(json['checkInAt'] as String),
      checkOutAt: json['checkOutAt'] == null ? null : DateTime.parse(json['checkOutAt'] as String),
    );
  }

  static String encodeList(List<VisitorModel> list) => jsonEncode(list.map((e) => e.toJson()).toList());

  static List<VisitorModel> decodeList(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    try {
      final data = jsonDecode(raw) as List<dynamic>;
      return data.map((e) => VisitorModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }
}
