# 로그인 기능 구현 정리

## 1. 구현 목적

학생 앱에서 이메일과 비밀번호를 이용해 로그인할 수 있도록 구현하였다.

로그인 성공 시 사용자 정보를 전역 로그인 상태에 저장하고, AccessToken/RefreshToken을 SecureStorage에 저장하여 인증이 필요한 API 호출 시 자동으로 인증 헤더가 추가되도록 구성하였다.

또한 자동로그인 체크 여부에 따라 앱 재실행 시 로그인 상태를 복원할 수 있도록 구현하였다.

---

## 2. 주요 기능

### 이메일 로그인

사용자는 이메일과 비밀번호를 입력하여 로그인할 수 있다.

입력값 검증 조건은 다음과 같다.

* 이메일은 이메일 형식이어야 한다.
* 비밀번호는 8글자 이상이어야 한다.
* 입력값이 올바르지 않으면 로그인 버튼은 비활성화된다.
* 이메일 형식이 올바르지 않으면 에러 문구를 표시한다.
* 비밀번호가 8글자 미만이면 에러 문구를 표시한다.

---

## 3. 자동 로그인

로그인 화면에 자동 로그인 체크박스를 추가하였다.

### 자동 로그인 체크 시

* AccessToken 저장
* RefreshToken 저장
* 자동로그인 여부 저장
* 사용자 정보 저장
* 앱 재실행 시 로그인 상태 복원

### 자동 로그인 미체크 시

* AccessToken 저장
* RefreshToken 저장
* 사용자 정보 저장
* 현재 앱 실행 중에는 로그인 상태 유지
* 앱 재실행 시 로그인 상태 복원하지 않음

즉, 자동로그인 여부와 관계없이 현재 앱 세션 동안은 인증이 가능한 상태를 유지한다.

---

## 4. 로그인 상태 관리 구조

로그인 상태는 `AuthController`와 `AuthState`에서 관리한다.

### AuthState 역할

`AuthState`는 현재 로그인 상태와 사용자 정보를 담는 상태 객체이다.

관리 항목은 다음과 같다.

* 로그인 상태
* accessToken
* autoLogin
* userId
* userNm
* loginId
* email
* insttId
* insttNm
* insttTy
* userSeCd

로그인 상태는 다음 세 가지로 구분한다.

```dart
enum AuthStatus {
  unknown,
  unauthenticated,
  authenticated,
}
```

각 상태의 의미는 다음과 같다.

* unknown : 앱 시작 직후 자동로그인 확인 중
* unauthenticated : 로그인되지 않은 상태
* authenticated : 로그인된 상태

---

## 5. AuthController 역할

AuthController는 앱 실행 중 로그인 상태를 관리하는 전역 컨트롤러이다.

주요 역할은 다음과 같다.

* 앱 시작 시 자동로그인 여부 확인
* 저장된 사용자 정보 복원
* 로그인 상태 관리
* 로그인 성공 시 AuthStorage 저장
* 로그아웃 시 저장 정보 삭제

---

## 6. AuthStorage 역할

AuthStorage는 인증 관련 데이터를 SecureStorage에 저장하고 조회하는 역할을 담당한다.

주요 역할은 다음과 같다.

* AccessToken 저장
* RefreshToken 저장
* 자동로그인 여부 저장
* 사용자 정보 저장
* 자동로그인 정보 복원
* 로그아웃 시 저장 정보 삭제

AuthController와 Dio가 동일한 AuthStorage를 사용하도록 구성하였다.

---

## 7. 로그인 흐름

전체 로그인 흐름은 다음과 같다.

```text
LoginScreen
    ↓
입력값 검증
    ↓
LoginController.loginWithEmail()
    ↓
LoginRepository.login()
    ↓
로그인 API 호출
    ↓
응답 성공
    ↓
AuthController.login()
    ↓
AuthState 저장
    ↓
AuthStorage.writeLoginInfo()
    ↓
토큰 저장
사용자 정보 저장
    ↓
Home 화면 이동
```

---

## 8. 로그인 성공 시 저장되는 정보

백엔드 로그인 성공 응답 예시

```json
{
  "userId": "1000002",
  "userNm": "판교초 학생2",
  "loginId": "stu102@foxedu.kr",
  "email": "stu102@foxedu.kr",
  "insttId": "7551234",
  "insttNm": "판교초등학교",
  "insttTy": "초등학교",
  "userSeCd": "10",
  "accessToken": "...",
  "refreshToken": "..."
}
```

현재 앱에서 사용하는 값은 다음과 같다.

