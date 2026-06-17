// lib/features/emotion/utils/emotion_palette.dart

import 'package:flutter/material.dart';

class EmotionPalette {
  static Color byCode(String code) {
    switch (code.trim().toLowerCase()) {
      case 'happiness':
        return const Color(0xFF4C4CD6);
      case 'surprise':
        return const Color(0xFF00A3FF);
      case 'fear':
        return const Color(0xFF7B61FF);
      case 'disgust':
        return const Color(0xFF2DBE60);
      case 'sadness':
        return const Color(0xFF3D5AFE);
      case 'anger':
        return const Color(0xFFFF5252);
      default:
        return const Color(0xFF4C4CD6);
    }
  }
}
