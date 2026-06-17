import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';

class EmotionStatusCard extends StatelessWidget {
  final bool hasTodayEmotion;
  final String emotionName;
  final int emotionLevel;
  final String checkedTime;

  const EmotionStatusCard({
    super.key,
    required this.hasTodayEmotion,
    required this.emotionName,
    required this.emotionLevel,
    required this.checkedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: hasTodayEmotion
            ? Column(
                children: [
                  const Text(
                    '오늘 감정체크 완료',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Text('$emotionName $emotionLevel단계'),

                  Text(checkedTime),
                ],
              )
            : Column(
                children: [
                  const Text(
                    '오늘 감정체크',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text('아직 감정을 기록하지 않았어요'),

                  const SizedBox(height: 20),

                  FilledButton(
                    onPressed: () {
                      context.go(AppPath.emotionSelect);
                    },
                    child: const Text('감정체크 시작하기'),
                  ),
                ],
              ),
      ),
    );
  }
}
