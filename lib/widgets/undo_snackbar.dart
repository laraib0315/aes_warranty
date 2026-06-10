import 'package:flutter/material.dart';

class UndoSnackbar {
  static void show({
    required BuildContext context,
    required String message,
    required VoidCallback onUndo,
    Duration duration = const Duration(seconds: 5),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: onUndo,
        ),
        duration: duration,
      ),
    );
  }
}
