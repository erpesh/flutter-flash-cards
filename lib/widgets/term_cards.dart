import 'package:flutter/material.dart';

class TermCards extends StatefulWidget {
  final List<dynamic> terms;

  const TermCards({super.key, required this.terms});



  @override
  State<TermCards> createState() => _TermCardsState();
}

class _TermCardsState extends State<TermCards> {
  int currentIndex = 0;
  bool isTermSide = true;

  void nextCard() {
    setState(() {
      if (currentIndex == widget.terms.length - 1) {
        currentIndex = 0;
      }
      else {
        currentIndex++;
      }
    });
  }

  void prevCard() {
    setState(() {
      if (currentIndex == 0) {
        currentIndex = widget.terms.length - 1;
      }
      else {
        currentIndex--;
      }
    });
  }

  void flipCard() {
    setState(() {
      isTermSide = !isTermSide;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTerm = widget.terms[currentIndex];

    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! > 0) {
          prevCard();
        } else if (details.primaryVelocity! < 0) {
          nextCard();
        }
      },
      onTap: flipCard,
      child: Card(
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(isTermSide ? "Term" : "Definition"),
                  Text((currentIndex + 1).toString() + "/" + widget.terms.length.toString()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50),
              child: Text(
                isTermSide ? currentTerm["term"] : currentTerm["definition"],
                style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: prevCard,
                    icon: Icon(
                      Icons.chevron_left,
                      size: 50
                    )
                ),
                IconButton(
                    onPressed: nextCard,
                    icon: Icon(
                      Icons.chevron_right,
                      size: 50
                    )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