* accessToken
* refreshToken
* userId
* userNm
* loginId
* email
* insttId
* insttNm
* insttTy
* userSeCd

---

## 9. 자동로그인 복원 흐름

앱 실행 시 authControllerProvider가 생성되고 initialize()가 호출된다.

```text
앱 실행
    ↓
AuthController.initialize()
    ↓
AuthStorage.readLoginInfo()
    ↓
AUTO_LOGIN 확인
    ↓
AccessToken 확인
    ↓
사용자 정보 조회
    ↓
AuthState.authenticated 복원
```

자동로그인이 설정되어 있고 토큰이 존재하면 로그인 상태가 자동 복원된다.

---

## 10. SecureStorage 저장 값

```text
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

로그아웃 시 위 값들은 모두 삭제된다.

---

## 11. Dio 인증 처리

Dio Interceptor를 이용하여 인증 헤더를 자동으로 추가한다.

### 로그인 API

```text
noAuth: true
```

Authorization 헤더를 추가하지 않는다.

### 인증이 필요한 API

```text
AuthStorage.readTokens()
    ↓
Authorization Header 추가
```

예시

```http
Authorization: Bearer xxxxxxxxx
Refresh-Token: xxxxxxxxx
```

---

## 12. 감정체크 API 인증 흐름

감정체크 API는 로그인 후 저장된 토큰을 사용하여 자동 인증된다.

```text
EmotionRepository
    ↓
dio.post()
    ↓
Interceptor 실행
    ↓
AuthStorage.readTokens()
    ↓
Authorization Header 추가
    ↓
API 요청
```

Repository에서는 별도 토큰 처리 없이 통신만 수행하면 된다.

---

## 13. 프로필 화면

프로필 화면에서는 authControllerProvider를 watch하여 사용자 정보를 표시한다.

표시 항목은 다음과 같다.

* 프로필 아이콘
* 사용자 이름
* 학교명
* 이메일
* QR 코드
* 로그아웃 버튼

로그아웃 흐름

```text
홈 화면 이동
    ↓
AuthController.logout()
    ↓
AuthStorage.clear()
    ↓
AuthState.unauthenticated
```

---

## 14. AppShell 변경 내용

상단 AppBar는 로그인 상태에 따라 다르게 표시한다.

### 로그아웃 상태

```text
로그인 버튼 표시
```

### 로그인 상태

```text
프로필 아이콘 표시
```

프로필 아이콘 클릭 시 프로필 화면으로 이동한다.

하단 네비게이션은 다음 메뉴를 제공한다.

```text
홈
감정체크
프로필
설정
```

---

## 15. 최종 구조

```text
LoginScreen
    ↓
LoginController
    ↓
LoginRepository
    ↓
AuthController
    ↓
AuthStorage
    ↓
SecureStorage

Dio
    ↓
AuthStorage
    ↓
Authorization Header 추가
```

---

## 16. 파일별 역할

| 파일                    | 역할                      |
| --------------------- | ----------------------- |
| login_screen.dart     | 로그인 화면, 입력값 검증          |
| login_controller.dart | 로그인 API 호출 흐름 제어        |
| login_repository.dart | 로그인 API 통신              |
| auth_state.dart       | 로그인 상태 및 사용자 정보         |
| auth_controller.dart  | 로그인 상태 관리               |
| auth_storage.dart     | 토큰 및 사용자 정보 저장/조회       |
| storage_provider.dart | AuthStorage Provider 생성 |
| dio.dart              | 토큰 자동 주입 및 응답 토큰 갱신     |
| profile_screen.dart   | 사용자 정보 표시               |
| app_shell.dart        | 로그인 상태에 따른 UI 분기        |

---

## 17. 향후 추가 예정

현재 구현되지 않은 기능

* AccessToken 만료 시간 확인
* JWT exp 파싱
* RefreshToken 재발급
* 토큰 만료 시 자동 로그아웃
* API 401 응답 시 자동 재인증

---

## 18. 구현 완료 항목

* 이메일 로그인
* 비밀번호 로그인
* 입력값 유효성 검사
* 로그인 버튼 활성화 제어
* 자동로그인 체크박스
* AccessToken 저장
* RefreshToken 저장
* 사용자 정보 저장
* 전역 로그인 상태 관리
* 자동로그인 복원
* Dio 인증 헤더 자동 추가
* 프로필 정보 표시
* 로그아웃 처리
* AppBar 로그인/프로필 분기
* 하단 네비게이션 구성
* 감정체크 API 인증 연동
* AuthStorage 기반 인증 구조 통합

```
```
