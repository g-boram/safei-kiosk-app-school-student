// lib/features/emotion/view/emotion_select_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../component/emotion_name_card.dart';
import '../provider/emotion_providers.dart';

class EmotionSelectScreen extends ConsumerWidget {
  const EmotionSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emotionListAsync = ref.watch(emotionListProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: emotionListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64),
              const SizedBox(height: 16),
              const Text('감정 목록을 불러오지 못했어요.'),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  ref.invalidate(emotionListProvider);
                },
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (items) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Text(
                '오늘의 감정은 어떤가요?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.82,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return EmotionNameCard(
                      name: item.name,
                      image: item.image,
                      color: item.color,
                      onTap: () {
                        context.pushNamed(
                          AppRoute.emotionLevel,
                          pathParameters: {'emotionId': item.id},
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
