
import 'package:flutter/material.dart';

class LineInfoWidget extends StatelessWidget {
  const LineInfoWidget({
    required this.color,
    required this.title,
    super.key,
  });
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          height: 20,
          width: 40,
          child: ColoredBox(
            color: color,
          ),
        ),
      ],
    );
  }
}
