import 'package:cloud_firestore/cloud_firestore.dart';

// Singleton shares one Firestore client across all repositories and services.
class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();
  FirebaseFirestore get db => FirebaseFirestore.instance;
}
