import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udaya_visitor/data/repositories/visitor_repository.dart';
import 'package:udaya_visitor/logic/bloc/visitor_badge/visitor_badge_event.dart';
import 'package:udaya_visitor/logic/bloc/visitor_badge/visitor_badge_state.dart';

class VisitorBadgeBloc extends Bloc<VisitorBadgeEvent, VisitorBadgeState> {
  VisitorBadgeBloc({VisitorRepository? repository})
      : _repository = repository ?? VisitorRepository(),
        super(VisitorBadgeInitial()) {
    on<FetchVisitorBadgeEvent>(_onFetch);
  }

  final VisitorRepository _repository;

  Future<void> _onFetch(
    FetchVisitorBadgeEvent event,
    Emitter<VisitorBadgeState> emit,
  ) async {
    emit(VisitorBadgeLoading());
    try {
      final count = await _repository.countBadge(filter: event.filter);
      if (emit.isDone) return;
      emit(VisitorBadgeSuccess(count));
    } catch (e) {
      if (emit.isDone) return;
      emit(VisitorBadgeFailure(e.toString()));
    }
  }
}
