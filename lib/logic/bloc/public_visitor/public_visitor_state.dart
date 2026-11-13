import 'package:equatable/equatable.dart';
import 'package:udaya_visitor/data/models/pin_verify_model.dart';
import 'package:udaya_visitor/data/models/visitor_model.dart';

abstract class PublicVisitorState extends Equatable {
  const PublicVisitorState();
  @override
  List<Object?> get props => [];
}

class PublicVisitorInitial extends PublicVisitorState {}

class PublicVisitorLoading extends PublicVisitorState {}

class PinVerifySuccessState extends PublicVisitorState {
  const PinVerifySuccessState(this.response);
  final PinVerifyResponse response;
  @override
  List<Object?> get props => [response];
}

class PublicCheckInSuccessState extends PublicVisitorState {
  const PublicCheckInSuccessState(this.visitor);
  final VisitorModel visitor;
  @override
  List<Object?> get props => [visitor];
}

class PublicVisitorFailure extends PublicVisitorState {
  const PublicVisitorFailure(this.error);
  final String error;
  @override
  List<Object?> get props => [error];
}
