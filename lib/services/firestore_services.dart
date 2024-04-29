import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final firestore = FirebaseFirestore.instance;
  final CollectionReference sets = FirebaseFirestore.instance.collection("Sets");
  final CollectionReference users = FirebaseFirestore.instance.collection("Users");

  Future<void> addNote(String note) {
    return sets.add({
      'note': note,
      'timestamp': Timestamp.now()
    });
  }

  Stream<QuerySnapshot> getSetsStream() {
    return sets.orderBy('updatedAt', descending: true).snapshots();
  }



  Future<void> updateNote(String docId, String newNote) {
    return sets.doc(docId).update({
      'note': newNote,
      'timestamp': Timestamp.now()
    });
  }

  Future<void> deleteNote(String docId) {
    return sets.doc(docId).delete();
  }

  static Future<void> addUserDocument(String email, String username) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(email)
        .set({
      'email': email,
      'username': username,
      'createdAt': Timestamp.now()
    });
  }

  static Future<void> addCardsSet(Map<String, dynamic> cardsSet) async {
    DateTime now = DateTime.now();

    await FirebaseFirestore.instance
        .collection("Sets")
        .add({
      ...cardsSet,
      "createdAt": now,
      "updatedAt": now
    });
  }

  static Future<void> updateCardsSet(String setId, Map<String, dynamic> cardsSet) async {
    await FirebaseFirestore.instance
        .collection("Sets")
        .doc(setId)
        .update({
      ...cardsSet,
      "updatedAt": DateTime.now()
    });
  }

  static Future<void> deleteCardsSet(String setId) async {
    await FirebaseFirestore.instance
        .collection('Sets')
        .doc(setId)
        .delete();
  }

  static Stream<QuerySnapshot<Object?>>? getPublicSets() {
    return FirebaseFirestore.instance
        .collection('Sets')
        .where('isPrivate', isEqualTo: false)
        .snapshots();
  }

  static Stream<QuerySnapshot<Object?>>? getSetsByUser(String email) {
    return FirebaseFirestore.instance
        .collection('Sets')
        .where('author.email', isEqualTo: email)
        .snapshots();
  }
}