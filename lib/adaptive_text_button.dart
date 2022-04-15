import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveTextButton extends StatelessWidget {
  final VoidCallback onPressed;

  final String text;

  const AdaptiveTextButton(
      {Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child:
                Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: onPressed,
          )
        : TextButton(
            style: Theme.of(context).textButtonTheme.style,
            child: Text(text),
            onPressed: onPressed,
          );
  }
}
