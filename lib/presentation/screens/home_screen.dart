import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection.dart';
import '../../services/biometric_service.dart';
import '../blocs/auth_cubit.dart';
import '../blocs/post_cubit.dart';
import '../theme/app_theme.dart';
import '../widgets/post_card.dart';
import 'map_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<PostCubit>().watch();
  }

  Future<void> _openProfile() async {
    try {
      final verified = await getIt<BiometricService>().authenticate();
      if (!mounted) return;
      if (verified) {
        await Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Biometric verification is required to open your profile.',
            ),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Biometric verification is unavailable on this device.',
            ),
          ),
        );
      }
    }
  }

  Future<void> _newPost() async {
    final text = TextEditingController();
    final content = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Create a post'),
        content: TextField(
          controller: text,
          maxLength: 1000,
          maxLines: 5,
          minLines: 3,
          decoration: const InputDecoration(
            hintText: 'Share something with the community',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (text.text.trim().isNotEmpty) {
                Navigator.pop(dialogContext, text.text.trim());
              }
            },
            child: const Text('Publish'),
          ),
        ],
      ),
    );
    text.dispose();
    if (!mounted || content == null) return;
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) return;
    final success = await context.read<PostCubit>().create(
      authorId: authState.user.uid,
      authorName:
          authState.user.displayName ??
          authState.user.email?.split('@').first ??
          'Member',
      content: content,
    );
    if (mounted && success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Post published.')));
    }
  }

  void _openMap() => Navigator.push(
    context,
    MaterialPageRoute<void>(builder: (_) => const MapScreen()),
  );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ConnectMe',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: 'Community Map',
            onPressed: _openMap,
            icon: const Icon(Icons.location_on_outlined),
          ),
          IconButton(
            tooltip: 'Profile',
            onPressed: _openProfile,
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width > 700 ? 680 : width),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Search the community',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 14),
                child: Row(
                  children: [
                    const Text(
                      'Community',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppPalette.ink,
                      ),
                    ),
                    const Spacer(),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppPalette.violet.withValues(alpha: .10),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        child: Text(
                          'Latest',
                          style: TextStyle(
                            color: AppPalette.violet,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocConsumer<PostCubit, PostState>(
                  listener: (context, state) {
                    if (state is PostLoaded && state.message != null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message!)));
                    }
                  },
                  builder: (context, state) {
                    if (state is PostLoading || state is PostInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is PostError) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(state.message),
                            TextButton(
                              onPressed: context.read<PostCubit>().watch,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }
                    final query = _search.text.trim().toLowerCase();
                    final posts = (state as PostLoaded).posts
                        .where(
                          (post) =>
                              post.authorName.toLowerCase().contains(query) ||
                              post.content.toLowerCase().contains(query),
                        )
                        .toList();
                    if (posts.isEmpty) {
                      return Center(
                        child: Text(
                          query.isEmpty
                              ? 'No posts yet. Start the conversation!'
                              : 'No posts match your search.',
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: posts.length,
                      itemBuilder: (_, index) => PostCard(post: posts[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _newPost,
        backgroundColor: AppPalette.violet,
        foregroundColor: Colors.white,
        tooltip: 'New post',
        child: const Icon(Icons.add_rounded, size: 31),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 66,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                _search.clear();
                setState(() {});
              },
              tooltip: 'Feed',
              icon: const Icon(Icons.home_rounded, color: AppPalette.violet),
            ),
            IconButton(
              onPressed: _openMap,
              tooltip: 'Community map',
              icon: const Icon(Icons.map_outlined),
            ),
            const SizedBox(width: 48),
            IconButton(
              onPressed: _openProfile,
              tooltip: 'Profile',
              icon: const Icon(Icons.person_outline_rounded),
            ),
            IconButton(
              onPressed: _newPost,
              tooltip: 'Write a post',
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
