import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:udaya_visitor/helper/helper_export.dart';

/// Labelled input used on the login page. [isPassword] adds a show/hide toggle.
final class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.enabled = true,
  });

  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

final class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure = widget.isPassword;

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: CustomTextStyle.bodyTextStyle(color: AppColors.textSub)),
        const SizedBox(height: Dimen.smallSpace),
        TextField(
          controller: widget.controller,
          enabled: widget.enabled,
          obscureText: _obscure,
          textInputAction: widget.textInputAction,
          onSubmitted: widget.onSubmitted,
          autocorrect: false,
          enableSuggestions: !widget.isPassword,
          style: const TextStyle(fontSize: 17, color: AppColors.textBody),
          decoration: InputDecoration(
            hintText: tr(LocaleKeys.enter),
            hintStyle: const TextStyle(color: Color(0xFFB0B3C6)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            border: _border(AppColors.border),
            enabledBorder: _border(AppColors.border),
            focusedBorder: _border(AppColors.primary),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    color: AppColors.textMuted,
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
