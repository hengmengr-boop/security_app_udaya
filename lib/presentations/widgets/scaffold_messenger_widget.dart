import 'package:flutter/material.dart';
import 'package:udaya_visitor/helper/helper_export.dart';
import 'package:lottie/lottie.dart';

// * Scaffold Messenger Key
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

// * Scaffold Messenger Extension
extension ScaffoldMessengerExtension on BuildContext {
  void showSuccessSnackBar({required String msg, bool isError = false}) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.all(Dimen.contentPadding),
      content: Row(
        spacing: Dimen.smallSpace,
        children: [
          // * Lottie
          Container(
            decoration: BoxDecoration(color: const Color(0xFFF2F3FF), borderRadius: BorderRadius.circular(20)),
            child: Lottie.asset(isError ? Assets.lottieInfo : Assets.lottieSuccess, width: 45, height: 45, repeat: false),
          ),
          // * Message
          Flexible(child: Text(msg, textAlign: TextAlign.start)),
        ],
      ),
    );
    scaffoldMessengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  // * You Add Any Overlay Widget Here
  // ? [Toast Message]
  Future<void> toast(
    ToastStatus? status, {
    String? title,
    required String msg,
    bool barrierDismissible = true,
    Duration duration = const Duration(seconds: 3),
  }) async {
    // TODO
  }

  // ? [Image Viewer]
  Future<void> imageViewer({
    required List<String> urls,
    int initialIndex = 0,
    bool canSave = true,
    bool isPhotoPath = false,
  }) async {
    // TODO
  }
}
