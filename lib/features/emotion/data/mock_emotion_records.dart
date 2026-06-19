// lib/features/emotion/data/mock_emotion_records.dart

import '../model/emotion_record.dart';

List<EmotionRecord> createMockEmotionRecords() {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return [
    EmotionRecord(
      id: 1,
      date: today,
      time: '08:30',
      emoji: '😊',
      emotionName: '행복',
      level: 4,
      description: '기분이 좋아요',
      memo: '친구랑 인사해서 좋았어요',
    ),
    EmotionRecord(
      id: 2,
      date: today,
      time: '10:20',
      emoji: '😐',
      emotionName: '보통',
      level: 3,
      description: '괜찮아요',
    ),
    EmotionRecord(
      id: 3,
      date: today.subtract(const Duration(days: 1)),
      time: '09:00',
      emoji: '😐',
      emotionName: '보통',
      level: 3,
      description: '평소와 비슷했어요',
    ),
    EmotionRecord(
      id: 4,
      date: today.subtract(const Duration(days: 1)),
      time: '14:30',
      emoji: '😡',
      emotionName: '화남',
      level: 4,
      description: '화가 났어요',
      memo: '친구랑 다퉜어요',
    ),
  ];
}
