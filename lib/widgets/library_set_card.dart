import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class LibrarySetCard extends StatefulWidget {
  final String title;
  final String description;
  final Map<String, dynamic> author;
  final void Function() onTap;

  const LibrarySetCard({
    super.key,
    required this.title,
    required this.description,
    required this.author,
    required this.onTap,
  });

  @override
  State<LibrarySetCard> createState() => _LibrarySetCardState();
}

class _LibrarySetCardState extends State<LibrarySetCard> {
  String? profileImage;

  @override
  void initState() {
    super.initState();

    Reference ref = FirebaseStorage.instance.ref().child("pfp-${widget.author["email"]}.jpg");
    ref.getDownloadURL().then((value) {
      setState(() {
        profileImage = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
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
                  widget.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
                Text(widget.description)
              ],
            ),
            Row(
              children: [
                Text(
                  widget.author["username"]!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    profileImage!,
                    height: 32,
                    width: 32,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
