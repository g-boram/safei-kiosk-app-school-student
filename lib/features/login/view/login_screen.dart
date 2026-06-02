// lib/features/login/view/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          ref
              .read(authControllerProvider.notifier)
              .login(accessToken: 'sample-token', autoLogin: true);
        },
        child: const Text('로그인 테스트'),
      ),
    );
  }
}
