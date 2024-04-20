import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final firestore = FirebaseFirestore.instance;
  final CollectionReference notes = FirebaseFirestore.instance.collection("notes");
  final CollectionReference users = FirebaseFirestore.instance.collection("Users");

  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now()
    });
  }

  Stream<QuerySnapshot> getNotesStream() {
    return notes.orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> updateNote(String docId, String newNote) {
    return notes.doc(docId).update({
      'note': newNote,
      'timestamp': Timestamp.now()
    });
  }

  Future<void> deleteNote(String docId) {
    return notes.doc(docId).delete();
  }

  Future<void> addUserDocument(String email, String username) async {
    await users
        .doc(email)
        .set({
          'email': email,
          'username': username,
        });
  }
}