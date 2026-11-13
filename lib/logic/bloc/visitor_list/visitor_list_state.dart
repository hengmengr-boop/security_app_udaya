import 'package:equatable/equatable.dart';
import 'package:udaya_visitor/data/models/visitor_list_filter_request.dart';
import 'package:udaya_visitor/data/models/visitor_model.dart';

abstract class VisitorListState extends Equatable {
  const VisitorListState();
  @override
  List<Object?> get props => [];
}

class VisitorListInitial extends VisitorListState {}

class VisitorListLoading extends VisitorListState {}

class VisitorListSuccess extends VisitorListState {
  const VisitorListSuccess({
    required this.visitors,
    required this.filter,
    this.hasMore = false,
  });

  final List<VisitorModel> visitors;
  final VisitorListFilterRequest filter;
  final bool hasMore;

  @override
  List<Object?> get props => [visitors, filter, hasMore];
}

class VisitorListFailure extends VisitorListState {
  const VisitorListFailure({required this.error});
  final String error;
  @override
  List<Object?> get props => [error];
}
