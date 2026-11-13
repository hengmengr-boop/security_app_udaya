import 'package:equatable/equatable.dart';
import 'package:udaya_visitor/data/models/qr_response_model.dart';

abstract class QrState extends Equatable {
  const QrState();
  @override
  List<Object?> get props => [];
}

class QrInitial extends QrState {}

class QrLoading extends QrState {}

class QrSuccess extends QrState {
  const QrSuccess(this.qrData);
  final QrResponseModel qrData;
  @override
  List<Object?> get props => [qrData];
}

class QrFailure extends QrState {
  const QrFailure(this.error);
  final String error;
  @override
  List<Object?> get props => [error];
}
