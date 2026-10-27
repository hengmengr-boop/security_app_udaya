import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udaya_visitor/helper/helper_export.dart';
import 'package:udaya_visitor/logic/logic_export.dart';
import 'package:udaya_visitor/presentations/presentation_export.dart';

final class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<AuthBloc>().add(LoginEvent(username: _usernameController.text, password: _passwordController.text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(destination: const VisitorPage());
        } else if (state is AuthFailure) {
          context.showSuccessSnackBar(msg: tr(LocaleKeys.login_failed), isError: true);
        }
      },
      builder: (context, state) {
        final loading = state is AuthLoading;
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(gradient: kBrandGradient),
            child: SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const UdayaLogo(width: 210),
                            const SizedBox(height: 36),
                            _buildCard(loading),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Positioned(top: 12, right: 12, child: LanguageSwitcher(height: 40)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(bool loading) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 34, 30, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 24, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            tr(LocaleKeys.welcome),
            textAlign: TextAlign.center,
            style: CustomTextStyle.largeTitleTextStyle(color: Colors.black, fontSize: 26),
          ),
          const SizedBox(height: Dimen.smallSpace),
          Text(
            tr(LocaleKeys.login_subtitle),
            textAlign: TextAlign.center,
            style: CustomTextStyle.bodyTextStyle(color: const Color(0xFF9A9CB5), fontSize: 17),
          ),
          const SizedBox(height: 26),
          AppTextField(label: tr(LocaleKeys.username), controller: _usernameController, enabled: !loading),
          const SizedBox(height: Dimen.defaultSpace),
          AppTextField(
            label: tr(LocaleKeys.password),
            controller: _passwordController,
            isPassword: true,
            enabled: !loading,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 56,
            child: FilledButton(
              onPressed: loading ? null : _submit,
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                    )
                  : Text(tr(LocaleKeys.login), style: CustomTextStyle.buttonTextStyle(fontSize: 19, bold: false)),
            ),
          ),
          const SizedBox(height: Dimen.defaultSpace),
          Text(
            tr(LocaleKeys.login_demo_hint, namedArgs: {'username': C.demoUsername, 'password': C.demoPassword}),
            textAlign: TextAlign.center,
            style: CustomTextStyle.captionTextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
