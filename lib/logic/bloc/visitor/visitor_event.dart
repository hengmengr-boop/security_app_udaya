part of 'visitor_bloc.dart';

sealed class VisitorEvent {}

final class LoadVisitorsEvent extends VisitorEvent {}

final class SearchVisitorEvent extends VisitorEvent {
  final String query;

  SearchVisitorEvent({required this.query});
}

final class ChangeTabEvent extends VisitorEvent {
  final VisitorStatus tab;

  ChangeTabEvent({required this.tab});
}

final class ApplyFilterEvent extends VisitorEvent {
  final String? room;
  final bool todayOnly;

  ApplyFilterEvent({this.room, this.todayOnly = false});
}

final class CheckInEvent extends VisitorEvent {
  final String id;

  CheckInEvent({required this.id});
}

final class CheckOutEvent extends VisitorEvent {
  final String id;

  CheckOutEvent({required this.id});
}
