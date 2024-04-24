import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash_cards/widgets/back_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  String? imageUrl;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .get();
  }

  void pickUploadImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75
    );

    Reference ref = FirebaseStorage.instance.ref().child("pfp-${currentUser!.email!}.jpg");

    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      print(value);
      setState(() {
        imageUrl = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    Reference ref = FirebaseStorage.instance.ref().child("pfp-${currentUser!.email!}.jpg");
    ref.getDownloadURL().then((value) {
      print(value);
      setState(() {
        imageUrl = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Profile")),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }

          else if (snapshot.hasData) {
            Map<String, dynamic>? user = snapshot.data!.data();

            return Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 50, left: 25),
                    child: Row(
                      children: [
                        MyBackButton(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: pickUploadImage,
                    child: imageUrl != null ?
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        imageUrl!,
                        height: 90,
                        width: 90,
                        fit: BoxFit.cover,
                      ),
                    ) :
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(24)
                      ),
                      padding: const EdgeInsets.all(13),
                      child: const Icon(
                        Icons.person,
                        size: 64
                      )
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    user!["username"],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  Text(
                      user["email"],
                      style: TextStyle(
                          color: Colors.grey[600]
                      )
                  ),
                ],
              ),
            );
          }
          else {
            return Text("No Data");
          }
        },
      )
    );
  }
}
