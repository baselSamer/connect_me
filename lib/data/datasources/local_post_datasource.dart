import 'firestore_post_datasource.dart';
import '../models/post_model.dart';

class LocalPostDataSource implements PostDataSource {
  List<PostModel> _posts = [];
  void cache(List<PostModel> posts) => _posts = List.unmodifiable(posts);
  List<PostModel> get cachedPosts => _posts;

  @override
  Stream<List<PostModel>> watchPosts() => Stream.value(_posts);

  @override
  Future<void> createPost(PostModel post) async {
    _posts = [post, ..._posts];
  }
}
