import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreServices {
  FirebaseFirestore firestore;

  FirestoreServices(this.firestore);

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails(String email) async {
    return await firestore
        .collection("Users")
        .doc(email)
        .get();
  }

  Future<void> addUserDocument(String email, String username) async {
    await firestore
        .collection("Users")
        .doc(email)
        .set({
      'email': email,
      'username': username,
      'createdAt': Timestamp.now()
    });
  }

  Future<void> deleteUserDocument(String email) async {
    await firestore
        .collection("Users")
        .doc(email)
        .delete();
  }

  Future<DocumentReference<Map<String, dynamic>>> addCardsSet(Map<String, dynamic> cardsSet) async {
    DateTime now = DateTime.now();

    return await firestore
        .collection("Sets")
        .add({
      ...cardsSet,
      "createdAt": now,
      "updatedAt": now
    });
  }

  Future<void> updateCardsSet(String setId, Map<String, dynamic> cardsSet) async {
    await firestore
        .collection("Sets")
        .doc(setId)
        .update({
      ...cardsSet,
      "updatedAt": DateTime.now()
    });
  }

  Future<void> deleteCardsSet(String setId) async {
    await firestore
        .collection('Sets')
        .doc(setId)
        .delete();
  }

  Stream<QuerySnapshot<Object?>>? getPublicSets() {
    return firestore
        .collection('Sets')
        .where('isPrivate', isEqualTo: false)
        .snapshots();
  }

  Stream<QuerySnapshot<Object?>>? getSetsByUser(String email) {
    return firestore
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