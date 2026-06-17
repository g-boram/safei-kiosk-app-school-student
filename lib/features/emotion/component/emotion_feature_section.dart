import 'package:flutter/cupertino.dart';

import 'feature_card.dart';

class EmotionFeatureSection extends StatelessWidget {
  const EmotionFeatureSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FeatureCard(title: '감정 리포트', enabled: false),
        SizedBox(height: 12),
        FeatureCard(title: '감정 통계', enabled: false),
      ],
    );
  }
}
