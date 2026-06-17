// lib/features/emotion/component/emotion_step_description_card.dart

import 'package:flutter/material.dart';

class EmotionStepDescriptionCard extends StatelessWidget {
  const EmotionStepDescriptionCard({super.key, required this.descriptions});

  final List<String> descriptions;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: descriptions.isEmpty
          ? const Center(child: Text('단계 설명이 없습니다.'))
          : ListView.separated(
              itemCount: descriptions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final text = descriptions[index];

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•  '),
                    Expanded(
                      child: Text(
                        text,
                        style: const TextStyle(fontSize: 15, height: 1.5),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
