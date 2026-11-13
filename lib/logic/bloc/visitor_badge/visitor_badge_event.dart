import 'package:equatable/equatable.dart';

abstract class VisitorBadgeEvent extends Equatable {
  const VisitorBadgeEvent();
  @override
  List<Object?> get props => [];
}

class FetchVisitorBadgeEvent extends VisitorBadgeEvent {
  const FetchVisitorBadgeEvent({this.filter});
  final Map<String, dynamic>? filter;
  @override
  List<Object?> get props => [filter];
}
