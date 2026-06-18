// lib/features/setting/component/setting_section.dart

import 'package:flutter/material.dart';

/// 설정 화면에서 영역을 구분하는 공통 섹션 카드
///
/// 예)
/// - 화면 설정
/// - 언어 설정
/// - 앱 정보
class SettingSection extends StatelessWidget {
  const SettingSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 섹션 제목
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // 섹션 내부 항목
            ...children,
          ],
        ),
      ),
    );
  }
}
