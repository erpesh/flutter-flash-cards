import 'package:flutter/material.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(100)
        ),
        child: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.inversePrimary
        ),
      ),
    );
  }
}
