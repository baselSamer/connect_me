import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/errors/failures.dart';
import '../../data/models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';

sealed class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  ProfileLoaded(this.user, this.device, {this.message});
  final UserModel user;
  final String device;
  final String? message;
}

class ProfileError extends ProfileState {
  ProfileError(this.message);
  final String message;
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._auth, this._firestore) : super(ProfileInitial());
  final AuthService _auth;
  final FirestoreService _firestore;

  Future<void> load() async {
    emit(ProfileLoading());
    try {
      final authUser = _auth.currentUser;
      if (authUser == null) {
        emit(ProfileError('Please sign in again.'));
        return;
      }
      final snapshot = await _firestore.db
          .collection('users')
          .doc(authUser.uid)
          .get();
      final user = UserModel.fromJson(
        authUser.uid,
        snapshot.data() ??
            {
              'fullName': authUser.displayName ?? 'Member',
              'email': authUser.email ?? '',
            },
      );
      String device = 'Device information unavailable';
      try {
        final info = DeviceInfoPlugin();
        if (defaultTargetPlatform == TargetPlatform.android) {
          final android = await info.androidInfo;
          device = '${android.model} · Android ${android.version.release}';
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          final ios = await info.iosInfo;
          device = '${ios.utsname.machine} · iOS ${ios.systemVersion}';
        }
      } catch (_) {
        /* Profile remains usable when device details are unavailable. */
      }
      emit(ProfileLoaded(user, device));
    } catch (error) {
      emit(ProfileError(friendlyError(error)));
    }
  }

  Future<void> updatePhoto() async {
    final current = state;
    if (current is! ProfileLoaded) return;
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 700,
        maxHeight: 700,
        imageQuality: 45,
      );
      if (image == null) return;
      final bytes = await image.readAsBytes();
      if (bytes.length > 650000) {
        emit(
          ProfileLoaded(
            current.user,
            current.device,
            message: 'Please select a smaller photo.',
          ),
        );
        return;
      }
      final encoded = base64Encode(bytes);
      final updatedUser = UserBuilder(current.user.id)
          .withFullName(current.user.fullName)
          .withEmail(_auth.currentUser?.email ?? current.user.email)
          .withPhoto(encoded)
          .build();
      await _firestore.db
          .collection('users')
          .doc(current.user.id)
          .set(updatedUser.toJson(), SetOptions(merge: true));
      emit(ProfileLoaded(updatedUser, current.device));
    } catch (error) {
      emit(
        ProfileLoaded(
          current.user,
          current.device,
          message: friendlyError(error),
        ),
      );
    }
  }
}
