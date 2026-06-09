# 로그인 기능 구현 정리

## 1. 구현 목적

학생 앱에서 이메일과 비밀번호를 이용해 로그인할 수 있도록 구현하였다.
로그인 성공 시 사용자 정보를 전역 로그인 상태에 저장하고, 자동로그인 체크 여부에 따라 앱 재실행 후에도 로그인 상태와 프로필 정보가 유지되도록 처리하였다.

---

## 2. 주요 기능

### 이메일 로그인

사용자는 이메일과 비밀번호를 입력하여 로그인할 수 있다.

입력값 검증 조건은 다음과 같다.

* 이메일은 이메일 형식이어야 한다.
* 비밀번호는 8글자 이상이어야 한다.
* 입력값이 올바르지 않으면 로그인 버튼은 비활성화된다.
* 이메일 입력 중 형식이 맞지 않으면 에러 문구를 표시한다.
* 비밀번호가 8글자 미만이면 에러 문구를 표시한다.

---

## 3. 자동 로그인

로그인 화면에 자동 로그인 체크박스를 추가하였다.

자동 로그인 체크 시:

* accessToken 저장
* 자동로그인 여부 저장
* 사용자 이름 저장
* 이메일 저장
* 학교명 저장
* 기타 사용자 정보 저장
* 앱 재실행 시 로그인 상태 복원

자동 로그인 미체크 시:

* 현재 앱 실행 중에는 로그인 상태 유지
* 앱 종료 후 재실행 시 로그인 정보 유지하지 않음
* 기존 저장 정보가 있으면 삭제

---

## 4. 로그인 상태 관리 구조

로그인 상태는 `AuthController`와 `AuthState`에서 관리한다.

### AuthState 역할

`AuthState`는 현재 로그인 상태와 사용자 정보를 담는 상태 객체이다.

관리하는 값은 다음과 같다.

* 로그인 상태
* accessToken
* 자동로그인 여부
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

* `unknown`: 앱 시작 직후, 자동로그인 여부 확인 중
* `unauthenticated`: 로그인 안 된 상태
* `authenticated`: 로그인 완료 상태

---

## 5. AuthController 역할

`AuthController`는 로그인 상태를 관리하는 전역 컨트롤러이다.

주요 역할은 다음과 같다.

* 앱 시작 시 저장된 로그인 정보 확인
* 자동로그인 여부 확인
* 저장된 토큰과 사용자 정보 복원
* 로그인 성공 시 상태 저장
* 자동로그인 체크 시 SecureStorage 저장
* 로그아웃 시 저장 정보 삭제

---

## 6. 로그인 흐름

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
AuthState에 로그인 상태 저장
    ↓
자동로그인 체크 시 SecureStorage 저장
    ↓
Home 화면 이동
```

---

## 7. 로그인 성공 시 저장되는 정보

백엔드 로그인 성공 응답에서 다음 값을 사용한다.

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

현재 앱에서는 주로 다음 값을 사용한다.

* `accessToken`
* `userId`
* `userNm`
* `loginId`
* `email`
* `insttId`
* `insttNm`
* `insttTy`
* `userSeCd`

---

## 8. 자동로그인 복원 흐름

앱이 실행되면 `authControllerProvider`가 생성되고 `initialize()`가 호출된다.

```text
앱 실행
    ↓
AuthController.initialize()
    ↓
SecureStorage에서 AUTO_LOGIN 확인
    ↓
자동로그인 값이 Y인지 확인
    ↓
ACCESS_TOKEN 확인
    ↓
저장된 사용자 정보 조회
    ↓
AuthState.authenticated 상태로 복원
```

자동로그인이 체크되어 있고 토큰이 존재하면 로그인 상태가 복원된다.
이때 사용자 정보도 함께 복원되므로 프로필 화면에서도 이름, 학교, 이메일이 유지된다.

---

## 9. SecureStorage 저장 값

자동로그인 체크 시 SecureStorage에 다음 값들을 저장한다.

```text
ACCESS_TOKEN
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

## 10. 프로필 화면

로그인 성공 후 프로필 화면에서는 `authControllerProvider`를 watch하여 사용자 정보를 표시한다.

표시 정보는 다음과 같다.

* 프로필 아이콘
* 사용자 이름
* 학교명
* 이메일 또는 로그인 ID
* 로그아웃 버튼

로그아웃 버튼 클릭 시 다음 순서로 처리한다.

```text
홈 화면 이동
    ↓
AuthController.logout()
    ↓
SecureStorage 저장값 삭제
    ↓
AuthState.unauthenticated 상태로 변경
```

먼저 홈으로 이동한 뒤 로그아웃 처리하는 이유는 현재 화면이 프로필 화면일 때 로그아웃을 먼저 하면 라우터에서 “로그인 후 이용해주세요” 알림이 뜰 수 있기 때문이다.

---

## 11. AppShell 변경 내용

상단 AppBar는 로그인 상태에 따라 다르게 표시한다.

로그아웃 상태:

```text
로그인 버튼 표시
```

로그인 상태:

```text
사람 아이콘 표시
```

사람 아이콘을 누르면 프로필 화면으로 이동한다.

하단 네비게이션은 홈만 남겼다.

---

## 12. 현재 제외한 항목

토큰 만료 시간 계산은 아직 구현하지 않았다.

추후 백엔드 정책이 확정되면 다음 기능을 추가할 예정이다.

* accessToken 만료 시간 확인
* JWT exp 값 파싱
* 만료 시 로그아웃 처리
* refreshToken으로 재발급 처리
* API 요청 실패 시 토큰 갱신 처리

---

## 13. 최종 구조

현재 로그인 구조는 다음과 같다.

```text
LoginScreen
    ↓
LoginController
    ↓
LoginRepository
    ↓
AuthController
    ↓
AuthState
    ↓
SecureStorage
```

각 역할은 다음과 같다.

| 파일                      | 역할                       |
| ----------------------- | ------------------------ |
| `login_screen.dart`     | 로그인 화면, 입력값 검증, 자동로그인 체크 |
| `login_controller.dart` | 로그인 API 호출 흐름 제어         |
| `login_repository.dart` | 실제 로그인 통신 요청             |
| `auth_state.dart`       | 로그인 상태와 사용자 정보 객체        |
| `auth_controller.dart`  | 로그인 상태 관리, 자동로그인 저장/복원   |
| `profile_screen.dart`   | 로그인 사용자 정보 표시, 로그아웃 처리   |
| `app_shell.dart`        | 로그인 상태에 따른 상단 버튼/아이콘 표시  |

---

## 14. 정리

이번 로그인 기능 구현을 통해 다음 기능이 완료되었다.

* 이메일 로그인
* 비밀번호 로그인
* 입력값 유효성 검사
* 로그인 버튼 활성화 제어
* 자동로그인 체크박스
* 로그인 성공 후 홈 이동
* 로그인 성공 모달 제거
* 전역 로그인 상태 관리
* 사용자 정보 프로필 표시
* 앱 재실행 시 자동로그인 복원
* 로그아웃 시 저장값 삭제
* 상단 로그인/프로필 아이콘 분기 처리
* 하단 네비게이션 홈만 유지
