import 'package:udaya_visitor/helper/helper_export.dart';
import 'package:udaya_visitor/presentations/presentation_export.dart';
import 'package:flutter/material.dart';

final class ProgressDialog with ModalUtilsMixin {
  // * Variable
  var _isShowing = false;

  // * Show
  Future<T?> show<T>({BuildContext? context}) {
    // * Set [isShowing] True
    _isShowing = true;
    // * Build
    return showDialog<T>(
      context: context ?? globalContext,
      barrierDismissible: true,
      builder: (_) => const _ProgressDialog(),
    ).then((result) {
      // * Set [isShowing] False
      _isShowing = false;
      // * Return Result
      return result;
    });
  }

  // * Get Dialog Showing
  bool get isShowing => _isShowing;
}

final class _ProgressDialog extends StatelessWidget {
  const _ProgressDialog();

  @override
  Widget build(BuildContext context) =>
      const PopScope(canPop: true, child: ProgressBar());
}
