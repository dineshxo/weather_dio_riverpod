import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkMode = ThemeData(
    fontFamily: GoogleFonts.inter().fontFamily,
    colorScheme: ColorScheme.dark(
      surface: const Color.fromARGB(255, 39, 39, 39),
      primary: const Color.fromARGB(255, 122, 122, 122),
      secondary: const Color.fromARGB(255, 0, 0, 0),
      tertiary: const Color.fromARGB(255, 71, 71, 71),
      inversePrimary: Colors.grey.shade300,
    ));

ThemeData lightMode = ThemeData(
    fontFamily: GoogleFonts.inter().fontFamily,
    colorScheme: ColorScheme.light(
          surface: const Color.fromARGB(255, 255, 255, 255),
          primary: const Color.fromARGB(255, 234, 234, 234),
          secondary: Colors.grey,
          tertiary: const Color.fromARGB(185, 218, 218, 218),
          inversePrimary: Colors.grey.shade700,
    ));