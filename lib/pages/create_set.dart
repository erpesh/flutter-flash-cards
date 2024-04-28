import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_cards/widgets/button.dart';
import 'package:flash_cards/widgets/create_term_card.dart';
import 'package:flash_cards/widgets/textfield.dart';
import 'package:flash_cards/helper/helper_functions.dart';
import 'package:uuid/uuid.dart';

class TermData {
  String id;
  TextEditingController termController;
  TextEditingController definitionController;

  TermData({
    required this.id,
    required this.termController,
    required this.definitionController,
  });
}

class CreateSetPage extends StatefulWidget {
  final Map<String, dynamic>? cardsSet;

  const CreateSetPage({Key? key, this.cardsSet}) : super(key: key);

  @override
  _CreateSetPageState createState() => _CreateSetPageState();
}

class _CreateSetPageState extends State<CreateSetPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  List<TermData> termDataList = [];
  bool isPrivate = false;

  static const uuid = Uuid();

  void _addTermCard() {
    setState(() {
      termDataList.add(TermData(
        id: uuid.v1(),
        termController: TextEditingController(),
        definitionController: TextEditingController(),
      ));
    });
  }

  void _removeTermCard(int index) {
    setState(() {
      termDataList.removeAt(index);
    });
  }

  void _createSet() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        )
    );

    try {
      String? email = FirebaseAuth.instance.currentUser?.email;

      if (email != null) {
        DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(email).get();

        if (userSnapshot.exists) {
          String username = userSnapshot['username'];
          DateTime now = DateTime.now();
          List<Map<String, String>> termsList = [];

          for (var termData in termDataList) {
            termsList.add({
              'id': termData.id,
              'term': termData.termController.text,
              'definition': termData.definitionController.text,
            });
          }

          Map<String, dynamic> setData = {
            'title': titleController.text,
            'description': descriptionController.text,
            'terms': termsList,
            'isPrivate': isPrivate,
            'author': {'username': username, 'email': email},
            'createdAt': now,
            'updatedAt': now,
          };

          await FirebaseFirestore.instance.collection('Sets').add(setData);

          Navigator.pop(context);
        } else {
          print('User not found.');
        }
      } else {
        print('User not authenticated.');
      }
      Navigator.pop(context);
    }
    catch (e) {
      Navigator.pop(context);

      displayMessageToUser("Error while creating new set", context);
    }
  }

  void _updateSet() async {
    if (widget.cardsSet == null) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final email = FirebaseAuth.instance.currentUser?.email;

      if (email != null) {
        final userSnapshot = await FirebaseFirestore.instance.collection('Users').doc(email).get();
        if (userSnapshot.exists) {
          final username = userSnapshot['username'];
          final now = DateTime.now();
          final termsList = termDataList.map((termData) {
            return {
              'id': termData.id,
              'term': termData.termController.text,
              'definition': termData.definitionController.text,
            };
          }).toList();

          final setData = {
            'title': titleController.text,
            'description': descriptionController.text,
            'terms': termsList,
            'isPrivate': isPrivate,
            'author': {'username': username, 'email': email},
            'updatedAt': now,
          };

          final setId = widget.cardsSet?["id"];
          await FirebaseFirestore.instance.collection('Sets').doc(setId).update(setData);

          Navigator.pop(context);
        } else {
          print('User not found.');
        }
      } else {
        print('User not authenticated.');
      }
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      displayMessageToUser("Error while updating the set", context);
    }
  }

  @override
  void initState() {
    super.initState();

    final cardsSet = widget.cardsSet;

    if (cardsSet != null) {
      titleController.text = cardsSet["title"];
      descriptionController.text = cardsSet["description"];
      isPrivate = cardsSet["isPrivate"];

      termDataList = cardsSet["terms"].map<TermData>((term)  {
        var termController = TextEditingController();
        var definitionController = TextEditingController();

        termController.text = term["term"];
        definitionController.text = term["definition"];

        var termData = TermData(
            id: term["id"],
            termController: termController,
            definitionController: definitionController
        );
        return termData;
      }).toList();
    }
    else {
      // Add one default TermData item to the list
      termDataList.add(TermData(
        id: uuid.v1(),
        termController: TextEditingController(),
        definitionController: TextEditingController(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cardsSet == null ? "Create New Set" : "Edit Cards Set"),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 25),
                MyTextField(
                    hintText: "Title", obscureText: false, controller: titleController),
                const SizedBox(height: 10),
                MyTextField(
                    hintText: "Description",
                    obscureText: false,
                    controller: descriptionController
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text("Private"),
                    Switch(
                      value: isPrivate,
                      onChanged: (value) {
                        setState(() {
                          isPrivate = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                // Expanded(
                //   child: ReorderableListView(
                //     padding: EdgeInsets.zero,
                //     onReorder: _onReorder,
                //     children: [
                //       for (int i = 0; i < termDataList.length; i++)
                //         TermCard(
                //           index: i,
                //           termController: termDataList[i].termController,
                //           definitionController: termDataList[i].definitionController,
                //           onDelete: () => _removeTermCard(i),
                //           key: Key(i.toString()),
                //         )
                //     ],
                //   ),
                // ),
                Column(
                  children: [
                    for (int i = 0; i < termDataList.length; i++)
                      CreateTermCard(
                        index: i,
                        termController: termDataList[i].termController,
                        definitionController: termDataList[i].definitionController,
                        onDelete: () => _removeTermCard(i),
                        key: Key(i.toString()),
                      )
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyButton(
                      text: "Add Term Card",
                      onTap: _addTermCard,
                    ),
                    widget.cardsSet == null ?
                    MyButton(
                      text: "Create",
                      onTap: _createSet,
                    ) :
                    MyButton(
                      text: "Update",
                      onTap: _updateSet,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void _onReorder(int oldIndex, int newIndex) {
  //   setState(() {
  //     if (oldIndex < newIndex) {
  //       newIndex--;
  //     }
  //     final item = termDataList.removeAt(oldIndex);
  //     termDataList.insert(newIndex, item);
  //   });
  // }
}
