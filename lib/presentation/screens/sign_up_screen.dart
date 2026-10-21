import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_cubit.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_layout.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;
    final loading = state is AuthLoading;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) Navigator.of(context).pop();
      },
      child: AuthLayout(
        title: 'Join ConnectMe',
        subtitle: 'Your new community is waiting.',
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Create your account',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppPalette.ink,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tell us a little about yourself.',
                style: TextStyle(color: AppPalette.muted),
              ),
              const SizedBox(height: 26),
              TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Full name',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: (value) {
                  final name = value?.trim() ?? '';
                  if (name.isEmpty) return 'Enter your full name';
                  if (name[0] != name[0].toUpperCase() ||
                      name[0] == name[0].toLowerCase()) {
                    return 'Start your name with a capital letter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
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
                validator: (value) => value == null || value.length < 6
                    ? 'Use at least 6 characters'
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _confirm,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Confirm password',
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                ),
                validator: (value) =>
                    value != _password.text ? 'Passwords do not match' : null,
              ),
              if (state is AuthUnauthenticated && state.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    state.error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: loading
                    ? null
                    : () {
                        if (_form.currentState!.validate()) {
                          context.read<AuthCubit>().signUp(
                            _name.text.trim(),
                            _email.text.trim(),
                            _password.text,
                          );
                        }
                      },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(loading ? 'Creating…' : 'Create account'),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: loading ? null : () => Navigator.pop(context),
                child: const Text('Already a member? Sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
