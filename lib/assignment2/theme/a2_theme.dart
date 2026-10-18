import 'package:flutter/material.dart';

// ============================================================
// One project, one theme.
//
// Every Assignment 2 screen gets its colors from here, so the
// AppBar, buttons, inputs and background look the same on all
// screens (requirement of Assignment 2).
//
// The palette matches the full Rabbit Track app (lib/core/theme)
// so the whole project looks like ONE app.
// ============================================================
class A2Colors {
  static const Color primary = Color(0xFF2D6A4F); // deep farm green
  static const Color primaryDark = Color(0xFF1B4332);
  static const Color primaryLight = Color(0xFF52B788);
  static const Color surfaceGreen = Color(0xFFD8F3DC); // light green tint

  static const Color accentOrange = Color(0xFFE76F51);
  static const Color amber = Color(0xFFF4A261);

  static const Color background = Color(0xFFF8FAF8);
  static const Color border = Color(0xFFDEEDE3);

  static const Color textDark = Color(0xFF1A2E22);
  static const Color textGrey = Color(0xFF4A6B55);
  static const Color textHint = Color(0xFF8BA898);
}

class A2Theme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,

        // +1 BONUS: custom font loaded from assets/fonts (Poppins),
        // registered in pubspec.yaml. Applies to every Text widget.
        fontFamily: 'Poppins',

        scaffoldBackgroundColor: A2Colors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: A2Colors.primary,
        ).copyWith(primary: A2Colors.primary, secondary: A2Colors.primaryLight),

        // Consistent AppBar on EVERY screen (Assignment 2 requirement).
        appBarTheme: const AppBarTheme(
          backgroundColor: A2Colors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),

        // One shared style for the form screen's TextFields.
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: A2Colors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: A2Colors.border),
          ),
          labelStyle: const TextStyle(color: A2Colors.textGrey, fontSize: 14),
          hintStyle: const TextStyle(color: A2Colors.textHint, fontSize: 14),
          prefixIconColor: A2Colors.primaryLight,
        ),

        // One shared style for the main (Save) button.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: A2Colors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
}
