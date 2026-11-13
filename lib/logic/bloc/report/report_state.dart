import 'package:equatable/equatable.dart';
import 'package:udaya_visitor/data/models/report_item_model.dart';

abstract class ReportState extends Equatable {
  const ReportState();
  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportSuccess extends ReportState {
  const ReportSuccess(this.items);
  final List<ReportItemModel> items;
  @override
  List<Object?> get props => [items];
}

class ReportFailure extends ReportState {
  const ReportFailure(this.error);
  final String error;
  @override
  List<Object?> get props => [error];
}
