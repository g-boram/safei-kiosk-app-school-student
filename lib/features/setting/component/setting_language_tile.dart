// lib/features/setting/component/setting_language_tile.dart

import 'package:flutter/material.dart';

/// 언어 설정 항목
///
/// 현재는 UI만 구성하고,
/// 추후 다국어 변경 로직을 연결합니다.
class SettingLanguageTile extends StatelessWidget {
  const SettingLanguageTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.language),
      title: const Text('언어'),
      subtitle: const Text('한국어'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: 다국어 변경 기능 연결
      },
    );
  }
}
