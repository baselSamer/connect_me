import '../entities/post.dart';
import '../repositories/post_repository.dart';

class GetPosts {
  GetPosts(this._repository);
  final PostRepository _repository;
  Stream<List<Post>> call() => _repository.watchPosts();
}
