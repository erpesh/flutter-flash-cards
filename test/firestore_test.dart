import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flash_cards/services/firestore_services.dart';
import 'package:flutter_test/flutter_test.dart';

// Ref - https://stackoverflow.com/a/71371403

void main() {
  late FakeFirebaseFirestore fakeFirebaseFirestore;
  late FirestoreServices firestore;

  setUp(() {
    fakeFirebaseFirestore = FakeFirebaseFirestore();
    firestore = FirestoreServices(fakeFirebaseFirestore);
  });

  test('Add User Document', () async {
    await firestore.addUserDocument('test@email.com', 'Test User');

    var userDetails = await firestore.getUserDetails('test@email.com');

    expect(userDetails.exists, true);
    expect(userDetails.data()?['email'], 'test@email.com');
    expect(userDetails.data()?['username'], 'Test User');
  });

  test('Delete User Document', () async {
    await firestore.addUserDocument('test@email.com', 'Test User');
    await firestore.deleteUserDocument('test@email.com');

    var userDetails = await firestore.getUserDetails('test@email.com');

    expect(userDetails.exists, false);
  });

  test('Add Cards Set', () async {
    Map<String, dynamic> cardsSet = {
      'title': 'Test Cards Set',
      'description': 'This is a test cards set',
      'author': {'email': 'test@email.com', 'username': 'test'},
      'isPrivate': false,
      'terms': []
    };

    await firestore.addCardsSet(cardsSet);

    var publicSetsSnapshot = await firestore.getPublicSets()?.first;

    expect(publicSetsSnapshot?.docs.length, 1);
    expect(publicSetsSnapshot?.docs[0]['title'], 'Test Cards Set');
  });

  test('Update Cards Set', () async {
    final addedCardsSet = await firestore.addCardsSet({
      'title': 'Test Cards Set',
      'description': 'This is a test cards set',
      'author': {'email': 'test@email.com', 'username': 'test'},
      'isPrivate': false,
      'terms': []
    });

    await firestore.updateCardsSet(addedCardsSet.id, {'title': 'Updated Cards Set'});

    var publicSetsSnapshot = await firestore.getPublicSets()?.first;

    expect(publicSetsSnapshot?.docs.length, 1);
    expect(publicSetsSnapshot?.docs[0]['title'], 'Updated Cards Set');
  });

  test('Delete Cards Set', () async {
    final addedCardsSet = await firestore.addCardsSet({
      'title': 'Test Cards Set',
      'description': 'This is a test cards set',
      'author': {'email': 'test@email.com', 'username': 'test'},
      'isPrivate': false,
      'terms': []
    });

    await firestore.deleteCardsSet(addedCardsSet.id);

    var publicSetsSnapshot = await firestore.getPublicSets()?.first;

    expect(publicSetsSnapshot?.docs.length, 0);
  });

  test('Get Public Sets', () async {
    await firestore.addCardsSet({
      'title': 'Public Cards Set',
      'description': 'This is a public cards set',
      'author': {'email': 'test@email.com', 'username': 'test'},
      'isPrivate': false,
      'terms': []
    });

    var publicSetsSnapshot = await firestore.getPublicSets()?.first;

    expect(publicSetsSnapshot?.docs.length, 1);
    expect(publicSetsSnapshot?.docs[0]['title'], 'Public Cards Set');
  });

  test('Get Sets By User', () async {
    await firestore.addCardsSet({
      'title': 'User Cards Set',
      'description': 'This is a user cards set',
      'isPrivate': false,
      'author': {'email': 'test@email.com', 'username': 'test'},
      'terms': []
    });

    var userSetsSnapshot = await firestore.getSetsByUser('test@email.com')?.first;

    expect(userSetsSnapshot?.docs.length, 1);
    expect(userSetsSnapshot?.docs[0]['title'], 'User Cards Set');
  });
}
