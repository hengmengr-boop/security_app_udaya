import 'package:equatable/equatable.dart';
import 'package:udaya_visitor/data/models/visitor_model.dart';

abstract class VisitorActionState extends Equatable {
  const VisitorActionState();
  @override
  List<Object?> get props => [];
}

class VisitorActionInitial extends VisitorActionState {}

class VisitorActionLoading extends VisitorActionState {
  const VisitorActionLoading({this.activeVisitorId});
  final String? activeVisitorId;

  @override
  List<Object?> get props => [activeVisitorId];
}

class VisitorActionSuccess extends VisitorActionState {
  const VisitorActionSuccess({
    required this.message,
    this.visitor,
  });

  final String message;
  final VisitorModel? visitor;

  @override
  List<Object?> get props => [message, visitor];
}

class VisitorActionFailure extends VisitorActionState {
  const VisitorActionFailure({required this.error});
  final String error;
  @override
  List<Object?> get props => [error];
}
