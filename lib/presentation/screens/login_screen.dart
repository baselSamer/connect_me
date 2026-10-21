import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_cubit.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_layout.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<AuthCubit>().state is AuthLoading;
    final state = context.watch<AuthCubit>().state;
    return AuthLayout(
      title: 'Welcome back',
      subtitle: 'Share moments with your community.',
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Sign in',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppPalette.ink,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your details to continue.',
              style: TextStyle(color: AppPalette.muted),
            ),
            const SizedBox(height: 26),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email address',
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
              validator: (value) => value == null || !value.contains('@')
                  ? 'Enter a valid email'
                  : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
                prefixIcon: Icon(Icons.lock_outline_rounded),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Enter your password' : null,
            ),
            if (state is AuthUnauthenticated && state.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  state.error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            const SizedBox(height: 30),
            FilledButton(
              onPressed: loading
                  ? null
                  : () {
                      if (_form.currentState!.validate()) {
                        context.read<AuthCubit>().signIn(
                          _email.text.trim(),
                          _password.text,
                        );
                      }
                    },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(loading ? 'Signing in…' : 'Sign in'),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: loading
                  ? null
                  : () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const SignUpScreen(),
                      ),
                    ),
              child: const Text('New here? Create an account'),
            ),
          ],
        ),
      ),
    );
  }
}
