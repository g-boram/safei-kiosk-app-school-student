// lib/core/dio/api_response.dart

/// 서버의 message 영역
class ApiMessageBody {
  final List<String> messages;
  final List<String> titles;

  const ApiMessageBody({this.messages = const [], this.titles = const []});

  factory ApiMessageBody.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ApiMessageBody();
    }

    return ApiMessageBody(
      messages: _stringList(json['messages']),
      titles: _stringList(json['titles']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'messages': messages, 'titles': titles};
  }
}

/// 공통 응답 타입
class ApiResponse<T> {
  final String messageCode;
  final ApiMessageBody message;
  final T? data;

  const ApiResponse({
    required this.messageCode,
    required this.message,
    this.data,
  });

  bool get isSuccess => messageCode.toLowerCase().contains('success');

  String? get firstMessage =>
      message.messages.isNotEmpty ? message.messages.first : null;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final rawData = json['data'];

    return ApiResponse<T>(
      messageCode: json['messageCode']?.toString() ?? '',
      message: ApiMessageBody.fromJson(
        json['message'] is Map<String, dynamic>
            ? json['message'] as Map<String, dynamic>
            : null,
      ),
      data: rawData == null ? null : fromJsonT(rawData),
    );
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) {
    return {
      'messageCode': messageCode,
      'message': message.toJson(),
      'data': data == null ? null : toJsonT(data as T),
    };
  }

  String userMessage({String fallback = '요청 처리 중 오류가 발생했습니다.'}) {
    return firstMessage ?? fallback;
  }
}

/// List<dynamic> 값을 안전하게 List<String>으로 변환
List<String> _stringList(Object? value) {
  if (value is! List) {
    return const [];
  }

  return value
      .where((e) => e != null)
      .map((e) => e.toString())
      .where((e) => e.trim().isNotEmpty)
      .toList();
}

/// UI 표시에 필요한 텍스트 가공
extension ApiMessageBodyDisplayX on ApiMessageBody {
  String get titleText {
    if (titles.isNotEmpty) return titles.join('\n');
    if (messages.isNotEmpty) return messages.first;
    return '';
  }

  String get messageText {
    if (messages.isNotEmpty) return messages.join('\n');
    return '';
  }

  String get displayText {
    if (messages.isNotEmpty) return messages.join('\n');
    if (titles.isNotEmpty) return titles.join('\n');
    return '';
  }
}

/// 컨트롤러/UI에서 잡아서 쓸 커스텀 예외
class ApiException implements Exception {
  final String messageCode;
  final String userMessage;
  final int? statusCode;

  ApiException({
    required this.messageCode,
    required this.userMessage,
    this.statusCode,
  });

  @override
  String toString() => userMessage;
}
