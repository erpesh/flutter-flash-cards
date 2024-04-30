import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_cards/services/auth_services.dart';
import 'package:flash_cards/services/firestore_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flash_cards/theme/theme_provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  String? imageUrl;

  void pickUploadImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75
    );

    final ref = FirestoreServices.getProfilePictureRef(currentUser!.email!);

    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      print(value);
      setState(() {
        imageUrl = value;
      });
    });
  }

  void logout() {
    AuthServices.logoutUser();
  }

  @override
  void initState() {
    super.initState();

    final ref = FirestoreServices.getProfilePictureRef(currentUser!.email!);
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
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirestoreServices(FirebaseFirestore.instance).getUserDetails(currentUser!.email!),
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
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30, top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () => pickUploadImage(ImageSource.gallery),
                                icon: Icon(
                                  Icons.photo,
                                  size: 32
                                )
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => pickUploadImage(ImageSource.gallery),
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
                            SizedBox(width: 10),
                            IconButton(
                                onPressed: () => pickUploadImage(ImageSource.camera),
                                icon: Icon(
                                    Icons.camera_alt,
                                    size: 32
                                )
                            ),
                          ],
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
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(12)
                          ),
                          margin: const EdgeInsets.only(left: 25, top: 10, right: 25),
                          padding: const EdgeInsets.all(15),
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "Dark Mode",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.inversePrimary
                                  )
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CupertinoSwitch(
                                      value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
                                      onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme()
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: logout,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(12)
                            ),
                            margin: const EdgeInsets.only(left: 25, top: 10, right: 25),
                            padding: const EdgeInsets.all(15),
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "Log out",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.inversePrimary
                                    )
                                ),
                                Icon(
                                  Icons.logout,
                                  size: 30,
                                  color: Theme.of(context).colorScheme.inversePrimary
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
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
