import 'package:equatable/equatable.dart';
import 'package:udaya_visitor/data/models/link_facility_model.dart';
import 'package:udaya_visitor/data/models/visitor_model.dart';

abstract class VisitorActionEvent extends Equatable {
  const VisitorActionEvent();
  @override
  List<Object?> get props => [];
}

class AddVisitorActionEvent extends VisitorActionEvent {
  const AddVisitorActionEvent(this.visitor);
  final VisitorModel visitor;
  @override
  List<Object?> get props => [visitor];
}

class CheckInActionEvent extends VisitorActionEvent {
  const CheckInActionEvent(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}

class CheckOutActionEvent extends VisitorActionEvent {
  const CheckOutActionEvent(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}

class LinkFacilityActionEvent extends VisitorActionEvent {
  const LinkFacilityActionEvent(this.request);
  final LinkFacilityRequest request;
  @override
  List<Object?> get props => [request];
}
