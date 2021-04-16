import 'package:flutter/material.dart';

class CenteredText extends StatelessWidget {
  final String text;

  const CenteredText({
    Key key,
    this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16.0),textAlign:  TextAlign.center,
      ),
    );
  }
}
