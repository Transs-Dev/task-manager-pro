import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  String get uid =>
      FirebaseAuth.instance.currentUser!.uid;

  CollectionReference get taskRef =>
      _firestore
          .collection('users')
          .doc(uid)
          .collection('tasks');

  Stream<QuerySnapshot> getTasks() {
    return taskRef.orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> addTask({
    required String title,
    required String category,
  }) async {
    await taskRef.add({
      'title': title,
      'category': category,
      'completed': false,
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> deleteTask(String id) async {
    await taskRef.doc(id).delete();
  }

  Future<void> toggleTask(
      String id,
      bool value,
      ) async {
    await taskRef.doc(id).update({
      'completed': value,
    });
  }
}