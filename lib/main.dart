import 'dart:io' show Platform;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udaya_visitor/data/data_export.dart';
import 'package:udaya_visitor/helper/helper_export.dart';
import 'package:udaya_visitor/helper/utils/router_utils.dart';
import 'package:udaya_visitor/logic/logic_export.dart';
import 'package:udaya_visitor/presentations/presentation_export.dart';
import 'package:device_preview_plus/device_preview_plus.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // * App Preference
  await AppPreference.ensureInitialized();

  // * Easy Localization
  await EasyLocalization.ensureInitialized();

  // * Theme
  ThemeUtils.instance.initTheme();

  // * Show Status Bar (phones only)
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
    );
  }

  // Safe redirect on 401 unauthorized
  ApiClient.shared.onUnauthorized = () {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router.go('/login');
    });
  };

  // * Run App
  runApp(
    DevicePreview(
      enabled: kIsWeb && kDebugMode,
      builder: (_) => EasyLocalization(
        path: Assets.translationPath,
        supportedLocales: LanguageManager.supportedLanguage,
        fallbackLocale: LanguageManager.defaultLanguage,
        child: const _AppProviders(),
      ),
    ),
  );
}

class _AppProviders extends StatelessWidget {
  const _AppProviders();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<VisitorRepository>(
      create: (_) => VisitorRepository(),
      child: MultiBlocProvider(
        providers: [
          // * Core & Base Blocs
          BlocProvider(create: (_) => AuthBloc()),
          BlocProvider(create: (_) => VisitorBloc()),
          BlocProvider(
            create: (ctx) =>
                VisitorListBloc(repository: ctx.read<VisitorRepository>()),
          ),
          BlocProvider(
            create: (ctx) =>
                VisitorBadgeBloc(repository: ctx.read<VisitorRepository>()),
          ),
          BlocProvider(
            create: (ctx) => QrBloc(repository: ctx.read<VisitorRepository>()),
          ),
          BlocProvider(
            create: (ctx) =>
                PublicVisitorBloc(repository: ctx.read<VisitorRepository>()),
          ),
          BlocProvider(
            create: (ctx) =>
                ReportBloc(repository: ctx.read<VisitorRepository>()),
          ),
          BlocProvider(
            create: (ctx) =>
                VisitorActionBloc(repository: ctx.read<VisitorRepository>()),
          ),
        ],
        child: ValueListenableBuilder<ThemeMode>(
          valueListenable: ThemeUtils.themeModeNotifier,
          builder: (context, mode, child) => ValueListenableBuilder<Color>(
            valueListenable: ThemeUtils.primaryColorNotifier,
            builder: (context, color, child) =>
                _MyApp(mode: mode, primaryColor: color),
          ),
        ),
      ),
    );
  }
}

class _MyApp extends StatelessWidget {
  final ThemeMode mode;
  final Color primaryColor;

  const _MyApp({required this.mode, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: tr(LocaleKeys.app_name),
      themeMode: mode,
      theme: AppTheme.lightTheme(primaryColor),
      darkTheme: AppTheme.darkTheme(primaryColor),
      routerConfig: router,
      locale: context.locale,
      builder: kIsWeb && kDebugMode
          ? DevicePreview.appBuilder
          : (context, child) => child ?? const SizedBox.shrink(),
      supportedLocales: context.supportedLocales,
      scaffoldMessengerKey: scaffoldMessengerKey,
      localizationsDelegates: context.localizationDelegates,
    );
  }
}
