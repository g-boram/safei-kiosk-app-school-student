// lib/features/emotion/view/emotion_home_screen.dart

import 'package:flutter/material.dart';

import '../component/emotion_daily_record_section.dart';
import '../component/emotion_status_card.dart';
import '../data/mock_emotion_records.dart';

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

          const SizedBox(height: 30),

          EmotionDailyRecordSection(records: createMockEmotionRecords()),
        ],
      ),
    );
  }
}
