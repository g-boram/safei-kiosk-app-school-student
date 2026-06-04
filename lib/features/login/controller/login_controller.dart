// lib/features/login/controller/login_controller.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/dialog/global_dialog_controller.dart';
import '../../../core/dio/api_state.dart';
import '../model/login_request.dart';
import '../model/login_response.dart';
import '../repository/login_repository.dart';

final loginControllerProvider =
    StateNotifierProvider<LoginController, ApiState<LoginSuccessData>>((ref) {
      return LoginController(ref: ref);
    });

class LoginController extends StateNotifier<ApiState<LoginSuccessData>> {
  LoginController({required this.ref})
    : super(const ApiState<LoginSuccessData>.idle());

  final Ref ref;

  Future<bool> loginWithEmail({
    required String email,
    required String password,
  }) async {
    state = const ApiState<LoginSuccessData>.loading();

    try {
      final repository = ref.read(loginRepositoryProvider);

      final response = await repository.login(
        LoginRequest(loginId: email, crtfcKey: password),
      );

      final message = response.firstMessage ?? '로그인되었습니다.';

      if (response.isSuccess && response.data != null) {
        final user = response.data!;

        state = ApiState<LoginSuccessData>(
          status: ApiStatus.success,
          data: user,
          message: message,
        );

        await ref
            .read(authControllerProvider.notifier)
            .login(accessToken: user.accessToken, autoLogin: true);

        ref
            .read(globalDialogControllerProvider.notifier)
            .showMessage(title: '로그인 성공', message: message);

        return true;
      }

      state = ApiState<LoginSuccessData>(
        status: ApiStatus.error,
        message: message,
        error: Exception('login failed'),
      );

      ref
          .read(globalDialogControllerProvider.notifier)
          .showMessage(title: '로그인 실패', message: message);

      return false;
    } on DioException catch (e) {
      final message = _extractMessageFromDio(e) ?? '네트워크 오류가 발생했습니다.';

      state = ApiState<LoginSuccessData>(
        status: ApiStatus.error,
        message: message,
        error: e,
      );

      ref
          .read(globalDialogControllerProvider.notifier)
          .showMessage(title: '로그인 실패', message: message);

      return false;
    } catch (e) {
      state = ApiState<LoginSuccessData>(
        status: ApiStatus.error,
        message: '알 수 없는 오류가 발생했습니다.',
        error: e,
      );

      ref
          .read(globalDialogControllerProvider.notifier)
          .showMessage(title: '로그인 실패', message: '알 수 없는 오류가 발생했습니다.');

      return false;
    }
  }

  String? _extractMessageFromDio(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final messageObj = data['message'];

      if (messageObj is Map<String, dynamic>) {
        final messages = messageObj['messages'];

        if (messages is List && messages.isNotEmpty) {
          return messages.first.toString();
        }
      }
    }

    return null;
  }
}
