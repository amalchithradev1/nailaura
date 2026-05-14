import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryGold = Color(0xFFCFA761); // Adjust to match logo
  static const Color backgroundCream = Color(0xFFFAF9F6);
  static const Color textDark = Color(0xFF2C2C2C);
  static const Color white = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryGold,
      scaffoldBackgroundColor: backgroundCream,
      colorScheme: ColorScheme.light(
        primary: primaryGold,
        secondary: primaryGold.withOpacity(0.8),
        background: backgroundCream,
        surface: white,
        onPrimary: white,
        onSecondary: white,
        onBackground: textDark,
        onSurface: textDark,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          color: textDark,
          fontWeight: FontWeight.w700,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          color: textDark,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(
          color: textDark,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.inter(
          color: textDark.withOpacity(0.8),
          fontWeight: FontWeight.w400,
        ),
        labelLarge: GoogleFonts.inter(
          color: white,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGold,
          foregroundColor: white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGold,
          side: const BorderSide(color: primaryGold, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
