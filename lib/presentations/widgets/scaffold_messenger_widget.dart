import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:udaya_visitor/helper/helper_export.dart';

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
          // * Lottie icon container
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF2F3FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Lottie.asset(
              isError ? Assets.lottieInfo : Assets.lottieSuccess,
              width: 45,
              height: 45,
              repeat: false,
            ),
          ),
          // * Message text
          Flexible(child: Text(msg, textAlign: TextAlign.start)),
        ],
      ),
    );
    scaffoldMessengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
