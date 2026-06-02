# SAFE-i Student App

학생용 모바일 애플리케이션 프로젝트입니다.

## 기술 스택

* Flutter
* Riverpod
* GoRouter
* EasyLocalization
* Flutter Secure Storage

---

## 주요 기능

### 인증

* 로그인
* 로그아웃
* 자동 로그인
* 로그인 상태 기반 화면 접근 제어

### 공통 기능

* 다국어 지원 (한국어 / 영어)
* 테마 관리
* 전역 라우팅
* 공통 레이아웃

---

## 프로젝트 구조

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

## 인증 흐름

```txt
앱 실행
 ↓
자동 로그인 확인
 ↓
로그인 상태 확인
 ↓
Home 또는 Login 이동
```

---

## 라우팅 구조

```txt
ShellRoute
│
├ AppShell
│ ├ AppBar
│ └ BottomNavigationBar
│
└ Child Screen
   ├ HomeScreen
   └ LoginScreen
```

---

## 실행 방법

### 패키지 설치

```bash
flutter pub get
```

### 실행

```bash
flutter run
```

---

## 개발 문서

프로젝트 설계 및 구조 문서는 docs 폴더를 참고합니다.

```txt
docs/
```
