import 'package:equatable/equatable.dart';
import 'package:udaya_visitor/data/models/pin_verify_model.dart';
import 'package:udaya_visitor/data/models/public_check_in_model.dart';

abstract class PublicVisitorEvent extends Equatable {
  const PublicVisitorEvent();
  @override
  List<Object?> get props => [];
}

class VerifyPinEvent extends PublicVisitorEvent {
  const VerifyPinEvent(this.request);
  final PinVerifyRequest request;
  @override
  List<Object?> get props => [request];
}

class PublicCheckInEvent extends PublicVisitorEvent {
  const PublicCheckInEvent(this.request);
  final PublicCheckInRequest request;
  @override
  List<Object?> get props => [request];
}
