import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udaya_visitor/data/repositories/visitor_repository.dart';
import 'package:udaya_visitor/logic/bloc/visitor_action/visitor_action_event.dart';
import 'package:udaya_visitor/logic/bloc/visitor_action/visitor_action_state.dart';
import 'package:udaya_visitor/logic/bloc/visitor_badge/visitor_badge_bloc.dart';
import 'package:udaya_visitor/logic/bloc/visitor_badge/visitor_badge_event.dart';
import 'package:udaya_visitor/logic/bloc/visitor_list/visitor_list_bloc.dart';
import 'package:udaya_visitor/logic/bloc/visitor_list/visitor_list_event.dart';

class VisitorActionBloc extends Bloc<VisitorActionEvent, VisitorActionState> {
  VisitorActionBloc({
    VisitorRepository? repository,
    VisitorListBloc? listBloc,
    VisitorBadgeBloc? badgeBloc,
  })  : _repository = repository ?? VisitorRepository(),
        _listBloc = listBloc,
        _badgeBloc = badgeBloc,
        super(VisitorActionInitial()) {
    on<AddVisitorActionEvent>(_onAdd);
    on<CheckInActionEvent>(_onCheckIn);
    on<CheckOutActionEvent>(_onCheckOut);
    on<LinkFacilityActionEvent>(_onLinkFacility);
  }

  final VisitorRepository _repository;
  final VisitorListBloc? _listBloc;
  final VisitorBadgeBloc? _badgeBloc;

  void _refresh() {
    _listBloc?.add(const RefreshVisitorListEvent());
    _badgeBloc?.add(const FetchVisitorBadgeEvent());
  }

  Future<void> _onAdd(
      AddVisitorActionEvent event, Emitter<VisitorActionState> emit) async {
    if (state is VisitorActionLoading) return;
    emit(VisitorActionLoading(activeVisitorId: event.visitor.id));
    try {
      final visitor = await _repository.addVisitor(event.visitor);
      if (emit.isDone) return;
      _refresh();
      emit(VisitorActionSuccess(
        message: 'Visitor ${visitor.name} added successfully',
        visitor: visitor,
      ));
    } catch (e) {
      emit(VisitorActionFailure(error: e.toString()));
    }
  }

  Future<void> _onCheckIn(
      CheckInActionEvent event, Emitter<VisitorActionState> emit) async {
    if (state is VisitorActionLoading) return;
    emit(VisitorActionLoading(activeVisitorId: event.id));
    try {
      final visitor = await _repository.checkIn(event.id);
      if (emit.isDone) return;
      _refresh();
      emit(VisitorActionSuccess(
        message: '${visitor.name} checked in',
        visitor: visitor,
      ));
    } catch (e) {
      emit(VisitorActionFailure(error: e.toString()));
    }
  }

  Future<void> _onCheckOut(
      CheckOutActionEvent event, Emitter<VisitorActionState> emit) async {
    if (state is VisitorActionLoading) return;
    emit(VisitorActionLoading(activeVisitorId: event.id));
    try {
      final visitor = await _repository.checkOut(event.id);
      if (emit.isDone) return;
      _refresh();
      emit(VisitorActionSuccess(
        message: '${visitor.name} checked out',
        visitor: visitor,
      ));
    } catch (e) {
      emit(VisitorActionFailure(error: e.toString()));
    }
  }

  Future<void> _onLinkFacility(
      LinkFacilityActionEvent event, Emitter<VisitorActionState> emit) async {
    if (state is VisitorActionLoading) return;
    emit(VisitorActionLoading(
        activeVisitorId: event.request.visitorId.toString()));
    try {
      await _repository.linkFacility(event.request);
      if (emit.isDone) return;
      _refresh();
      emit(const VisitorActionSuccess(message: 'Facility linked successfully'));
    } catch (e) {
      emit(VisitorActionFailure(error: e.toString()));
    }
  }
}
