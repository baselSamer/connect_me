import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/create_post.dart';
import '../../domain/usecases/get_posts.dart';

sealed class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  PostLoaded(this.posts, {this.message});
  final List<Post> posts;
  final String? message;
}

class PostError extends PostState {
  PostError(this.message);
  final String message;
}

class PostCubit extends Cubit<PostState> {
  PostCubit(this._getPosts, this._createPost) : super(PostInitial());
  final GetPosts _getPosts;
  final CreatePost _createPost;
  StreamSubscription<List<Post>>? _subscription;

  void watch() {
    _subscription?.cancel();
    emit(PostLoading());
    _subscription = _getPosts().listen(
      (posts) => emit(PostLoaded(posts)),
      onError: (Object error) => emit(PostError(friendlyError(error))),
    );
  }

  Future<bool> create({
    required String authorId,
    required String authorName,
    required String content,
  }) async {
    try {
      await _createPost(
        Post(
          id: '',
          authorId: authorId,
          authorName: authorName,
          content: content.trim(),
          createdAt: DateTime.now(),
        ),
      );
      return true;
    } catch (error) {
      final previous = state;
      if (previous is PostLoaded) {
        emit(PostLoaded(previous.posts, message: friendlyError(error)));
      } else {
        emit(PostError(friendlyError(error)));
      }
      return false;
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await super.close();
  }
}
