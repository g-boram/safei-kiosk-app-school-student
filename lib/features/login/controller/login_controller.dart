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
  // Riverpod Ref 객체
  // Provider들을 읽거나 호출할 때 사용
  LoginController({required this.ref})
    : super(const ApiState<LoginSuccessData>.idle());

  final Ref ref;

  /// 이메일 로그인 처리
  ///
  /// 반환값
  /// true  : 로그인 성공
  /// false : 로그인 실패
  Future<bool> loginWithEmail({
    required String loginId,
    required String password,
    required String loginTy,
  }) async {
    // API 호출 시작 상태로 변경
    // 화면에서는 loading 상태를 보고 로딩바를 표시할 수 있음
    state = const ApiState<LoginSuccessData>.loading();

    try {
      // Repository 가져오기
      final repository = ref.read(loginRepositoryProvider);

      // 로그인 API 호출
      final response = await repository.login(
        LoginRequest(loginId: loginId, crtfcKey: password, loginTy: loginTy),
      );

      // 서버 메시지 추출
      final message = response.firstMessage ?? '로그인되었습니다.';

      // =========================
      // 로그인 성공
      // =========================
      if (response.isSuccess && response.data != null) {
        final user = response.data!;

        // 상태를 성공으로 변경
        state = ApiState<LoginSuccessData>(
          status: ApiStatus.success,
          data: user,
          message: message,
        );

        // 토큰 저장
        // AuthController에서 SecureStorage 저장 처리
        await ref
            .read(authControllerProvider.notifier)
            .login(accessToken: user.accessToken, autoLogin: true);

        // 성공 모달 제거
        // 화면에서 success=true를 받아
        // 바로 Home으로 이동하게 됨

        return true;
      }

      // =========================
      // 로그인 실패 (비밀번호 오류 등)
      // =========================
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
      // =========================
      // 네트워크 또는 서버 오류
      // =========================

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
      // =========================
      // 예상하지 못한 오류
      // =========================

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

  /// DioException 응답에서
  /// 서버가 내려준 메시지 추출
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
