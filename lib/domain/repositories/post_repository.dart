import '../entities/post.dart';

abstract class PostRepository {
  Stream<List<Post>> watchPosts();
  Future<void> createPost(Post post);
}
