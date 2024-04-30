import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_cards/pages/create_set.dart';
import 'package:flash_cards/services/firestore_services.dart';
import 'package:flash_cards/widgets/library_set_card.dart';
import 'package:flash_cards/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  bool showOnlyUserSets = false;
  final searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final firestore = FirestoreServices(FirebaseFirestore.instance);

    return Scaffold(
      appBar: AppBar(
        title: Text("Library"),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: MyTextField(
                  hintText: "Search by title",
                  obscureText: false,
                  controller: searchController,
                  onChanged: (String value) {
                    setState(() {
                      searchQuery = value;
                    });
                  }
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
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
            ),
            StreamBuilder(
              stream: showOnlyUserSets ?
                firestore.getSetsByUser(user!.email!):
                firestore.getPublicSets(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List setsList = snapshot.data!.docs;

                  // Filter by search query
                  setsList = setsList.where((item) => item["title"]
                      .toString()
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase())
                  ).toList();

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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateSetPage())
          );
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }
}
