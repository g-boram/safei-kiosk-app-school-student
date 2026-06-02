
# docs/01_project_structure.md

# Safei Student App - 초기 프로젝트 구조

## 프로젝트 목적

학생용 Flutter 앱 개발

초기 목표

* 로그인 기능
* 자동 로그인
* 홈 화면
* 다국어 지원
* 테마 관리
* 전역 라우팅 관리

---

## 사용 기술

### 상태관리

```txt
Riverpod
```

### 라우팅

```txt
GoRouter
```

### 다국어

```txt
EasyLocalization
```

### 저장소

```txt
Flutter Secure Storage
```

### 디자인

```txt
Material 3
Pretendard Font
```

---

# 프로젝트 구조

```txt
lib
│
├ main.dart
├ app.dart
│
├ common
│ └ theme
│
├ core
│ ├ auth
│ ├ router
│ └ layout
│
└ features
   ├ splash
   ├ login
   └ home
```

---

# main.dart 역할

앱 실행 전 초기화 담당

### 담당 기능

```txt
WidgetsFlutterBinding 초기화

EasyLocalization 초기화

ProviderScope 등록

App 실행
```

예시

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  runApp(...);
}
```

---

# app.dart 역할

전역 설정 관리

### 담당 기능

```txt
Theme

Localization

Router

Auth 상태 구독
```

예시

```txt
MaterialApp.router
```

를 생성하는 최상위 영역

---

# 인증(Auth) 구조

## 상태 종류

```dart
AuthStatus
```

### unknown

앱 시작 직후

자동 로그인 여부 확인 중

### unauthenticated

로그인 안 된 상태

### authenticated

로그인 완료 상태

---

# 로그인 정책

## 1. 로그인 한 적 없음

```txt
앱 실행
↓
로그인 화면 이동
```

---

## 2. 로그인 성공

```txt
로그인
↓
홈 이동
```

앱 종료 전까지 유지

---

## 3. 자동 로그인 체크

```txt
로그인
↓
토큰 저장
↓
앱 재실행
↓
자동 로그인
```

---

# AuthController

역할

```txt
로그인

로그아웃

자동 로그인 복원

상태 변경
```

Provider

```dart
authControllerProvider
```

---

# Secure Storage 저장 정보

| Key          | 설명        |
| ------------ | --------- |
| ACCESS_TOKEN | 로그인 토큰    |
| AUTO_LOGIN   | 자동 로그인 여부 |

---

# 라우팅 구조

사용 라이브러리

```txt
GoRouter
```

---

# Router 파일 구조

```txt
core/router
│
├ app_router.dart
├ app_routes.dart
└ nav_ctx.dart
```

---

# app_router.dart

역할

```txt
로그인 상태 확인

redirect 처리

GoRouter 생성
```

---

# app_routes.dart

역할

```txt
화면 등록
```

예시

```txt
/
↓
HomeScreen

/login
↓
LoginScreen
```

---

# AppRoute

라우트 이름 관리

```dart
abstract final class AppRoute {
  static const home = 'home';
  static const login = 'login';
}
```

---

# AppPath

라우트 경로 관리

```dart
abstract final class AppPath {
  static const home = '/';
  static const login = '/login';
}
```

---

# ShellRoute 사용

사용 이유

```txt
상단 메뉴

하단 메뉴

공통 레이아웃

전역 UI 관리
```

---

## 구조

```txt
AppShell
│
├ AppBar
├ BottomNavigationBar
│
└ Child
   ├ HomeScreen
   └ LoginScreen
```

---

# AppShell 역할

전역 UI 담당

### 상단 영역

```txt
로고

다국어 변경

테마 변경

로그인 버튼
```

### 하단 영역

```txt
네비게이션 버튼
```

---

# 현재 화면 구조

```txt
features
│
├ login
│ └ LoginScreen
│
└ home
   └ HomeScreen
```

---

# LoginScreen

현재 역할

```txt
로그인 테스트

AuthController.login 호출
```

---

# HomeScreen

현재 역할

```txt
홈 화면

로그아웃 테스트

AuthController.logout 호출
```

---

# 전역 Navigator

파일

```txt
nav_ctx.dart
```

역할

```txt
Context 없이도

다이얼로그

화면 이동

Snackbar

사용 가능
```

---

# 향후 추가 예정 기능

## Splash 화면

```txt
앱 시작
↓
Splash
↓
자동 로그인 확인
↓
Home 또는 Login
```

---

## Theme 관리

```txt
Light

Dark

System
```

---

## 다국어

```txt
한국어

영어
```

---

## API 통신

```txt
Dio
```

Provider 분리 예정

---

## 학생 기능

```txt
공지사항

출결

시간표

급식

예약

프로필
```

---

# 개발 원칙

### main.dart

초기화만 담당

---

### app.dart

전역 설정만 담당

---

### feature

화면 단위 관리

---

### core

공통 기능 관리

---

### common

디자인 시스템 관리

---

### 라우팅

GoRouter 사용

---

### 상태관리

Riverpod 사용

---

### 로그인

AuthController 단일 진입점 사용

---

### 전역 UI

ShellRoute + AppShell 사용

---
