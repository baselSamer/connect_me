import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../../services/firestore_service.dart';
import '../datasources/firestore_post_datasource.dart';
import '../datasources/local_post_datasource.dart';
import '../models/post_model.dart';

// Factory selects the live Firestore source or the local cache source.
class PostDataSourceFactory {
  static PostDataSource create({
    required bool useRemote,
    required FirestoreService firestore,
    required LocalPostDataSource cache,
  }) => useRemote ? FirestorePostDataSource(firestore) : cache;
}

class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl(this._remote, this._cache);
  final PostDataSource _remote;
  final LocalPostDataSource _cache;

  @override
  Stream<List<Post>> watchPosts() async* {
    if (_cache.cachedPosts.isNotEmpty) yield _cache.cachedPosts;
    try {
      await for (final posts in _remote.watchPosts()) {
        _cache.cache(posts);
        yield posts;
      }
    } catch (_) {
      if (_cache.cachedPosts.isNotEmpty) {
        yield _cache.cachedPosts;
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<void> createPost(Post post) async {
    final model = PostModel(
      id: post.id,
      authorId: post.authorId,
      authorName: post.authorName,
      content: post.content,
      createdAt: post.createdAt,
    );
    await _remote.createPost(model);
  }
}
