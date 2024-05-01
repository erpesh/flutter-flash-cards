import 'package:flutter/material.dart';

class MultiChoiceCard extends StatelessWidget {
  final int cardNumber;
  final int testLength;
  final Map<String, dynamic> mcObject;
  final void Function(String answer) selectAnswer;

  const MultiChoiceCard({
    super.key,
    required this.cardNumber,
    required this.testLength,
    required this.mcObject,
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
        color: Colors.blue.shade400
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
                Text(cardNumber.toString() + "/$testLength")
              ],
            ),
            SizedBox(height: 10),
            Text(mcObject["term"]),
            SizedBox(height: 10),
            Text(
              "Select the correct term",
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                  mcObject["possibleAnswers"].length,
                  (index) {
                    final answer = mcObject["possibleAnswers"][index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: GestureDetector(
                        onTap: () => selectAnswer(answer["definition"]),
                        child: Container(
                            margin: EdgeInsets.only(right: 5),
                            padding: EdgeInsets.all(8),
                            decoration: mcObject["userAnswer"] != null && mcObject["userAnswer"] == answer["definition"] ?
                            activeAnswerDecor : defaultAnswerDecor,
                            child: Text(answer["definition"])
                        ),
                      ),
                    );
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}
