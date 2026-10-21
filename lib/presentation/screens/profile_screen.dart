import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_cubit.dart';
import '../blocs/profile_cubit.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_backdrop.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width > 600 ? 500 : width),
          child: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is ProfileLoaded && state.message != null) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message!)));
              }
            },
            builder: (context, state) {
              if (state is ProfileLoading || state is ProfileInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ProfileError) {
                return Center(child: Text(state.message));
              }
              final profile = (state as ProfileLoaded);
              final user = profile.user;
              final bytes = user.photoBase64 == null
                  ? null
                  : base64Decode(user.photoBase64!);
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 240,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: [
                          Positioned.fill(
                            bottom: 42,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(32),
                              ),
                              child: const BrandBackdrop(),
                            ),
                          ),
                          CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 59,
                              backgroundColor: AppPalette.surface,
                              backgroundImage: bytes == null
                                  ? null
                                  : MemoryImage(bytes),
                              child: bytes == null
                                  ? const Icon(
                                      Icons.person_rounded,
                                      size: 61,
                                      color: AppPalette.violet,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.fullName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      user.email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppPalette.muted),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppPalette.surface,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.phone_android_rounded,
                            color: AppPalette.violet,
                          ),
                          title: const Text(
                            'Your device',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(profile.device),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FilledButton.icon(
                            onPressed: context.read<ProfileCubit>().updatePhoto,
                            icon: const Icon(Icons.photo_library_outlined),
                            label: const Text('Update profile photo'),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              context.read<AuthCubit>().signOut();
                            },
                            icon: const Icon(Icons.logout),
                            label: const Text('Sign out'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
