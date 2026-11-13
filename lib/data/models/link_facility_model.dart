import 'package:equatable/equatable.dart';

/// Request model for `POST /visitor/link-facility`
final class LinkFacilityRequest extends Equatable {
  const LinkFacilityRequest({
    required this.visitorId,
    required this.facilityId,
  });

  final int visitorId;
  final int facilityId;

  @override
  List<Object?> get props => [visitorId, facilityId];

  Map<String, dynamic> toJson() => {
        'visitorId': visitorId,
        'facilityId': facilityId,
      };
}
