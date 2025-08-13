import 'package:flutter/material.dart';

class Constants {
  static Future<bool> showalert(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) async {
    final resp = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(subtitle),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: Text('Ok')),
          ],
        );
      },
    );
    return resp ?? false;
  }

  static void showtoast(BuildContext context, {required String message}) {
    SnackBar snackBar = SnackBar(content: Text(message), behavior: SnackBarBehavior.floating);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
