// lib/features/emotion/view/emotion_home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../component/emotion_feature_section.dart';
import '../component/emotion_history_section.dart';
import '../component/emotion_start_card.dart';
import '../component/emotion_status_card.dart';

class EmotionHomeScreen extends StatelessWidget {
  const EmotionHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// TODO: API 연동 예정
    const bool hasTodayEmotion = false;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          EmotionStatusCard(
            hasTodayEmotion: hasTodayEmotion,
            emotionName: '행복',
            emotionLevel: 4,
            checkedTime: '09:12',
          ),

          const SizedBox(height: 20),

          const EmotionHistorySection(),

          const SizedBox(height: 20),

          const _ComingSoonCard(title: '감정 리포트'),

          const SizedBox(height: 12),

          const _ComingSoonCard(title: '감정 통계'),
        ],
      ),
    );
  }
}

class _ComingSoonCard extends StatelessWidget {
  final String title;

  const _ComingSoonCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.construction),
        title: Text(title),
        subtitle: const Text('준비중입니다'),
      ),
    );
  }
}
