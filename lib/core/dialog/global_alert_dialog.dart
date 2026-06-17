// lib/core/dialog/global_alert_dialog.dart

import 'package:flutter/material.dart';

import '../../common/dialog/common_dim_dialog.dart';
import '../theme/app_color_extension.dart';
import '../theme/typography.dart';

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
    final hasTitle = title.trim().isNotEmpty;
    final hasMessage = message.trim().isNotEmpty;

    return CommonDimDialog(
      width: 360,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasTitle)
            Text(
              title,
              textAlign: TextAlign.center,
              style: Typo.bodyMBold.copyWith(color: context.colors.textPrimary),
            ),

          if (hasTitle && hasMessage) const SizedBox(height: 12),

          if (hasMessage)
            Text(
              message,
              textAlign: TextAlign.center,
              style: Typo.bodyS.copyWith(
                color: context.colors.textSecondary,
                height: 1.5,
              ),
            ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: onConfirm,
              child: Text(confirmText, style: Typo.bodySBold),
            ),
          ),
        ],
      ),
    );
  }
}
