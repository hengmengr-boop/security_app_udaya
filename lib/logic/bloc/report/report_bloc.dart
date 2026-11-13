import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udaya_visitor/data/repositories/visitor_repository.dart';
import 'package:udaya_visitor/logic/bloc/report/report_event.dart';
import 'package:udaya_visitor/logic/bloc/report/report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc({VisitorRepository? repository})
      : _repository = repository ?? VisitorRepository(),
        super(ReportInitial()) {
    on<GenerateReportEvent>(_onGenerate);
  }

  final VisitorRepository _repository;

  Future<void> _onGenerate(
      GenerateReportEvent event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      final items = await _repository.getReport(event.params);
      if (emit.isDone) return;
      emit(ReportSuccess(items));
    } catch (e) {
      emit(ReportFailure(e.toString()));
    }
  }
}
