import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../pages/set_details.dart';

class LibrarySetCard extends StatefulWidget {
  final Map<String, dynamic> cardSetData;

  const LibrarySetCard({
    super.key,
    required this.cardSetData
  });

  @override
  State<LibrarySetCard> createState() => _LibrarySetCardState();
}

class _LibrarySetCardState extends State<LibrarySetCard> {
  String? profileImage;

  @override
  void initState() {
    super.initState();

    Reference ref = FirebaseStorage.instance.ref().child("pfp-${widget.cardSetData["author"]["email"]}.jpg");
    ref.getDownloadURL().then((value) {
      setState(() {
        profileImage = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SetDetailsPage(cardsSet: {
              ...widget.cardSetData,
              "profilePicture": profileImage
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
                  widget.cardSetData["title"],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
                Text(widget.cardSetData["description"])
              ],
            ),
            Row(
              children: [
                Text(
                  widget.cardSetData["author"]["username"]!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                profileImage != null ? ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    profileImage!,
                    height: 32,
                    width: 32,
                    fit: BoxFit.cover,
                  ),
                ) : SizedBox(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
