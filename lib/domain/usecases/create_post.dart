import '../entities/post.dart';
import '../repositories/post_repository.dart';

class CreatePost {
  CreatePost(this._repository);
  final PostRepository _repository;
  Future<void> call(Post post) => _repository.createPost(post);
}
