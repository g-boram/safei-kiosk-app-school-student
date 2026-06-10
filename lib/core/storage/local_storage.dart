import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _profileIconKey = 'PROFILE_ICON';
  static const _themeModeKey = 'APP_THEME_MODE';

  Future<String?> readProfileIcon() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileIconKey);
  }

  Future<void> writeProfileIcon(String assetPath) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_profileIconKey, assetPath);
  }

  Future<String?> readThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeModeKey);
  }

  Future<void> writeThemeMode(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_themeModeKey, themeMode);
  }
}
