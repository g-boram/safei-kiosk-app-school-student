// lib/features/setting/component/setting_info_tile.dart

import 'package:flutter/material.dart';

/// 설정 화면에서 재사용하는 일반 정보 항목
///
/// 앱 버전, 이용 안내, 고객센터 등
/// 단순 정보성 메뉴에 사용합니다.
class SettingInfoTile extends StatelessWidget {
  const SettingInfoTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.showArrow = false,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool showArrow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: showArrow ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }
}
