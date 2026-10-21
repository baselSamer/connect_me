import '../../services/firestore_service.dart';
import '../models/post_model.dart';

abstract class PostDataSource {
  Stream<List<PostModel>> watchPosts();
  Future<void> createPost(PostModel post);
}

class FirestorePostDataSource implements PostDataSource {
  FirestorePostDataSource(this._service);
  final FirestoreService _service;

  @override
  Stream<List<PostModel>> watchPosts() => _service.db
      .collection('posts')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => PostModel.fromJson(doc.id, doc.data()))
            .toList(),
      );

  @override
  Future<void> createPost(PostModel post) =>
      _service.db.collection('posts').add(post.toJson()).then((_) {});
}
