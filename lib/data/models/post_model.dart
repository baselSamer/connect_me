import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.authorId,
    required super.authorName,
    required super.content,
    required super.createdAt,
  });

  factory PostModel.fromJson(String id, Map<String, dynamic> json) => PostModel(
    id: id,
    authorId: json['authorId'] as String? ?? '',
    authorName: json['authorName'] as String? ?? 'Member',
    content: json['content'] as String? ?? '',
    createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'authorId': authorId,
    'authorName': authorName,
    'content': content,
    'createdAt': Timestamp.fromDate(createdAt),
  };
}
