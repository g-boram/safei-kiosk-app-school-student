# Storage 시스템 가이드

## 개요

프로젝트에서는 저장되는 데이터의 성격에 따라 두 가지 저장소를 사용한다.

| 저장소                  | 용도                    |
| -------------------- | --------------------- |
| FlutterSecureStorage | 인증 정보, 토큰 등 민감 정보     |
| SharedPreferences    | 사용자 설정, UI 상태 등 일반 정보 |

---

# 현재 구조

```txt
lib/core/storage/
 ├─ auth_storage.dart
 ├─ local_storage.dart
 └─ storage_provider.dart
```

---

# FlutterSecureStorage

## 목적

민감한 인증 정보를 안전하게 저장하기 위한 저장소

Android에서는 EncryptedSharedPreferences 기반으로 암호화되어 저장된다.

현재 저장 대상

```txt
accessToken
refreshToken
username
```

예시

```dart
await authStorage.writeTokens(
  accessToken: accessToken,
  refreshToken: refreshToken,
);
```

---

## 특징

### 장점

* 암호화 저장
* 인증 정보 보관에 적합
* 앱 재실행 후에도 유지

### 단점

* 일반 설정 저장에는 과함
* 읽기/쓰기 속도가 SharedPreferences보다 느림

---

## 사용 예시

```dart
final authStorage = ref.read(authStorageProvider);

await authStorage.writeAccessToken(token);

final tokens = await authStorage.readTokens();
```

---

# SharedPreferences

## 목적

사용자 설정 및 일반 상태 저장

민감하지 않은 데이터를 저장하기 위해 사용한다.

현재 저장 대상

```txt
PROFILE_ICON
APP_THEME_MODE
```

향후 저장 가능

```txt
LANGUAGE
TUTORIAL_COMPLETED
LAST_SELECTED_MENU
NOTIFICATION_ENABLED
```

---

## 특징

### 장점

* 사용이 간단함
* 읽기/쓰기 속도가 빠름
* UI 설정 저장에 적합

### 단점

* 암호화되지 않음
* 토큰 저장 금지

---

## 사용 예시

```dart
await localStorage.writeProfileIcon(
  'assets/icons/profile/profile_01.svg',
);
```

```dart
final icon = await localStorage.readProfileIcon();
```

---

# auth_storage.dart

## 역할

FlutterSecureStorage를 이용하여 인증 정보를 관리한다.

관리 대상

```txt
accessToken
refreshToken
username
```

주요 함수

```dart
writeTokens()
readTokens()
writeUsername()
readUsername()
clear()
```

---

## 동작 예시

로그인 성공

```txt
로그인 성공
→ accessToken 저장
→ refreshToken 저장
→ username 저장
```

로그아웃

```txt
로그아웃
→ accessToken 삭제
→ refreshToken 삭제
→ username 삭제
```

---

# local_storage.dart

## 역할

SharedPreferences를 이용하여 일반 설정을 관리한다.

관리 대상

```txt
PROFILE_ICON
APP_THEME_MODE
```

---

## 주요 함수

프로필 아이콘

```dart
readProfileIcon()
writeProfileIcon()
```

테마 설정

```dart
readThemeMode()
writeThemeMode()
```

---

## 동작 예시

프로필 아이콘 변경

```txt
아이콘 선택
→ SharedPreferences 저장
→ 앱 종료
→ 앱 재실행
→ 저장된 아이콘 복원
```

---

# storage_provider.dart

## 역할

Storage 객체를 Riverpod에서 사용할 수 있도록 Provider 등록

현재 제공 Provider

```dart
flutterSecureStorageProvider
authStorageProvider
localStorageProvider
```

---

## 사용 예시

```dart
final authStorage =
    ref.read(authStorageProvider);
```

```dart
final localStorage =
    ref.read(localStorageProvider);
```

---

# 프로필 아이콘 저장 구조

## 저장 위치

```txt
SharedPreferences
```

저장 Key

```txt
PROFILE_ICON
```

저장 값

```txt
assets/icons/profile/satisfaction.svg
```

---

## 저장 흐름

```txt
아이콘 선택
→ ProfileIconController
→ LocalStorage.writeProfileIcon()
→ SharedPreferences 저장
```

---

## 복원 흐름

```txt
앱 실행
→ ProfileIconController.initialize()
→ LocalStorage.readProfileIcon()
→ SharedPreferences 조회
→ 화면 표시
```

---

# 테마 저장 구조

## 저장 위치

```txt
SharedPreferences
```

저장 Key

```txt
APP_THEME_MODE
```

저장 값

```txt
light
dark
```

---

## 저장 흐름

```txt
다크모드 선택
→ ThemeController
→ LocalStorage.writeThemeMode('dark')
→ SharedPreferences 저장
```

---

## 복원 흐름

```txt
앱 시작
→ ThemeController.initialize()
→ APP_THEME_MODE 조회
→ ThemeMode 적용
```

---

# 인증 정보 저장 구조

## 저장 위치

```txt
FlutterSecureStorage
```

저장 Key

```txt
accessToken
refreshToken
username
```

---

## 저장 흐름

```txt
로그인 성공
→ AuthStorage.writeTokens()
→ FlutterSecureStorage 저장
```

---

## 복원 흐름

```txt
앱 시작
→ AuthController
→ AuthStorage.readTokens()
→ 인증 상태 복원
```

---

# 데이터 분리 원칙

## FlutterSecureStorage 사용

다음 데이터는 반드시 SecureStorage 사용

```txt
accessToken
refreshToken
JWT
인증 관련 정보
```

---

## SharedPreferences 사용

다음 데이터는 SharedPreferences 사용

```txt
프로필 아이콘
테마 설정
언어 설정
튜토리얼 완료 여부
최근 선택 메뉴
```

---

# 개발 규칙

## 인증 정보

허용

```dart
authStorage.writeTokens(...)
```

비허용

```dart
SharedPreferences.setString(
  'accessToken',
  token,
);
```

---

## 일반 설정

허용

```dart
localStorage.writeProfileIcon(...)
localStorage.writeThemeMode(...)
```

비허용

```dart
FlutterSecureStorage.write(
  key: 'PROFILE_ICON',
  value: icon,
);
```

---

# 최종 원칙

```txt
민감한 정보
→ FlutterSecureStorage

일반 설정
→ SharedPreferences
```

현재 프로젝트 기준

```txt
AuthStorage
→ 인증 전용

LocalStorage
→ 설정 전용
```

구조를 유지하며 개발한다.
