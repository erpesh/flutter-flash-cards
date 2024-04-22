import 'package:flash_cards/pages/create_set.dart';
import 'package:flash_cards/widgets/term_cards.dart';
import 'package:flutter/material.dart';

class SetDetailsPage extends StatelessWidget {
  final Map<String, dynamic> cardsSet;

  const SetDetailsPage({Key? key, required this.cardsSet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                IconButton(
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
                )
              ],
            )
            // Text(
            //   'Description:',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // Text(setValues['description']),
            // SizedBox(height: 20),
            // Text(
            //   'Terms:',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: _buildTermList(setValues['terms']),
            // ),
            // SizedBox(height: 20),
            // Text(
            //   'Private:',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // Text(setValues['isPrivate'] ? 'Yes' : 'No'),
            // SizedBox(height: 20),
            // Text(
            //   'Author:',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // Text(setValues['author']['username']),
            // SizedBox(height: 20),
            // Text(
            //   'Created At:',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // Text(setValues['createdAt'].toString()),
            // SizedBox(height: 20),
            // Text(
            //   'Updated At:',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // Text(setValues['updatedAt'].toString()),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTermList(List<dynamic> terms) {
    List<Widget> termWidgets = [];
    for (var term in terms) {
      termWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Term: ${term['term']}'),
            Text('Definition: ${term['definition']}'),
            SizedBox(height: 10),
          ],
        ),
      );
    }
    return termWidgets;
  }
}