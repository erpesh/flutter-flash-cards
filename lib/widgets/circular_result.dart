import 'package:flutter/material.dart';

class CircularResult extends StatelessWidget {
  final double size;
  final double percentage;

  const CircularResult({
    super.key,
    required this.size,
    required this.percentage
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Center(
          child: SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeWidth: 6,
              value: percentage! / 100,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Center(child: Text(percentage!.toStringAsFixed(0) + "%")),
      ],
    );
  }
}
