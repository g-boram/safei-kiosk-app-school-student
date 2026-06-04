// lib/core/dialog/global_alert_dialog.dart

import 'package:flutter/material.dart';

class GlobalAlertDialog extends StatelessWidget {
  const GlobalAlertDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.onConfirm,
  });

  final String title;
  final String message;
  final String confirmText;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Text(message, style: const TextStyle(fontSize: 15, height: 1.4)),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(onPressed: onConfirm, child: Text(confirmText)),
        ),
      ],
    );
  }
}
