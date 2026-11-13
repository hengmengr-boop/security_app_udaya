import 'package:equatable/equatable.dart';

/// Response model for `POST /visitor/count-badge`
/// // TODO(verify): Schema assumption for count badge fields
final class BadgeCountModel extends Equatable {
  const BadgeCountModel({
    required this.upcoming,
    required this.onSite,
    required this.checkedOut,
    required this.total,
  });

  final int upcoming;
  final int onSite;
  final int checkedOut;
  final int total;

  @override
  List<Object?> get props => [upcoming, onSite, checkedOut, total];

  factory BadgeCountModel.fromJson(Map<String, dynamic> json) {
    // TODO(verify): Verify exact key names in count-badge response
    int count(Iterable<dynamic> values) {
      for (final value in values) {
        final parsed = int.tryParse(value?.toString() ?? '');
        if (parsed != null) return parsed;
      }
      return 0;
    }

    final upcoming = count([json['upcoming'], json['upcomingCount']]);
    final onSite =
        count([json['onSite'], json['onSiteCount'], json['on_site']]);
    final checkedOut = count([
      json['checkedOut'],
      json['checkedOutCount'],
      json['checked_out'],
    ]);
    final total = count([
      json['total'],
      json['totalCount'],
      upcoming + onSite + checkedOut,
    ]);

    return BadgeCountModel(
      upcoming: upcoming,
      onSite: onSite,
      checkedOut: checkedOut,
      total: total,
    );
  }

  Map<String, dynamic> toJson() => {
        'upcoming': upcoming,
        'onSite': onSite,
        'checkedOut': checkedOut,
        'total': total,
      };
}
