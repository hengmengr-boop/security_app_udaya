import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udaya_visitor/data/repositories/visitor_repository.dart';
import 'package:udaya_visitor/logic/bloc/qr/qr_event.dart';
import 'package:udaya_visitor/logic/bloc/qr/qr_state.dart';

class QrBloc extends Bloc<QrEvent, QrState> {
  QrBloc({VisitorRepository? repository})
      : _repository = repository ?? VisitorRepository(),
        super(QrInitial()) {
    on<FetchQrCodeEvent>(_onFetch);
  }

  final VisitorRepository _repository;

  Future<void> _onFetch(FetchQrCodeEvent event, Emitter<QrState> emit) async {
    emit(QrLoading());
    try {
      final qr = await _repository.getQrCode(event.visitorId);
      if (emit.isDone) return;
      emit(QrSuccess(qr));
    } catch (e) {
      emit(QrFailure(e.toString()));
    }
  }
}
