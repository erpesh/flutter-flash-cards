import 'package:flutter/material.dart';

class TermListCard extends StatelessWidget {
  final int index;
  final TextEditingController termController;
  final TextEditingController definitionController;
  final void Function() onDelete;

  const TermListCard({
    super.key,
    required this.index,
    required this.termController,
    required this.definitionController,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(index),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text((index + 1).toString(), style: TextStyle(fontSize: 20)),
              IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.inversePrimary
                  )
              )
            ],
          ),
          TextField(
            controller: termController,
            cursorColor: Theme.of(context).colorScheme.inversePrimary,
            decoration: InputDecoration(
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(10),
              // ),
              // focusedBorder: OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(10),
              //     borderSide: BorderSide(color: Theme.of(context).colorScheme.inversePrimary)
              // ),
              hintText: "Term",
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: definitionController,
            cursorColor: Theme.of(context).colorScheme.inversePrimary,
            decoration: InputDecoration(
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(10),
              // ),
              // focusedBorder: OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(10),
              //     borderSide: BorderSide(color: Theme.of(context).colorScheme.inversePrimary)
              // ),
              hintText: "Definition",
            ),
          )
        ],
      ),
    );
  }
}
