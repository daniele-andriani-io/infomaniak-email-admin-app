import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infomaniak_email_admin_app/screens/home.dart';
import 'package:infomaniak_email_admin_app/screens/how_to_start.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 102, 6, 247),
  surface: const Color.fromARGB(255, 56, 49, 66),
  onSurface: const Color.fromARGB(200, 255, 255, 255),
);

final theme = ThemeData().copyWith(
  scaffoldBackgroundColor: colorScheme.surface,
  colorScheme: colorScheme,
  textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
    titleSmall: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
      color: colorScheme.onSurface,
    ),
    titleMedium: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
      color: colorScheme.onSurface,
    ),
    titleLarge: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
      color: colorScheme.onSurface,
    ),
    bodySmall: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
      color: colorScheme.onSurface,
    ),
    bodyMedium: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
      color: colorScheme.onSurface,
    ),
    bodyLarge: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
      color: colorScheme.onSurface,
    ),
  ),
);

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infomaniak admin app',
      theme: theme,
      home: const HomeScreen(),
    );
  }
}
