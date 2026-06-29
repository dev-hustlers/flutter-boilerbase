import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Lexicon Minimalist Design Tokens
class AppTokens {
  static const Color surface = Color(0xFFF7F9FF);
  static const Color surfaceDim = Color(0xFFD7DAE0);
  static const Color surfaceBright = Color(0xFFF7F9FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF1F4F9);
  static const Color surfaceContainer = Color(0xFFEBEEF4);
  static const Color surfaceContainerHigh = Color(0xFFE5E8EE);
  static const Color surfaceContainerHighest = Color(0xFFE0E3E8);
  static const Color onSurface = Color(0xFF181C20);
  static const Color onSurfaceVariant = Color(0xFF424753);
  static const Color inverseSurface = Color(0xFF2D3135);
  static const Color inverseOnSurface = Color(0xFFEEF1F7);
  static const Color outline = Color(0xFF737784);
  static const Color outlineVariant = Color(0xFFC2C6D5);
  static const Color surfaceTint = Color(0xFF105AC0);
  static const Color primary = Color(0xFF003F8D);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF0055BB);
  static const Color onPrimaryContainer = Color(0xFFBED1FF);
  static const Color inversePrimary = Color(0xFFAEC6FF);
  static const Color secondary = Color(0xFF5C5F60);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFE1E3E4);
  static const Color onSecondaryContainer = Color(0xFF626566);
  static const Color tertiary = Color(0xFF762900);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF9C3A02);
  static const Color onTertiaryContainer = Color(0xFFFFC4AC);
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
  
  static const double radiusSm = 2.0; // 0.125rem
  static const double radiusDefault = 4.0; // 0.25rem
  static const double radiusMd = 6.0; // 0.375rem
  static const double radiusLg = 8.0; // 0.5rem (Cards, inputs)
  static const double radiusXl = 12.0; // 0.75rem
  static const double radiusFull = 9999.0;
  
  static const double spacingUnit = 4.0;
  static const double spacingStackXs = 4.0;
  static const double spacingStackSm = 8.0;
  static const double spacingStackMd = 16.0;
  static const double spacingStackLg = 24.0;
  static const double spacingGutter = 16.0;
  static const double spacingMarginMobile = 16.0;
  static const double spacingMarginDesktop = 32.0;
}

class AppTheme {
  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.sourceSerif4(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        height: 41 / 34,
        letterSpacing: -0.02,
        color: AppTokens.onSurface,
      ),
      displayMedium: GoogleFonts.sourceSerif4(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 34 / 28,
        letterSpacing: -0.01,
        color: AppTokens.onSurface,
      ),
      headlineMedium: GoogleFonts.sourceSerif4(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 28 / 22,
        color: AppTokens.onSurface,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 22 / 17,
        letterSpacing: -0.01,
        color: AppTokens.onSurface,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: AppTokens.onSurfaceVariant,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: AppTokens.onSurfaceVariant,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 16 / 12,
        letterSpacing: 0.05,
        color: AppTokens.onSurfaceVariant,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
        color: AppTokens.onSurfaceVariant,
      ),
    );
  }

  static ThemeData get light {
    final colorScheme = const ColorScheme.light(
      primary: AppTokens.primary,
      onPrimary: AppTokens.onPrimary,
      primaryContainer: AppTokens.primaryContainer,
      onPrimaryContainer: AppTokens.onPrimaryContainer,
      secondary: AppTokens.secondary,
      onSecondary: AppTokens.onSecondary,
      secondaryContainer: AppTokens.secondaryContainer,
      onSecondaryContainer: AppTokens.onSecondaryContainer,
      tertiary: AppTokens.tertiary,
      onTertiary: AppTokens.onTertiary,
      tertiaryContainer: AppTokens.tertiaryContainer,
      onTertiaryContainer: AppTokens.onTertiaryContainer,
      error: AppTokens.error,
      onError: AppTokens.onError,
      errorContainer: AppTokens.errorContainer,
      onErrorContainer: AppTokens.onErrorContainer,
      surface: AppTokens.surfaceContainerLowest, 
      onSurface: AppTokens.onSurface,
      outline: AppTokens.outline,
      outlineVariant: AppTokens.outlineVariant,
      inverseSurface: AppTokens.inverseSurface,
      onInverseSurface: AppTokens.inverseOnSurface,
      inversePrimary: AppTokens.inversePrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppTokens.surfaceContainerLowest,
      textTheme: _buildTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppTokens.surfaceContainerLowest,
        foregroundColor: AppTokens.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppTokens.onSurface),
      ),
      cardTheme: CardThemeData(
        color: AppTokens.surfaceContainerLowest, // Design: Secondary surface with no shadow. 
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusLg),
          side: const BorderSide(color: AppTokens.outlineVariant, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTokens.primary,
          foregroundColor: AppTokens.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radiusLg),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTokens.primary,
          side: const BorderSide(color: AppTokens.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radiusLg),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppTokens.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radiusLg),
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppTokens.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppTokens.primary);
          }
          return const IconThemeData(color: AppTokens.onSurfaceVariant);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppTokens.primary);
          }
          return GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppTokens.onSurfaceVariant);
        }),
      ),
      navigationRailTheme: NavigationRailThemeData(
        indicatorColor: Colors.transparent,
        selectedIconTheme: const IconThemeData(color: AppTokens.primary),
        unselectedIconTheme: const IconThemeData(color: AppTokens.onSurfaceVariant),
        selectedLabelTextStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppTokens.primary),
        unselectedLabelTextStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppTokens.onSurfaceVariant),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppTokens.surfaceContainer,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppTokens.onSurfaceVariant,
          letterSpacing: 0.05,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusDefault),
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }

  static ThemeData get dark {
    // Return light mode mapping as per the provided design specific colors for this view.
    return light;
  }
}
