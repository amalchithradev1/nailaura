import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Nailaura palette: gold, black, white
  static const Color primaryGold = Color(0xFFBA8E50); // Signature metallic gold
  static const Color goldLight = Color(0xFFD9B77C); // Highlight for gradients / hover
  static const Color ink = Color(0xFF0C0B0A); // Deepest black for dark sections
  static const Color charcoal = Color(0xFF161514); // Cards on dark sections
  static const Color textDark = Color(0xFF141414); // Editorial black text
  static const Color ivory = Color(0xFFF8F5F0); // Soft white for light sections
  static const Color white = Colors.white;

  // Legacy names still used by the invoice screen and booking dialog
  static const Color backgroundCream = ivory;
  static const Color buttonDark = textDark;
  static const Color accentRose = Color(0xFFE6DCCD);

  static const LinearGradient goldGradient = LinearGradient(
    colors: [goldLight, primaryGold, Color(0xFF9C7440)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryGold,
      scaffoldBackgroundColor: ink,
      colorScheme: const ColorScheme.light(
        primary: textDark,
        secondary: primaryGold,
        surface: ivory,
        onPrimary: white,
        onSecondary: white,
        onSurface: textDark,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.cormorantGaramond(color: textDark),
        displayMedium: GoogleFonts.cormorantGaramond(color: textDark),
        bodyLarge: GoogleFonts.montserrat(color: textDark),
        bodyMedium: GoogleFonts.montserrat(color: textDark),
        labelLarge: GoogleFonts.montserrat(
          color: white,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

/// Typography helpers for the editorial layout.
class AppText {
  /// Large handwritten accent word ("Story", "Team", ...).
  static TextStyle script({double size = 110, Color? color}) =>
      GoogleFonts.greatVibes(
        fontSize: size,
        color: color ?? AppTheme.primaryGold,
        height: 1.0,
      );

  /// Small spaced-out uppercase label.
  static TextStyle eyebrow({Color? color, double size = 12}) =>
      GoogleFonts.montserrat(
        fontSize: size,
        fontWeight: FontWeight.w600,
        letterSpacing: 4.0,
        color: color ?? AppTheme.primaryGold,
      );

  /// Uppercase section heading.
  static TextStyle heading({double size = 34, Color? color}) =>
      GoogleFonts.montserrat(
        fontSize: size,
        fontWeight: FontWeight.w600,
        letterSpacing: size > 28 ? 5.0 : 3.0,
        height: 1.35,
        color: color ?? AppTheme.textDark,
      );

  static TextStyle body({Color? color, double size = 15}) =>
      GoogleFonts.montserrat(
        fontSize: size,
        fontWeight: FontWeight.w400,
        height: 1.8,
        color: color ?? AppTheme.textDark.withValues(alpha: 0.7),
      );

  static TextStyle serif({double size = 26, Color? color, FontStyle? style}) =>
      GoogleFonts.cormorantGaramond(
        fontSize: size,
        fontWeight: FontWeight.w500,
        fontStyle: style,
        height: 1.3,
        color: color ?? AppTheme.textDark,
      );
}

/// Breakpoints shared by every section.
class Responsive {
  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;
  static bool isMobile(BuildContext context) => width(context) < 700;
  static bool isTablet(BuildContext context) =>
      width(context) >= 700 && width(context) < 1100;
  static bool isDesktop(BuildContext context) => width(context) >= 1100;

  static double gutter(BuildContext context) =>
      isMobile(context) ? 24 : (isTablet(context) ? 48 : 80);

  static double sectionPadding(BuildContext context) =>
      isMobile(context) ? 90 : 140;
}
