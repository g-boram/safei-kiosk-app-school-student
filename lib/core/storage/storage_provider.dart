import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_storage.dart';
import 'local_storage.dart';

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
});

final authStorageProvider = Provider<AuthStorage>((ref) {
  final storage = ref.watch(flutterSecureStorageProvider);
  return AuthStorage(storage);
});

final localStorageProvider = Provider<LocalStorage>((ref) {
  return LocalStorage();
});
