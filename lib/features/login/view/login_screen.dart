// lib/features/login/view/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/dio/api_state.dart';
import '../../../core/router/app_routes.dart';
import '../controller/login_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // 이메일 입력값 관리
  final _emailController = TextEditingController();

  // 비밀번호 입력값 관리
  final _passwordController = TextEditingController();

  // 비밀번호 표시/숨김 여부
  // true  : ●●●●● 로 표시
  // false : 실제 문자열 표시
  bool _obscurePassword = true;

  // 사용자가 입력을 시작했는지 여부
  // 처음 화면 진입 시에는 에러를 보여주지 않기 위해 사용
  bool _emailTouched = false;
  bool _passwordTouched = false;

  @override
  void initState() {
    super.initState();

    // TextField 값이 변경될 때마다 호출
    _emailController.addListener(_onInputChanged);
    _passwordController.addListener(_onInputChanged);
  }

  /// 입력값 변경 감지
  ///
  /// 사용자가 입력을 시작하면 touched 상태를 true로 변경
  /// 이후부터는 유효성 검사 에러를 표시
  void _onInputChanged() {
    setState(() {
      if (_emailController.text.isNotEmpty) {
        _emailTouched = true;
      }

      if (_passwordController.text.isNotEmpty) {
        _passwordTouched = true;
      }
    });
  }

  /// 이메일 형식 검증
  ///
  /// 예)
  /// test@test.com -> true
  /// test        -> false
  /// abc@        -> false
  bool get _isValidEmail {
    final email = _emailController.text.trim();

    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

    return emailRegex.hasMatch(email);
  }

  /// 비밀번호 유효성 검사
  ///
  /// 현재 정책:
  /// 8글자 이상 입력 시 통과
  bool get _isValidPassword {
    return _passwordController.text.trim().length >= 8;
  }

  /// 로그인 가능 여부
  ///
  /// 이메일과 비밀번호가 모두 유효해야 true
  bool get _canLogin {
    return _isValidEmail && _isValidPassword;
  }

  @override
  void dispose() {
    // 등록한 Listener 제거
    // 메모리 누수 방지
    _emailController.removeListener(_onInputChanged);
    _passwordController.removeListener(_onInputChanged);

    // Controller 정리
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  /// 로그인 요청
  ///
  /// 1. 입력값 검증
  /// 2. Controller 로그인 호출
  /// 3. 성공 시 홈 화면 이동
  Future<void> _login() async {
    // 유효성 검사 실패 시 종료
    if (!_canLogin) return;

    final loginId = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // 서버 요구사항
    final loginTy = 'STUDENT';

    // Riverpod Controller 호출
    final success = await ref
        .read(loginControllerProvider.notifier)
        .loginWithEmail(loginId: loginId, password: password, loginTy: loginTy);

    // 비동기 처리 후 화면이 이미 종료되었을 수 있음
    // dispose 된 화면에서 context 사용 방지
    if (!mounted) return;

    // 로그인 성공 시 홈 이동
    if (success) {
      context.go(AppPath.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);

    // 현재 API 로딩 상태 확인
    final isLoading = loginState.status == ApiStatus.loading;

    // 이메일 에러 표시 여부
    // 입력을 시작했고 형식이 틀렸을 때만 표시
    final showEmailError = _emailTouched && !_isValidEmail;

    // 비밀번호 에러 표시 여부
    final showPasswordError = _passwordTouched && !_isValidPassword;

    // 로그인 버튼 활성화 여부
    final buttonEnabled = _canLogin && !isLoading;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '로그인',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 32),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.visiblePassword,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: '이메일',
                  hintText: '이메일을 입력해주세요',
                  border: const OutlineInputBorder(),

                  // 인풋 오른쪽 작은 에러 문구
                  suffixIcon: showEmailError
                      ? const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Center(
                            widthFactor: 1,
                            child: Text(
                              '이메일형식을 확인해주세요',
                              style: TextStyle(color: Colors.red, fontSize: 11),
                            ),
                          ),
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  hintText: '비밀번호를 입력해주세요',
                  border: const OutlineInputBorder(),

                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showPasswordError)
                        const Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Text(
                            '8글자 이상 입력해주세요',
                            style: TextStyle(color: Colors.red, fontSize: 11),
                          ),
                        ),

                      IconButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ],
                  ),
                ),
                onSubmitted: (_) {
                  if (buttonEnabled) {
                    _login();
                  }
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: buttonEnabled ? _login : null,
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('로그인'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
