import 'package:flutter/material.dart';

import '../../core/theme/app_color_extension.dart';

class CommonDimDialog extends StatelessWidget {
  final Widget child;
  final double width;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  const CommonDimDialog({
    super.key,
    required this.child,
    this.width = 420,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double width = 420,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) {
        return CommonDimDialog(width: width, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Container(
          width: width,
          padding: padding,
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: borderRadius,
            border: Border.all(color: context.colors.border),
          ),
          child: child,
        ),
      ),
    );
  }
}
