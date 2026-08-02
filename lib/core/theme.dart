import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Squarespace 7.1 "Plum Blenny" / Editorial Spa Color Palette
  static const Color backgroundCream = Color(0xFFEBE5DD); // Exact warm sand/taupe from screenshot
  static const Color textDark = Color(0xFF141414); // Rich editorial black
  static const Color primaryGold = Color(0xFFBA8E50); // Luxury metallic gold accent
  static const Color buttonDark = Color(0xFF141414); // Solid black pill button CTA
  static const Color accentRose = Color(0xFFDCCFC3); // Soft neutral sand border accent
  static const Color white = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryGold,
      scaffoldBackgroundColor: backgroundCream,
      colorScheme: ColorScheme.light(
        primary: textDark,
        secondary: primaryGold,
        background: backgroundCream,
        surface: backgroundCream,
        onPrimary: white,
        onSecondary: white,
        onBackground: textDark,
        onSurface: textDark,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.cormorantGaramond(
          color: textDark,
          fontWeight: FontWeight.w400,
        ),
        displayMedium: GoogleFonts.cormorantGaramond(
          color: textDark,
          fontWeight: FontWeight.w400,
        ),
        bodyLarge: GoogleFonts.montserrat(
          color: textDark,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.montserrat(
          color: textDark,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: GoogleFonts.montserrat(
          color: white,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonDark,
          foregroundColor: white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textDark,
          side: const BorderSide(color: textDark, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
