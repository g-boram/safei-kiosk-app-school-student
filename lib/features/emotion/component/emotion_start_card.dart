// lib/features/emotion/component/emotion_start_card.dart

import 'package:flutter/material.dart';

class EmotionStartCard extends StatelessWidget {
  const EmotionStartCard({super.key, required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.mood, size: 96),
              const SizedBox(height: 24),
              const Text(
                '오늘의 감정을 체크해볼까요?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                '지금 느끼는 감정을 선택하고,\n얼마나 느끼는지 단계로 표현해 주세요.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: onStart,
                  child: const Text('감정체크 시작하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
