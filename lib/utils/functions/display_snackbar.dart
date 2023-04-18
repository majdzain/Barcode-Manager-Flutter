import 'package:flutter/material.dart';

void displaySnackbar(BuildContext context, String txt) {
  final snackBar = SnackBar(content: Text(txt));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
