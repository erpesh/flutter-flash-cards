import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_cards/pages/create_set.dart';
import 'package:flash_cards/pages/test.dart';
import 'package:flash_cards/widgets/term_cards.dart';
import 'package:flutter/material.dart';

class SetDetailsPage extends StatelessWidget {
  final Map<String, dynamic> cardsSet;

  const SetDetailsPage({Key? key, required this.cardsSet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(cardsSet['title']),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TermCards(terms: cardsSet["terms"]),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Created by",
                          style: TextStyle(fontSize: 14)
                        ),
                        Text(
                          cardsSet['author']['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          ),
                        )
                      ],
                    ),
                    SizedBox(width: 10),
                    cardsSet["profilePicture"] != null ? ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        cardsSet["profilePicture"]!,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    ) : SizedBox()
                  ],
                ),
                currentUser != null && currentUser.email == cardsSet["author"]["email"] ? IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateSetPage(cardsSet: cardsSet),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.inversePrimary
                  )
                ) : SizedBox()
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TestPage(terms: cardsSet["terms"]),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // <-- Radius
                  ),
                ),
                icon: Icon(
                  Icons.note_alt,
                  color: Theme.of(context).colorScheme.inversePrimary
                ),
                label: Text(
                  "Test",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }
}