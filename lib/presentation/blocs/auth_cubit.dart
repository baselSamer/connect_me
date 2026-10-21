import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/errors/failures.dart';
import '../../services/auth_service.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  AuthAuthenticated(this.user);
  final User user;
}

class AuthUnauthenticated extends AuthState {
  AuthUnauthenticated([this.error]);
  final String? error;
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._service) : super(AuthInitial()) {
    _subscription = _service.authChanges.listen(
      (user) {
        if (_signingUp) return;
        emit(user == null ? AuthUnauthenticated() : AuthAuthenticated(user));
      },
      onError: (Object error) =>
          emit(AuthUnauthenticated(friendlyError(error))),
    );
  }
  final AuthService _service;
  late final StreamSubscription<User?> _subscription;
  bool _signingUp = false;

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      await _service.signIn(email, password);
    } catch (error) {
      emit(AuthUnauthenticated(friendlyError(error)));
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    _signingUp = true;
    emit(AuthLoading());
    try {
      await _service.signUp(name, email, password);
      final user = _service.currentUser;
      emit(
        user == null
            ? AuthUnauthenticated('Please sign in again.')
            : AuthAuthenticated(user),
      );
    } catch (error) {
      emit(AuthUnauthenticated(friendlyError(error)));
    } finally {
      _signingUp = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _service.signOut();
    } catch (error) {
      emit(AuthUnauthenticated(friendlyError(error)));
    }
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    await super.close();
  }
}
