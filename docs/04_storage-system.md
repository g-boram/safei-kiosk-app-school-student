# Storage & Authentication 시스템 가이드

## 개요

프로젝트에서는 저장되는 데이터의 성격에 따라 두 가지 저장소를 사용한다.

| 저장소                  | 용도             |
| -------------------- | -------------- |
| FlutterSecureStorage | 인증 정보 및 사용자 정보 |
| SharedPreferences    | 사용자 설정 및 UI 상태 |

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

Android에서는 암호화된 저장소를 사용하며 앱 재실행 후에도 데이터가 유지된다.

현재 저장 대상

```txt
ACCESS_TOKEN
REFRESH_TOKEN
AUTO_LOGIN

USER_ID
USER_NM
LOGIN_ID
EMAIL
INSTT_ID
INSTT_NM
INSTT_TY
USER_SE_CD
```

---

## 특징

### 장점

* 암호화 저장
* 인증 정보 보관에 적합
* 앱 재실행 후에도 유지
* 사용자 정보 복원 가능

### 단점

* 일반 설정 저장에는 과함
* SharedPreferences보다 상대적으로 느림

---

## 사용 예시

```dart
final authStorage = ref.read(authStorageProvider);

await authStorage.writeTokens(
  accessToken: accessToken,
  refreshToken: refreshToken,
);
```

```dart
final tokens = await authStorage.readTokens();
```

---

# SharedPreferences

## 목적

사용자 설정 및 UI 상태 저장

민감하지 않은 데이터를 저장하기 위해 사용한다.

현재 저장 대상

```txt
PROFILE_ICON_<loginId>
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
  loginId,
  'assets/icons/profile/satisfaction.svg',
);
```

```dart
final icon = await localStorage.readProfileIcon(loginId);
```

---

# auth_storage.dart

## 역할

FlutterSecureStorage를 이용하여 인증 정보 및 사용자 정보를 관리한다.

---

## 관리 대상

```txt
ACCESS_TOKEN
REFRESH_TOKEN
AUTO_LOGIN

USER_ID
USER_NM
LOGIN_ID
EMAIL
INSTT_ID
INSTT_NM
INSTT_TY
USER_SE_CD
```

---

## 주요 함수

```dart
writeTokens()
writeAccessToken()
writeRefreshToken()

readTokens()

writeLoginInfo()
readLoginInfo()

clear()
```

---

## 로그인 저장 흐름

```txt
로그인 성공
↓
AuthStorage.writeLoginInfo()
↓
ACCESS_TOKEN 저장
REFRESH_TOKEN 저장
AUTO_LOGIN 저장
사용자 정보 저장
```

---

## 자동로그인 복원 흐름

```txt
앱 실행
↓
AuthController.initialize()
↓
AuthStorage.readLoginInfo()
↓
AUTO_LOGIN 확인
↓
사용자 정보 조회
↓
로그인 상태 복원
```

---

## 로그아웃 흐름

```txt
로그아웃
↓
AuthStorage.clear()
↓
ACCESS_TOKEN 삭제
REFRESH_TOKEN 삭제
AUTO_LOGIN 삭제
사용자 정보 삭제
```

---

# local_storage.dart

## 역할

SharedPreferences를 이용하여 일반 설정을 관리한다.

---

## 관리 대상

```txt
PROFILE_ICON_<loginId>
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

# storage_provider.dart

## 역할

Storage 객체를 Riverpod Provider로 등록한다.

---

## 제공 Provider

```dart
flutterSecureStorageProvider
authStorageProvider
localStorageProvider
```

---

## 사용 예시

```dart
final authStorage = ref.read(authStorageProvider);
```

```dart
final localStorage = ref.read(localStorageProvider);
```

---

# 프로필 아이콘 저장 구조

## 저장 위치

```txt
SharedPreferences
```

---

## 저장 Key

```txt
PROFILE_ICON_<loginId>
```

예시

```txt
PROFILE_ICON_stu101@foxedu.kr
PROFILE_ICON_tea101@foxedu.kr
```

---

## 저장 값

```txt
assets/icons/profile/satisfaction.svg
```

---

## 저장 흐름

```txt
아이콘 선택
↓
ProfileIconController
↓
LocalStorage.writeProfileIcon()
↓
SharedPreferences 저장
```

---

## 복원 흐름

```txt
앱 실행
↓
ProfileIconController.initialize()
↓
LocalStorage.readProfileIcon()
↓
SharedPreferences 조회
↓
화면 표시
```

---

# 테마 저장 구조

## 저장 위치

```txt
SharedPreferences
```

---

## 저장 Key

```txt
APP_THEME_MODE
```

---

## 저장 값

```txt
light
dark
system
```

---

## 저장 흐름

```txt
다크모드 선택
↓
ThemeController
↓
LocalStorage.writeThemeMode()
↓
SharedPreferences 저장
```

---

## 복원 흐름

```txt
앱 실행
↓
ThemeController.initialize()
↓
APP_THEME_MODE 조회
↓
ThemeMode 적용
```

---

# 인증 정보 저장 구조

## 저장 위치

```txt
FlutterSecureStorage
```

---

## 저장 데이터

```txt
ACCESS_TOKEN
REFRESH_TOKEN
AUTO_LOGIN

USER_ID
USER_NM
LOGIN_ID
EMAIL
INSTT_ID
INSTT_NM
INSTT_TY
USER_SE_CD
```

---

## 저장 흐름

```txt
로그인 성공
↓
AuthController.login()
↓
AuthStorage.writeLoginInfo()
↓
FlutterSecureStorage 저장
```

---

## 복원 흐름

```txt
앱 실행
↓
AuthController.initialize()
↓
AuthStorage.readLoginInfo()
↓
AuthState 복원
```

---

# Dio 인증 처리 구조

## 역할

API 요청 시 인증 헤더를 자동 추가한다.

---

## 동작 흐름

```txt
API 요청
↓
Dio Interceptor
↓
AuthStorage.readTokens()
↓
Authorization Header 추가
↓
서버 요청
```

---

## 인증 헤더 예시

```http
Authorization: Bearer xxxxxxxxx
Refresh-Token: xxxxxxxxx
```

---

## 로그인 API

로그인 API는 인증 없이 호출한다.

```dart
Options(
  headers: {
    'noAuth': true,
  },
)
```

---

## 일반 API

감정체크, 프로필 조회 등 로그인 이후 API는 인증 헤더가 자동 추가된다.

```txt
EmotionRepository
↓
dio.post()
↓
Interceptor
↓
Authorization 추가
↓
API 호출
```

---

# 데이터 분리 원칙

## FlutterSecureStorage 사용

다음 데이터는 반드시 SecureStorage 사용

```txt
ACCESS_TOKEN
REFRESH_TOKEN
JWT
AUTO_LOGIN
사용자 정보
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
authStorage.writeLoginInfo(...)
```

비허용

```dart
SharedPreferences.setString(
  'ACCESS_TOKEN',
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
→ 인증 및 사용자 정보 전용

LocalStorage
→ 설정 및 UI 상태 전용

Dio
→ AuthStorage를 통해 인증 헤더 자동 주입
```

위 구조를 기준으로 인증 및 저장소 기능을 개발한다.
