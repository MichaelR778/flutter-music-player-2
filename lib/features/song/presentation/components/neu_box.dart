import 'package:flutter/material.dart';

class NeuBox extends StatelessWidget {
  final Widget? child;

  const NeuBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            // darker shadow on bottom right
            const BoxShadow(
              color: Colors.black,
              blurRadius: 15,
              offset: Offset(4, 4),
            ),

            // lighter shadow on top left
            BoxShadow(
              color: Colors.grey.shade800,
              blurRadius: 15,
              offset: const Offset(-4, -4),
            ),
          ]),
      padding: const EdgeInsets.all(12),
      child: child,
    );
  }
}
