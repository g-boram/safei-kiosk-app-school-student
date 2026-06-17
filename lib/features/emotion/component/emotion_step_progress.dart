// lib/features/emotion/component/emotion_step_progress.dart

import 'package:flutter/material.dart';

class EmotionStepProgress extends StatelessWidget {
  const EmotionStepProgress({
    super.key,
    required this.value,
    required this.color,
    required this.onChanged,
    this.image,
  });

  final int value;
  final Color color;
  final ValueChanged<int> onChanged;
  final String? image;

  static const _max = 5;

  void _setFromDx({
    required BuildContext context,
    required Offset localPosition,
  }) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final width = box.size.width;
    final dx = localPosition.dx.clamp(0, width);
    final step = (dx / width * _max).ceil().clamp(1, _max);

    onChanged(step);
  }

  @override
  Widget build(BuildContext context) {
    const height = 56.0;
    const thumbSize = 64.0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) {
        _setFromDx(context: context, localPosition: details.localPosition);
      },
      onHorizontalDragUpdate: (details) {
        _setFromDx(context: context, localPosition: details.localPosition);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final stepWidth = width / _max;
          final fillWidth = stepWidth * value;
          final thumbLeft = (stepWidth * (value - 0.5) - thumbSize / 2).clamp(
            0.0,
            width - thumbSize,
          );

          return SizedBox(
            height: thumbSize,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: height,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: fillWidth,
                  height: height,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                ...List.generate(_max, (index) {
                  final x = stepWidth * (index + 0.5);

                  return Positioned(
                    left: x - 2,
                    bottom: 4,
                    child: Container(
                      width: 4,
                      height: 14,
                      decoration: BoxDecoration(
                        color: index < value
                            ? Colors.white
                            : color.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  );
                }),
                Positioned(
                  left: thumbLeft,
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 8),
                      ],
                    ),
                    child: image == null
                        ? Icon(Icons.mood, color: color)
                        : Image.asset(image!, fit: BoxFit.contain),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
