import 'package:equatable/equatable.dart';
import 'package:udaya_visitor/data/models/badge_count_model.dart';

abstract class VisitorBadgeState extends Equatable {
  const VisitorBadgeState();
  @override
  List<Object?> get props => [];
}

class VisitorBadgeInitial extends VisitorBadgeState {}

class VisitorBadgeLoading extends VisitorBadgeState {}

class VisitorBadgeSuccess extends VisitorBadgeState {
  const VisitorBadgeSuccess(this.badgeCount);
  final BadgeCountModel badgeCount;
  @override
  List<Object?> get props => [badgeCount];
}

class VisitorBadgeFailure extends VisitorBadgeState {
  const VisitorBadgeFailure(this.error);
  final String error;
  @override
  List<Object?> get props => [error];
}
