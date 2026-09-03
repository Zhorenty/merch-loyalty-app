import 'package:flutter/material.dart';
import 'package:merch/src/core/constant/localization/localization.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/feature/auth/widget/auth_scope.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _loginController = TextEditingController();
  final _secretController = TextEditingController();
  final _loginFocus = FocusNode();
  final _secretFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _loginController.dispose();
    _secretController.dispose();
    _loginFocus.dispose();
    _secretFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 32),
                Image.asset(
                  'assets/images/merch-logo.png',
                  height: 160,
                  fit: BoxFit.contain,
                ),
                const Spacer(),
                TextField(
                  controller: _loginController,
                  focusNode: _loginFocus,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  autofillHints: const [AutofillHints.username],
                  decoration: InputDecoration(hintText: l10n.loginHint),
                  onSubmitted: (_) => _secretFocus.requestFocus(),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _secretController,
                  focusNode: _secretFocus,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  decoration: InputDecoration(
                    hintText: l10n.passwordOrPinHint,
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => _submit(),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _error!,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.error,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                ElevatedButton(
                  onPressed: auth.isProcessing ? null : _submit,
                  child: auth.isProcessing
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.signIn),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final login = _loginController.text.trim();
    final secret = _secretController.text;
    if (login.isEmpty || secret.isEmpty) {
      setState(() => _error = context.l10n.enterLoginAndPassword);
      return;
    }
    setState(() => _error = null);
    AuthScope.of(context).signIn(
      login: login,
      secret: secret,
      onError: (error) {
        if (mounted) setState(() => _error = context.errorMessage(error));
      },
    );
  }
}
