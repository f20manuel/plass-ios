import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Currency extends StatelessWidget {
  const Currency({
    Key? key,
    required this.value,
    this.style,
  }) : super(key: key);

  final double value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "COP",
        style: const TextStyle(
          color: Colors.grey
        ),
        children: [
          TextSpan(
            text: "\$${NumberFormat.currency(locale: 'eu', name: '', decimalDigits: 0).format(value)}",
            style: style,
          )
        ]
      ),
    );
    return Text(
      '',
      style: style,
    );
  }
}