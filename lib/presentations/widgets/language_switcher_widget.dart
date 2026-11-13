import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:udaya_visitor/helper/helper_export.dart';
import 'package:udaya_visitor/presentations/presentation_export.dart';

/// English / Khmer flag buttons. The choice is persisted by easy_localization.
final class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key, this.height = 56, this.expand = false});

  final double height;

  /// `true`: the two buttons share all available width (sidebar).
  /// `false`: compact buttons sized from [height] (headers).
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final isEnglish = context.locale.languageCode ==
        LanguageManager.defaultLanguage.languageCode;

    Widget button(FlagType type, Locale locale, bool selected) {
      final flag = _FlagButton(
        type: type,
        selected: selected,
        height: height,
        onTap: () => context.setLocale(locale),
      );
      return expand
          ? Expanded(child: flag)
          : SizedBox(width: height * 1.4, child: flag);
    }

    return Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      children: [
        button(FlagType.uk, LanguageManager.defaultLanguage, isEnglish),
        SizedBox(width: expand ? 14 : 8),
        button(FlagType.cambodia, LanguageManager.khmerLanguage, !isEnglish),
      ],
    );
  }
}

final class _FlagButton extends StatelessWidget {
  const _FlagButton(
      {required this.type,
      required this.selected,
      required this.height,
      required this.onTap});

  final FlagType type;
  final bool selected;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.periwinkle : const Color(0xFFF8F9FC),
      elevation: selected ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
            color: selected ? AppColors.periwinkle : AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
            height: height,
            child: Center(child: FlagIcon(type: type, size: height * 0.6))),
      ),
    );
  }
}
