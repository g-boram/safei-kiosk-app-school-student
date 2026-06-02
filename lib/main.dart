import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:safei_kiosk_app_school_student/app.dart';

void main() async {
  // ✔️ 다국어 처리
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ko'), Locale('en')],
      path: 'assets/translations', // 다국어 처리 ko,en json 작성
      fallbackLocale: const Locale('ko'),
      child: const ProviderScope(child: App()),
    ),
  );
}
