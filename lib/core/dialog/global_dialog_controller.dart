// lib/core/dialog/global_dialog_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

final globalDialogControllerProvider =
    StateNotifierProvider<GlobalDialogController, GlobalDialogState?>(
      (ref) => GlobalDialogController(),
    );

class GlobalDialogController extends StateNotifier<GlobalDialogState?> {
  GlobalDialogController() : super(null);

  void showLoginRequired() {
    state = const GlobalDialogState(
      title: '로그인이 필요합니다',
      message: '프로필 화면은 로그인 후 이용할 수 있습니다.',
      confirmText: '로그인하기',
      type: GlobalDialogType.loginRequired,
    );
  }

  void showMessage({
    required String title,
    required String message,
    String confirmText = '확인',
  }) {
    state = GlobalDialogState(
      title: title,
      message: message,
      confirmText: confirmText,
      type: GlobalDialogType.normal,
    );
  }

  void clear() {
    state = null;
  }
}

class GlobalDialogState {
  final String title;
  final String message;
  final String confirmText;
  final GlobalDialogType type;

  const GlobalDialogState({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.type,
  });
}

enum GlobalDialogType { loginRequired, normal }
