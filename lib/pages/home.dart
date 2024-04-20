import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_cards/services/firestore.dart';
import 'package:flash_cards/widgets/drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final firestoreService = FirestoreService();
  //
  // final textController = TextEditingController();
  //
  // void openNoteBox() {
  //   showDialog(context: context, builder: (context) => AlertDialog(
  //     content: TextField(
  //       controller: textController,
  //     ),
  //     actions: [
  //       ElevatedButton(
  //           onPressed: () {
  //             firestoreService.addNote(textController.text);
  //
  //             textController.clear();
  //
  //             Navigator.pop(context);
  //           },
  //           child: Text("Add")
  //       )
  //     ],
  //   ));
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flash Cards"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      drawer: MyDrawer(),
    );
  }
}
