import 'package:udaya_visitor/helper/helper_export.dart';
import 'package:udaya_visitor/presentations/presentation_export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' as gr hide GoRouterHelper;

// * Navigator Key
final navigatorKey = GlobalKey<NavigatorState>();

// * Global Context
BuildContext get globalContext => navigatorKey.currentState!.context;

// * Navigator Utils
extension NavigatorUtils on BuildContext {
  Future<T?> push<T>({
    BuildContext? context,
    required Widget destination,
    bool checkSignIn = false,
    bool rootNavigator = true,
    bool popUp = false,
  }) {
    final ctx = context ?? this;
    // * If Not Signed In
    if (checkSignIn && !isSignedIn) {
      destination = const LoginPage();
    }

    final path = _getRoutePath(destination);
    if (path != null) {
      gr.GoRouter.of(ctx).push(path);
      return Future.value(null);
    }

    return Navigator.of(ctx, rootNavigator: rootNavigator).push<T>(
      popUp ? CupertinoModalPopupRoute<T>(builder: (_) => destination) : CupertinoPageRoute<T>(builder: (_) => destination),
    );
  }

  Future<void> pushReplaceTo<T>({
    BuildContext? context,
    required Widget destination,
    bool rootNavigator = true,
    bool checkSignIn = false,
    bool popUp = false,
  }) {
    final ctx = context ?? this;
    // * If Not Signed In
    if (checkSignIn && !isSignedIn) {
      destination = const LoginPage();
    }

    final path = _getRoutePath(destination);
    if (path != null) {
      gr.GoRouter.of(ctx).pushReplacement(path);
      return Future.value(null);
    }

    return Navigator.of(ctx, rootNavigator: rootNavigator).pushReplacement(
      popUp ? CupertinoModalPopupRoute<T>(builder: (_) => destination) : CupertinoPageRoute<T>(builder: (_) => destination),
    );
  }

  Future<void> go({BuildContext? context, required Widget destination, bool rootNavigator = false}) {
    final ctx = context ?? this;
    final path = _getRoutePath(destination);
    if (path != null) {
      gr.GoRouter.of(ctx).go(path);
      return Future.value(null);
    }
    return Navigator.of(
      ctx,
      rootNavigator: rootNavigator,
    ).pushAndRemoveUntil(CupertinoPageRoute(builder: (_) => destination), (route) => false);
  }

  bool canPop({BuildContext? context, bool rootNavigator = false}) {
    final ctx = context ?? this;
    return gr.GoRouter.of(ctx).canPop();
  }

  void pop({BuildContext? context, dynamic result}) {
    final ctx = context ?? this;
    if (gr.GoRouter.of(ctx).canPop()) {
      gr.GoRouter.of(ctx).pop(result);
    }
    return;
  }

  bool isCurrentStateShowing({BuildContext? context}) {
    return ModalRoute.of(context ?? this)!.isCurrent;
  }

  Future<bool?> confirm({
    String title = 'Confirm',
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(cancelText)),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: isDestructive ? Colors.red : null),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}

String? _getRoutePath(Widget destination) {
  if (destination is LoginPage) return '/login';
  if (destination is VisitorPage) return '/visitors';
  return null;
}

// * Modal Utils
mixin ModalUtilsMixin {
  void dismiss({BuildContext? context, dynamic result}) {
    if (context != null) {
      Navigator.of(context).pop(result);
    } else {
      navigatorKey.currentState?.pop(result);
    }
  }
}
