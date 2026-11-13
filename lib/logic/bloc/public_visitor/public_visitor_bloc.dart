import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udaya_visitor/data/repositories/visitor_repository.dart';
import 'package:udaya_visitor/logic/bloc/public_visitor/public_visitor_event.dart';
import 'package:udaya_visitor/logic/bloc/public_visitor/public_visitor_state.dart';

class PublicVisitorBloc extends Bloc<PublicVisitorEvent, PublicVisitorState> {
  PublicVisitorBloc({VisitorRepository? repository})
      : _repository = repository ?? VisitorRepository(),
        super(PublicVisitorInitial()) {
    on<VerifyPinEvent>(_onVerifyPin);
    on<PublicCheckInEvent>(_onPublicCheckIn);
  }

  final VisitorRepository _repository;

  Future<void> _onVerifyPin(
      VerifyPinEvent event, Emitter<PublicVisitorState> emit) async {
    emit(PublicVisitorLoading());
    try {
      final res = await _repository.publicVerifyPin(event.request);
      if (emit.isDone) return;
      emit(PinVerifySuccessState(res));
    } catch (e) {
      emit(PublicVisitorFailure(e.toString()));
    }
  }

  Future<void> _onPublicCheckIn(
      PublicCheckInEvent event, Emitter<PublicVisitorState> emit) async {
    emit(PublicVisitorLoading());
    try {
      final visitor = await _repository.publicCheckIn(event.request);
      if (emit.isDone) return;
      emit(PublicCheckInSuccessState(visitor));
    } catch (e) {
      emit(PublicVisitorFailure(e.toString()));
    }
  }
}
