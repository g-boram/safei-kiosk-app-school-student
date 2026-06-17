// lib/features/emotion/view/emotion_level_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/dialog/global_dialog_controller.dart';
import '../../../core/router/app_routes.dart';
import '../component/emotion_step_description_card.dart';
import '../component/emotion_step_progress.dart';
import '../provider/emotion_providers.dart';
import '../repository/emotion_repository.dart';

class EmotionLevelScreen extends ConsumerStatefulWidget {
  const EmotionLevelScreen({super.key, required this.emotionId});

  final String emotionId;

  @override
  ConsumerState<EmotionLevelScreen> createState() => _EmotionLevelScreenState();
}

class _EmotionLevelScreenState extends ConsumerState<EmotionLevelScreen> {
  int _level = 1;
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final repository = ref.read(emotionRepositoryProvider);

      final response = await repository.registEmotion(
        emotionId: widget.emotionId,
        step: _level,
      );

      if (!mounted) return;

      ref
          .read(globalDialogControllerProvider.notifier)
          .showMessage(
            title: response.isSuccess ? '감정체크 완료' : '감정체크 실패',
            message: response.userMessage(),
          );

      if (response.isSuccess) {
        context.go(AppPath.home);
      }
    } catch (_) {
      if (!mounted) return;

      ref
          .read(globalDialogControllerProvider.notifier)
          .showMessage(
            title: '오류',
            message: '일시적인 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.',
          );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final emotionAsync = ref.watch(emotionDetailProvider(widget.emotionId));

    return Padding(
      padding: const EdgeInsets.all(20),
      child: emotionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('감정 정보를 불러오지 못했어요.'),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  ref.invalidate(emotionDetailProvider(widget.emotionId));
                },
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (emotion) {
          final accent = Color(emotion.color);
          final stepList = emotion.steps[_level] ?? const <String>[];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: emotion.name,
                      style: TextStyle(
                        color: accent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: '을\n얼마나 느끼고 있나요?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              EmotionStepProgress(
                value: _level,
                color: accent,
                image: emotion.image,
                onChanged: (value) {
                  setState(() {
                    _level = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(5, (index) {
                  final step = index + 1;
                  final selected = step == _level;

                  return TextButton(
                    onPressed: () {
                      setState(() {
                        _level = step;
                      });
                    },
                    child: Text(
                      '$step단계',
                      style: TextStyle(
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: selected ? accent : Colors.black87,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: EmotionStepDescriptionCard(descriptions: stepList),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSubmitting
                          ? null
                          : () {
                              context.pop();
                            },
                      child: const Text('감정 다시 선택'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('완료'),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
