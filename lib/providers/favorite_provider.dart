import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/favorite_notifier.dart';


final favoriteProvider = StateNotifierProvider<FavoriteNotifier, List<String>>(
      (ref) => FavoriteNotifier(),
);
