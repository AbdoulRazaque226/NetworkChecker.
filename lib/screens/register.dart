import 'package:flutter/material.dart';

import '../gen_l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../widgets/circuit_background.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.authProvider,
    required this.languageProvider,
  });

  final AuthProvider authProvider;
  final LanguageProvider languageProvider;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _localizeError(AppLocalizations l10n, String key) {
    return switch (key) {
      'register_invalidEmail' => l10n.register_invalidEmail,
      'register_weakPassword' => l10n.register_weakPassword,
      'register_accountExists' => l10n.register_accountExists,
      _ => l10n.login_genericError,
    };
  }

  Future<void> _submit() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    final String confirm = _confirmController.text;
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showSnack(l10n.common_fillAllFields);
      return;
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      _showSnack(l10n.register_invalidEmail);
      return;
    }
    if (password.length < 6) {
      _showSnack(l10n.register_weakPassword);
      return;
    }
    if (password != confirm) {
      _showSnack(l10n.register_passwordsMismatch);
      return;
    }

    await widget.authProvider.signUpWithEmail(email, password);
    if (!mounted) return;

    if (widget.authProvider.error == null) {
      _showSnack(l10n.register_success);
      // Auth state changed: pop back — the home route now shows HomeScreen.
      Navigator.of(context).pop();
    } else {
      final String? message =
          _localizeError(l10n, widget.authProvider.error!);
      _showSnack(message ?? l10n.login_genericError);
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: CircuitBackground()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: l10n.common_back,
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.register_title,
                        style: theme.textTheme.displaySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.register_subtitle,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: l10n.common_email,
                          prefixIcon: const Icon(Icons.mail_outline_rounded),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: l10n.common_password,
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _confirmController,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                        decoration: InputDecoration(
                          labelText: l10n.register_confirmPassword,
                          prefixIcon: const Icon(Icons.lock_reset_rounded),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ListenableBuilder(
                        listenable: widget.authProvider,
                        builder: (context, _) {
                          final bool loading = widget.authProvider.isLoading;
                          return ElevatedButton(
                            onPressed: loading ? null : _submit,
                            child: loading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(l10n.register_registerButton),
                          );
                        },
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.register_hasAccount,
                            style: theme.textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(l10n.register_signIn),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}