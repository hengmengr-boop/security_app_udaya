import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udaya_visitor/data/models/visitor_list_filter_request.dart';
import 'package:udaya_visitor/data/repositories/visitor_repository.dart';
import 'package:udaya_visitor/logic/bloc/visitor_list/visitor_list_event.dart';
import 'package:udaya_visitor/logic/bloc/visitor_list/visitor_list_state.dart';

class VisitorListBloc extends Bloc<VisitorListEvent, VisitorListState> {
  VisitorListBloc({VisitorRepository? repository})
      : _repository = repository ?? VisitorRepository(),
        super(VisitorListInitial()) {
    on<FetchVisitorListEvent>(_onFetch);
    on<RefreshVisitorListEvent>(_onRefresh);
    on<FilterVisitorListEvent>(_onFilter);
    on<LoadNextPageEvent>(_onLoadNextPage);
  }

  final VisitorRepository _repository;

  Future<void> _onFetch(
      FetchVisitorListEvent event, Emitter<VisitorListState> emit) async {
    emit(VisitorListLoading());
    try {
      final visitors = await _repository.getVisitors(event.filter);
      if (emit.isDone) return;
      emit(VisitorListSuccess(
        visitors: visitors,
        filter: event.filter,
        hasMore: visitors.length >= event.filter.limit,
      ));
    } catch (e) {
      emit(VisitorListFailure(error: e.toString()));
    }
  }

  Future<void> _onRefresh(
      RefreshVisitorListEvent event, Emitter<VisitorListState> emit) async {
    final currentFilter = state is VisitorListSuccess
        ? (state as VisitorListSuccess).filter
        : const VisitorListFilterRequest();
    try {
      final visitors = await _repository.getVisitors(currentFilter);
      if (emit.isDone) return;
      emit(VisitorListSuccess(
        visitors: visitors,
        filter: currentFilter,
        hasMore: visitors.length >= currentFilter.limit,
      ));
    } catch (e) {
      emit(VisitorListFailure(error: e.toString()));
    }
  }

  Future<void> _onFilter(
      FilterVisitorListEvent event, Emitter<VisitorListState> emit) async {
    add(FetchVisitorListEvent(filter: event.filter));
  }

  Future<void> _onLoadNextPage(
      LoadNextPageEvent event, Emitter<VisitorListState> emit) async {
    if (state is! VisitorListSuccess) return;
    final currentState = state as VisitorListSuccess;
    if (!currentState.hasMore) return;

    final nextFilter = currentState.filter.copyWith(
      page: currentState.filter.page + 1,
    );

    try {
      final newVisitors = await _repository.getVisitors(nextFilter);
      if (emit.isDone) return;
      final combined = [...currentState.visitors, ...newVisitors];
      emit(VisitorListSuccess(
        visitors: combined,
        filter: nextFilter,
        hasMore: newVisitors.length >= nextFilter.limit,
      ));
    } catch (_) {
      // Keep existing list on failure to avoid clearing UI
    }
  }
}
