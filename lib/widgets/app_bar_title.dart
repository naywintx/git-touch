import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  final String? text;

  const AppBarTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text!, overflow: TextOverflow.ellipsis);
  }
}
