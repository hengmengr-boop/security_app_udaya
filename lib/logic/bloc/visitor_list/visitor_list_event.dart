import 'package:equatable/equatable.dart';
import 'package:udaya_visitor/data/models/visitor_list_filter_request.dart';

abstract class VisitorListEvent extends Equatable {
  const VisitorListEvent();
  @override
  List<Object?> get props => [];
}

class FetchVisitorListEvent extends VisitorListEvent {
  const FetchVisitorListEvent({this.filter = const VisitorListFilterRequest()});
  final VisitorListFilterRequest filter;
  @override
  List<Object?> get props => [filter];
}

class RefreshVisitorListEvent extends VisitorListEvent {
  const RefreshVisitorListEvent();
}

class FilterVisitorListEvent extends VisitorListEvent {
  const FilterVisitorListEvent({required this.filter});
  final VisitorListFilterRequest filter;
  @override
  List<Object?> get props => [filter];
}

class LoadNextPageEvent extends VisitorListEvent {
  const LoadNextPageEvent();
}
