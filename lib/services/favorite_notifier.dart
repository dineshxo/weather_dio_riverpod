import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteNotifier extends StateNotifier<List<String>> {
  FavoriteNotifier() : super([]) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favoriteList = prefs.getStringList('favorites');
    if (favoriteList != null) {
      state = favoriteList;
    }
  }

  Future<void> addFavorite(String item) async {
    final updatedList = List<String>.from(state)..add(item);
    state = updatedList;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', updatedList);
  }

  Future<void> removeFavorite(String item) async {
    final updatedList = List<String>.from(state)..remove(item);
    state = updatedList;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', updatedList);
  }
}
