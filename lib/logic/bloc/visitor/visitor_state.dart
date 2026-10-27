part of 'visitor_bloc.dart';

sealed class VisitorState {}

final class VisitorInitial extends VisitorState {}

final class VisitorLoadedState extends VisitorState {
  VisitorLoadedState({
    required this.all,
    this.tab = VisitorStatus.upcoming,
    this.query = '',
    this.room,
    this.todayOnly = false,
  });

  final List<VisitorModel> all;
  final VisitorStatus tab;
  final String query;
  final String? room;
  final bool todayOnly;

  static const _unset = Object();

  bool get hasFilter => room != null || todayOnly;

  /// Distinct room codes, sorted (feeds the filter sheet).
  List<String> get rooms => (all.map((e) => e.room).toSet().toList())..sort();

  /// Visitors of the selected tab after search + filter, soonest first.
  List<VisitorModel> get visible {
    final now = DateTime.now();
    final q = query.trim().toLowerCase();
    final list = all.where((v) {
      if (v.status != tab) return false;
      if (q.isNotEmpty && !v.name.toLowerCase().contains(q)) return false;
      if (room != null && v.room != room) return false;
      if (todayOnly) {
        final d = v.startTime;
        if (d.year != now.year || d.month != now.month || d.day != now.day) return false;
      }
      return true;
    }).toList();
    list.sort((a, b) => a.startTime.compareTo(b.startTime));
    return list;
  }

  VisitorLoadedState copyWith({
    List<VisitorModel>? all,
    VisitorStatus? tab,
    String? query,
    Object? room = _unset,
    bool? todayOnly,
  }) {
    return VisitorLoadedState(
      all: all ?? this.all,
      tab: tab ?? this.tab,
      query: query ?? this.query,
      room: identical(room, _unset) ? this.room : room as String?,
      todayOnly: todayOnly ?? this.todayOnly,
    );
  }
}
