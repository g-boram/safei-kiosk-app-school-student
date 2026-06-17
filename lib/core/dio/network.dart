import 'dart:io' show Platform;

enum AppEnv { local, dev, prod }

AppEnv get currentEnv {
  const env = String.fromEnvironment('APP_ENV', defaultValue: 'prod');

  switch (env) {
    case 'prod':
      return AppEnv.prod;
    case 'dev':
      return AppEnv.dev;
    default:
      return AppEnv.local;
  }
}

String resolveBaseUrl() {
  const base = '/api/v1/';
  const localPort = '8211';

  switch (currentEnv) {
    case AppEnv.prod:
      return 'https://safei.alkong.ai$base';

    case AppEnv.dev:
      return 'https://dev-safei.alkong.ai$base';

    case AppEnv.local:
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:$localPort$base';
      }
      return 'http://127.0.0.1:$localPort$base';
  }
}

// 환경에 맞게 resolvePushUrl - 비상벨 사용
String resolvePushUrl() {
  switch (currentEnv) {
    case AppEnv.prod:
      return 'https://safei.alkong.ai/api/v1/pub/sse/vclass/push/general';

    case AppEnv.dev:
      return 'https://dev-safei.alkong.ai/api/v1/pub/sse/vclass/push/general';

    case AppEnv.local:
      return 'https://dev-safei.alkong.ai/api/v1/pub/sse/vclass/push/general';
  }
}
