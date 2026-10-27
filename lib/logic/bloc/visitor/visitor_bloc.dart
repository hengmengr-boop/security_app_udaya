import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udaya_visitor/data/data_export.dart';

part 'visitor_event.dart';

part 'visitor_state.dart';

/// Owns the visitor list: loading, tab, search, filter, check-in / check-out.
final class VisitorBloc extends Bloc<VisitorEvent, VisitorState> {
  VisitorBloc({VisitorRepo? repo}) : _repo = repo ?? VisitorRepo(), super(VisitorInitial()) {
    on<LoadVisitorsEvent>(_onLoad);
    on<SearchVisitorEvent>(_onSearch);
    on<ChangeTabEvent>(_onChangeTab);
    on<ApplyFilterEvent>(_onApplyFilter);
    on<CheckInEvent>(_onCheckIn);
    on<CheckOutEvent>(_onCheckOut);
  }

  final VisitorRepo _repo;

  Future<void> _onLoad(LoadVisitorsEvent event, Emitter<VisitorState> emit) async {
    final current = state;
    if (current is VisitorLoadedState) {
      emit(current.copyWith(all: _repo.getVisitors()));
    } else {
      emit(VisitorLoadedState(all: _repo.getVisitors()));
    }
  }

  void _onSearch(SearchVisitorEvent event, Emitter<VisitorState> emit) {
    final current = state;
    if (current is VisitorLoadedState) emit(current.copyWith(query: event.query));
  }

  void _onChangeTab(ChangeTabEvent event, Emitter<VisitorState> emit) {
    final current = state;
    if (current is VisitorLoadedState) emit(current.copyWith(tab: event.tab));
  }

  void _onApplyFilter(ApplyFilterEvent event, Emitter<VisitorState> emit) {
    final current = state;
    if (current is VisitorLoadedState) emit(current.copyWith(room: event.room, todayOnly: event.todayOnly));
  }

  Future<void> _onCheckIn(CheckInEvent event, Emitter<VisitorState> emit) async {
    final current = state;
    if (current is! VisitorLoadedState) return;
    emit(current.copyWith(all: await _repo.checkIn(event.id)));
  }

  Future<void> _onCheckOut(CheckOutEvent event, Emitter<VisitorState> emit) async {
    final current = state;
    if (current is! VisitorLoadedState) return;
    emit(current.copyWith(all: await _repo.checkOut(event.id)));
  }
}
