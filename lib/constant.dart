import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

successSnackbar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    ),
  );
}

errorsnackbar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ),
  );
}
