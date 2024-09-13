import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteNotifier extends StateNotifier<List<String>> {
  FavoriteNotifier() : super([]) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favoriteList = prefs.getStringList('favorites');
    if (favoriteList != null) {
      state = favoriteList;
    }
  }

  Future<void> addFavorite(String city) async {
    final updatedList = List<String>.from(state);

    if (!updatedList.contains(city)) {
      updatedList.add(city);
      state = updatedList;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorites', updatedList);
    } else {
      print("Item is already in the favorites list.");
    }
  }


  Future<void> removeFavorite(String city) async {
    final updatedList = List<String>.from(state)..remove(city);
    state = updatedList;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', updatedList);
  }
}
