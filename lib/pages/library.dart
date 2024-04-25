import 'package:flash_cards/widgets/library_set_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  bool showOnlyUserSets = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Library"),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Only Your Sets",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
                SizedBox(width: 5),
                Switch(
                  value: showOnlyUserSets,
                  onChanged: (newValue) {
                    setState(() {
                      showOnlyUserSets = newValue;
                    });
                  },
                ),
              ],
            ),
            _buildLibraryList(),
          ],
        ),
      ),
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
        stream: showOnlyUserSets ?
        FirebaseFirestore.instance
            .collection('Sets')
            .where('author.email', isEqualTo: user.email)
            .snapshots() :
        FirebaseFirestore.instance
            .collection('Sets')
            .where('isPrivate', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List setsList = snapshot.data!.docs;

            return Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  for (int index = 0; index < setsList.length; index++)
                    LibrarySetCard(
                      cardSetData: {
                        ...setsList[index].data() as Map<String, dynamic>,
                        "id": setsList[index].id
                      },
                    ),
                ],
              )
            );
          }
          return Center(child: Text("You haven't created any sets yet."));
        },
      );
    }
  }
}
