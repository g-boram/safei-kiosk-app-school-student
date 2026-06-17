// lib/features/emotion/component/emotion_name_card.dart

import 'package:flutter/material.dart';

class EmotionNameCard extends StatelessWidget {
  const EmotionNameCard({
    super.key,
    required this.name,
    required this.onTap,
    this.image,
    this.color,
  });

  final String name;
  final String? image;
  final int? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = Color(color ?? 0xFF4C4CD6);

    return Material(
      color: const Color(0xFFF7F8FA),
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: image == null
                      ? _FallbackEmotionIcon(color: accent)
                      : Image.asset(
                          image!,
                          width: 86,
                          height: 86,
                          fit: BoxFit.contain,
                        ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: onTap,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: accent,
                    side: BorderSide(color: accent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FallbackEmotionIcon extends StatelessWidget {
  const _FallbackEmotionIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.4), width: 3),
      ),
      child: Icon(Icons.mood, color: color, size: 40),
    );
  }
}
