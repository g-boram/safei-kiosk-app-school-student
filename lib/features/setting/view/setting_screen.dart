// lib/features/setting/view/setting_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../component/setting_info_tile.dart';
import '../component/setting_language_tile.dart';
import '../component/setting_section.dart';
import '../component/setting_theme_tile.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: const [
        // Text('설정', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),

        SettingSection(title: '화면 설정', children: [SettingThemeTile()]),

        SizedBox(height: 10),

        SettingSection(title: '언어 설정', children: [SettingLanguageTile()]),

        SizedBox(height: 10),

        SettingSection(
          title: '앱 정보',
          children: [
            SettingInfoTile(
              icon: Icons.info_outline,
              title: '앱 버전',
              subtitle: '1.0.0',
            ),
            SettingInfoTile(
              icon: Icons.help_outline,
              title: '이용 안내',
              subtitle: '서비스 이용 방법을 확인합니다.',
              showArrow: true,
            ),
          ],
        ),
      ],
    );
  }
}
