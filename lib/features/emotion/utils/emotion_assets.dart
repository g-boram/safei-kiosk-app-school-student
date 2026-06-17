// lib/features/emotion/utils/emotion_assets.dart

class EmotionAssets {
  static String? imageByCode(String code) {
    final value = code.trim().toLowerCase();

    switch (value) {
      case 'happiness':
      case 'surprise':
      case 'fear':
      case 'disgust':
      case 'sadness':
      case 'anger':
      case 'anticipation':
      case 'trust':
      case 'satisfaction':
      case 'joy':
        return 'assets/images/emotion/$value.png';
      default:
        return null;
    }
  }
}
