import 'package:equatable/equatable.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();
  @override
  List<Object?> get props => [];
}

class GenerateReportEvent extends ReportEvent {
  const GenerateReportEvent({this.params = const {}});
  final Map<String, dynamic> params;
  @override
  List<Object?> get props => [params];
}
