import 'package:flash_cards/pages/set_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Library"),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: _buildLibraryList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/createSet");
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }

  Widget _buildLibraryList() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(child: Text("Please sign in to view your library."));
    } else {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Sets')
            .where('author.email', isEqualTo: user.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List setsList = snapshot.data!.docs;

            return Padding(
              padding: const EdgeInsets.all(15),
              child: ListView.builder(
                  itemCount: setsList.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = setsList[index];
                    String docId = document.id;
                    final data = document.data() as Map<String, dynamic>;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SetDetailsPage(cardsSet: {
                              ...data,
                              "id": docId
                            }),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  data["title"],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20
                                  ),
                                ),
                                Text(data["description"])
                              ],
                            ),
                            Row(
                              children: [Text(data["author"]["username"])],
                            )
                          ],
                        ),
                      ),
                    );
                  }
              ),
            );
          }
          return Center(child: Text("You haven't created any sets yet."));
        },
      );
    }
  }
}
