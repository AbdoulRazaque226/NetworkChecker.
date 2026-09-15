import 'package:flutter/material.dart';

import '../gen_l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../widgets/circuit_background.dart';
import '../widgets/language_toggle.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.authProvider,
    required this.languageProvider,
  });

  final AuthProvider authProvider;
  final LanguageProvider languageProvider;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _localizeError(AppLocalizations l10n, String key) {
    return switch (key) {
      'login_invalidCredentials' => l10n.login_invalidCredentials,
      'register_invalidEmail' => l10n.register_invalidEmail,
      'register_accountExists' => l10n.register_accountExists,
      _ => l10n.login_genericError,
    };
  }

  Future<void> _submit() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    if (email.isEmpty || password.isEmpty) {
      _showSnack(l10n.common_fillAllFields);
      return;
    }

    await widget.authProvider.signInWithEmail(email, password);
    // On success the auth state changes and AppStartup routes to HomeScreen;
    // on failure the error key is surfaced below.
    if (widget.authProvider.error != null && mounted) {
      final String? message = _localizeError(l10n, widget.authProvider.error!);
      _showSnack(message ?? l10n.login_genericError);
    }
  }

  void _showSnack(String message) {
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: LanguageToggle(
                          languageProvider: widget.languageProvider,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.primary.withValues(alpha: 0.14),
                            border: Border.all(
                              color: theme.colorScheme.primary.withValues(alpha: 0.4),
                              width: 1.4,
                            ),
                          ),
                          child: Icon(
                            Icons.wifi_rounded,
                            size: 40,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.login_title,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displaySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.login_subtitle,
                        textAlign: TextAlign.center,
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
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                        decoration: InputDecoration(
                          labelText: l10n.common_password,
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
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
                                : Text(l10n.login_loginButton),
                          );
                        },
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              l10n.login_noAccount,
                              style: theme.textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => RegisterScreen(
                                      authProvider: widget.authProvider,
                                      languageProvider: widget.languageProvider,
                                    ),
                                  ),
                                );
                              },
                              child: Text(l10n.login_createAccount),
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