import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String key = 'favorites';

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  static Future<void> toggleFavorite(String stopName) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(key) ?? [];
    if (favorites.contains(stopName)) {
      favorites.remove(stopName);
    } else {
      favorites.add(stopName);
    }
    await prefs.setStringList(key, favorites);
  }
}
