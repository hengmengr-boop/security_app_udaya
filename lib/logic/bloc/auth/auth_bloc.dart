import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udaya_visitor/data/data_export.dart';

part 'auth_event.dart';

part 'auth_state.dart';

/// Owns sign-in / sign-out. Pages react through [BlocConsumer] listeners.
final class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({AuthRepo? repo}) : _repo = repo ?? AuthRepo(), super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
  }

  final AuthRepo _repo;

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final ok = await _repo.login(username: event.username, password: event.password);
    emit(ok ? AuthAuthenticated() : AuthFailure());
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await _repo.logout();
    emit(AuthLoggedOut());
  }
}
