import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class OverflowText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;

  const OverflowText({
    super.key,
    required this.text,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Define the text style and create a TextPainter
        TextSpan textSpan = TextSpan(text: text, style: textStyle);
        TextPainter textPainter = TextPainter(
          text: textSpan,
          maxLines: 1,
          textDirection: TextDirection.ltr,
        );

        // Layout the text within the provided constraints
        textPainter.layout(maxWidth: constraints.maxWidth);

        // Check if the text overflows
        bool isOverflowing = textPainter.didExceedMaxLines;

        // Display widgets based on the overflow state
        return isOverflowing
            ? Marquee(
                key: ValueKey(text),
                text: text,
                style: textStyle,
                startAfter: const Duration(seconds: 2),
                pauseAfterRound: const Duration(seconds: 4),
                fadingEdgeEndFraction: 0.1,
                blankSpace: 60,
              )
            : Text(
                text,
                style: textStyle,
                softWrap: false,
                overflow: TextOverflow.fade,
              );
      },
    );
  }
}
