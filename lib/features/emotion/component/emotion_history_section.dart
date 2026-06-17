import 'package:flutter/material.dart';
import 'package:safei_kiosk_app_school_student/core/theme/app_color_extension.dart';

class EmotionHistorySection extends StatelessWidget {
  const EmotionHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          return Container(
            width: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: context.colors.gray0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('월'),
                const SizedBox(height: 8),
                const Icon(Icons.mood),
                const SizedBox(height: 8),
                Text('${index + 1}단계'),
              ],
            ),
          );
        },
      ),
    );
  }
}
