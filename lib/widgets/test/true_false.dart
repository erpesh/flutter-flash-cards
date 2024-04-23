import 'package:flutter/material.dart';

class TrueFalseCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> tfObject;
  final void Function(bool answer) selectAnswer;

  const TrueFalseCard({
    super.key,
    required this.index,
    required this.tfObject,
    required this.selectAnswer
  });

  @override
  Widget build(BuildContext context) {

    final defaultAnswerDecor = BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.inversePrimary),
        color: Theme.of(context).colorScheme.primary
    );
    final activeAnswerDecor = BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade900),
        color: Colors.blue.shade200
    );

    return Card(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Term",
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text((index + 1).toString() + "/20"),
              ],
            ),
            SizedBox(height: 10),
            Text(tfObject["term"]),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
            Text(tfObject["isTrue"] ? tfObject["definition"] : tfObject["incorrectAnswer"]["definition"]),
            SizedBox(height: 10),
            Text(
              "Choose the answer",
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () => selectAnswer(true),
                    child: Container(
                        margin: EdgeInsets.only(right: 5),
                        padding: EdgeInsets.all(8),
                        decoration: tfObject["userAnswer"] != null && tfObject["userAnswer"] ?
                          activeAnswerDecor : defaultAnswerDecor,
                        child: Text("True")
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () => selectAnswer(false),
                    child: Container(
                        margin: EdgeInsets.only(left: 5),
                        padding: EdgeInsets.all(8),
                        decoration: tfObject["userAnswer"] != null && !tfObject["userAnswer"] ?
                        activeAnswerDecor : defaultAnswerDecor,
                        child: Text("False")
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
}
