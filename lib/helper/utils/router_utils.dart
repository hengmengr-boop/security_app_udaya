import 'package:go_router/go_router.dart';
import 'package:udaya_visitor/helper/helper_export.dart';
import 'package:udaya_visitor/presentations/presentation_export.dart';

/// Auth guard: signed-out users always land on /login, signed-in users skip it.
final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/',
  redirect: (context, state) {
    final token = AppPreference.getAccessToken;
    final signedIn = token != null && token.isNotEmpty;
    final atLogin = state.matchedLocation == '/login';

    if (!signedIn) return atLogin ? null : '/login';
    if (atLogin || state.matchedLocation == '/') return '/visitors';
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const ProgressBar()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
        path: '/visitors', builder: (context, state) => const VisitorPage()),
  ],
);
