import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_storage.dart';
import '../../../core/storage/storage_provider.dart';

final profileIconControllerProvider =
    StateNotifierProvider<ProfileIconController, String?>((ref) {
      final localStorage = ref.watch(localStorageProvider);

      final controller = ProfileIconController(localStorage);

      controller.initialize();

      return controller;
    });

class ProfileIconController extends StateNotifier<String?> {
  final LocalStorage _localStorage;

  ProfileIconController(this._localStorage) : super(null);

  Future<void> initialize() async {
    final savedIcon = await _localStorage.readProfileIcon();

    if (!mounted) return;

    state = savedIcon;
  }

  Future<void> selectIcon(String assetPath) async {
    await _localStorage.writeProfileIcon(assetPath);

    if (!mounted) return;

    state = assetPath;
  }
}
