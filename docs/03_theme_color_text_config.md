# Theme System 가이드

## 개요

본 프로젝트는 Flutter의 ThemeData를 사용하여 라이트 모드 / 다크 모드를 지원한다.

기존 프로젝트에서 사용하던

```dart
AppColors.primary500
AppColors.gray200
Typo.bodyM
```

형태의 디자인 토큰 사용 방식을 유지하면서, 테마 변경 시 자동으로 색상이 변경될 수 있도록 구현하였다.

---

# 구조

```txt
lib/core/theme/
 ├─ app_theme.dart
 ├─ app_colors.dart
 ├─ app_color_extension.dart
 ├─ theme_controller.dart
 └─ theme_state.dart
```

## 파일 역할

### app_colors.dart

프로젝트의 디자인 토큰(Color Token)을 정의한다.

LightAppColors
DarkAppColors

두 클래스로 구성되며 동일한 네이밍을 유지한 채 라이트/다크 색상을 분리 관리한다.

예시

```dart
context.colors.primary500
context.colors.gray300
context.colors.textPrimary
```

---

### app_color_extension.dart

현재 활성화된 Theme의 색상 정보를 가져오는 확장 클래스이다.

예시

```dart
context.colors.primary500
```

실행 시

라이트 모드 → LightAppColors.primary500

다크 모드 → DarkAppColors.primary500

값이 자동 적용된다.

---

### app_theme.dart

Flutter ThemeData를 생성한다.

* Light Theme
* Dark Theme

를 정의하며 AppColorTheme Extension을 등록한다.

---

### theme_controller.dart

사용자의 테마 설정을 관리한다.

기능

* 라이트 모드 설정
* 다크 모드 설정
* 테마 토글
* 앱 재실행 시 저장된 테마 복원

저장 위치

```dart
APP_THEME_MODE
```

---

### theme_state.dart

현재 ThemeMode 상태를 관리한다.

```dart
ThemeMode.light
ThemeMode.dark
```

---

# 사용 방법

## 색상 사용

### 권장 방식

```dart
Container(
  color: context.colors.primary100,
)
```

```dart
Text(
  '로그인',
  style: Typo.bodyMBold.copyWith(
    color: context.colors.textPrimary,
  ),
)
```

---

### 사용 금지

```dart
AppColors.primary500
```

정적(static) 색상은 테마 전환 시 변경되지 않는다.

---

### 사용 권장

```dart
context.colors.primary500
```

현재 테마에 맞는 색상이 자동 적용된다.

---

# Typography 사용

Typography는 기존 프로젝트와 동일하게 사용한다.

```dart
Typo.titleXXLBold
Typo.titleLBold
Typo.bodyMBold
Typo.bodyM
Typo.bodyS
```

예시

```dart
Text(
  '로그인',
  style: Typo.bodyMBold,
)
```

Typography는 테마 영향을 받지 않는다.

색상은 별도로 지정한다.

```dart
Text(
  '로그인',
  style: Typo.bodyMBold.copyWith(
    color: context.colors.textPrimary,
  ),
)
```

---

# Semantic Color

Semantic Color는 화면에서 의미를 표현하기 위한 색상이다.

예시

```dart
context.colors.textPrimary
context.colors.textSecondary
context.colors.border
context.colors.surface
context.colors.bg
```

## 권장 사용

| 목적     | 색상            |
| ------ | ------------- |
| 기본 텍스트 | textPrimary   |
| 보조 텍스트 | textSecondary |
| 카드 배경  | surface       |
| 화면 배경  | bg            |
| 테두리    | border        |

---

# Gradient 사용

예시

```dart
Container(
  decoration: BoxDecoration(
    gradient: context.colors.homeBgGradient,
  ),
)
```

라이트 모드와 다크 모드 각각 다른 Gradient가 적용된다.

---

# 테마 변경

## 다크 모드

```dart
ref.read(themeControllerProvider.notifier)
    .setDarkTheme();
```

---

## 라이트 모드

```dart
ref.read(themeControllerProvider.notifier)
    .setLightTheme();
```

---

## 토글

```dart
ref.read(themeControllerProvider.notifier)
    .toggleTheme();
```

---

# 신규 색상 추가 규칙

새로운 색상은 반드시 app_colors.dart에 추가한다.

예시

```dart
Color get success;
Color get warning;
```

LightAppColors

```dart
@override
Color get success => const Color(0xFF22C55E);
```

DarkAppColors

```dart
@override
Color get success => const Color(0xFF4ADE80);
```

사용

```dart
context.colors.success
```

---

# 개발 규칙

## 색상

허용

```dart
context.colors.primary500
context.colors.gray300
context.colors.textPrimary
```

비허용

```dart
Colors.blue
Colors.red
Color(0xFF123456)
```

특별한 사유가 없는 한 화면에서 직접 Color를 생성하지 않는다.

---

## 텍스트 스타일

허용

```dart
Typo.bodyM
Typo.bodyMBold
Typo.titleLBold
```

비허용

```dart
TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w700,
)
```

특별한 사유가 없는 한 Typography Token을 사용한다.

---

# 최종 원칙

프로젝트의 디자인은 다음 두 가지 토큰만 사용한다.

```dart
context.colors.xxx
Typo.xxx
```

모든 화면은 위 두 가지 디자인 토큰을 기반으로 구현한다.
