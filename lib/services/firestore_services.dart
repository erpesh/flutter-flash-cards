import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreServices {
  static Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails(String email) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(email)
        .get();
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

  static Reference getProfilePictureRef(String fileName) {
    return FirebaseStorage.instance
        .ref()
        .child("pfp-$fileName.jpg");
  }
}