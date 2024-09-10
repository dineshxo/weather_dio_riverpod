import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_dio_riverpod/providers/theme_provider.dart';
import 'package:weather_dio_riverpod/ui/screens/home.dart';
import 'package:weather_dio_riverpod/ui/themes.dart';

void main() {
  runApp(const ProviderScope(child:  MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final isLightTheme = ref.watch(themeProvider);
    
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: isLightTheme ? lightMode: darkMode,
      home: const HomePage(),
    );
  }
}
