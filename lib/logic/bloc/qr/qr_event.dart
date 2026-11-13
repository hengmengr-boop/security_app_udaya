import 'package:equatable/equatable.dart';

abstract class QrEvent extends Equatable {
  const QrEvent();
  @override
  List<Object?> get props => [];
}

class FetchQrCodeEvent extends QrEvent {
  const FetchQrCodeEvent(this.visitorId);
  final String visitorId;
  @override
  List<Object?> get props => [visitorId];
}
