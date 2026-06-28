import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

/// Design tokens class containing all raw colors, spacing, typography, and radii
/// defined in references/tokens.json and references/DESIGN.md.
class AppTokens {
  // Colors
  static const Color paperStone = Color(0xFFF5F5F4);
  static const Color chalk = Color(0xFFE6E3E2);
  static const Color inkBlack = Color(0xFF111111);
  static const Color graphite = Color(0xFF222222);
  static const Color fogGray = Color(0xFF78716B);
  static const Color smoke = Color(0xFF646464);
  static const Color iceLine = Color(0xFFD1DEE8);
  static const Color ash = Color(0xFFD7D3D1);
  static const Color charcoalBlock = Color(0xFF45403C);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color cobaltStamp = Color(0xFF165DFB);

  // Border Radii
  static const double radiusCards = 8.8;
  static const double radiusBadges = 8.8;
  static const double radiusButtons = 8.8;
  static const double radiusImages = 8.8;
  static const double radiusDecorative = 15.0;
  static const double radiusBrandMark = 120.0;

  // Font Families
  static const String fontFigtree = 'Figtree';
  static const String fontInter = 'Inter';

  // Spacing system
  static const double spacing6 = 6.0;
  static const double spacing10 = 10.0;
  static const double spacing11 = 11.0;
  static const double spacing12 = 12.0;
  static const double spacing20 = 20.0;
  static const double spacing22 = 22.0;
  static const double spacing30 = 30.0;
  static const double spacing40 = 40.0;
  static const double spacing43 = 43.0;
  static const double spacing50 = 50.0;
  static const double spacing56 = 56.0;
  static const double spacing57 = 57.0;
  static const double spacing58 = 58.0;
  static const double spacing80 = 80.0;
  static const double spacing100 = 100.0;
  static const double spacing140 = 140.0;
}

/// Custom [ThemeExtension] to expose named design tokens directly via the build context.
/// E.g., `Theme.of(context).extension<AppThemeExtension>()?.paperStone`
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color paperStone;
  final Color chalk;
  final Color inkBlack;
  final Color graphite;
  final Color fogGray;
  final Color smoke;
  final Color iceLine;
  final Color ash;
  final Color charcoalBlock;
  final Color pureWhite;
  final Color cobaltStamp;

  const AppThemeExtension({
    required this.paperStone,
    required this.chalk,
    required this.inkBlack,
    required this.graphite,
    required this.fogGray,
    required this.smoke,
    required this.iceLine,
    required this.ash,
    required this.charcoalBlock,
    required this.pureWhite,
    required this.cobaltStamp,
  });

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? paperStone,
    Color? chalk,
    Color? inkBlack,
    Color? graphite,
    Color? fogGray,
    Color? smoke,
    Color? iceLine,
    Color? ash,
    Color? charcoalBlock,
    Color? pureWhite,
    Color? cobaltStamp,
  }) {
    return AppThemeExtension(
      paperStone: paperStone ?? this.paperStone,
      chalk: chalk ?? this.chalk,
      inkBlack: inkBlack ?? this.inkBlack,
      graphite: graphite ?? this.graphite,
      fogGray: fogGray ?? this.fogGray,
      smoke: smoke ?? this.smoke,
      iceLine: iceLine ?? this.iceLine,
      ash: ash ?? this.ash,
      charcoalBlock: charcoalBlock ?? this.charcoalBlock,
      pureWhite: pureWhite ?? this.pureWhite,
      cobaltStamp: cobaltStamp ?? this.cobaltStamp,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    covariant ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      paperStone: Color.lerp(paperStone, other.paperStone, t)!,
      chalk: Color.lerp(chalk, other.chalk, t)!,
      inkBlack: Color.lerp(inkBlack, other.inkBlack, t)!,
      graphite: Color.lerp(graphite, other.graphite, t)!,
      fogGray: Color.lerp(fogGray, other.fogGray, t)!,
      smoke: Color.lerp(smoke, other.smoke, t)!,
      iceLine: Color.lerp(iceLine, other.iceLine, t)!,
      ash: Color.lerp(ash, other.ash, t)!,
      charcoalBlock: Color.lerp(charcoalBlock, other.charcoalBlock, t)!,
      pureWhite: Color.lerp(pureWhite, other.pureWhite, t)!,
      cobaltStamp: Color.lerp(cobaltStamp, other.cobaltStamp, t)!,
    );
  }
}

/// Structured Flutter themes representing ONLY the reference design tokens.
class AppTheme {
  // Common Text Styles based on Figtree Scale
  static TextStyle get _baseTextStyle => const TextStyle(
        fontFamily: AppTokens.fontFigtree,
        package: null,
      );

  static TextTheme _buildTextTheme(Color primaryColor, Color secondaryColor, Color mutedColor) {
    return TextTheme(
      // display (58px, weight 600, -0.93px letter spacing, line height 1.1)
      displayLarge: _baseTextStyle.copyWith(
        fontSize: 58,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.93,
        height: 1.1,
        color: primaryColor,
      ),
      // heading (45px, weight 600, -0.63px letter spacing, line height 1.25)
      headlineLarge: _baseTextStyle.copyWith(
        fontSize: 45,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.63,
        height: 1.25,
        color: primaryColor,
      ),
      // heading-sm (35px, weight 500, -0.56px letter spacing, line height 1.25)
      headlineMedium: _baseTextStyle.copyWith(
        fontSize: 35,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.56,
        height: 1.25,
        color: primaryColor,
      ),
      // subheading (21px, weight 500, normal letter spacing, line height 1.5)
      titleLarge: _baseTextStyle.copyWith(
        fontSize: 21,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: primaryColor,
      ),
      // body-lg (18px, weight 500, normal letter spacing, line height 1.5)
      bodyLarge: _baseTextStyle.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: secondaryColor,
      ),
      // body (16px, weight 400, normal letter spacing, line height 1.5)
      bodyMedium: _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: secondaryColor,
      ),
      // caption (14px, weight 400, normal letter spacing, line height 1.43)
      bodySmall: _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        color: mutedColor,
      ),
    );
  }

  /// Light Theme Configuration constructed using FlexColorScheme
  static ThemeData get light {
    final textTheme = _buildTextTheme(AppTokens.inkBlack, AppTokens.graphite, AppTokens.fogGray);
    return FlexThemeData.light(
      colors: const FlexSchemeColor(
        primary: AppTokens.cobaltStamp,
        primaryContainer: AppTokens.pureWhite,
        secondary: AppTokens.charcoalBlock,
        secondaryContainer: AppTokens.chalk,
        tertiary: AppTokens.graphite,
        appBarColor: AppTokens.paperStone,
      ),
      fontFamily: AppTokens.fontFigtree,
      textTheme: textTheme,
      scaffoldBackground: AppTokens.paperStone,
      useMaterial3: true,
      subThemesData: const FlexSubThemesData(
        defaultRadius: AppTokens.radiusCards,
        cardRadius: AppTokens.radiusCards,
        dialogRadius: AppTokens.radiusCards,
        textButtonRadius: AppTokens.radiusButtons,
        filledButtonRadius: AppTokens.radiusButtons,
        elevatedButtonRadius: AppTokens.radiusButtons,
        outlinedButtonRadius: AppTokens.radiusButtons,
        buttonPadding: EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: AppTokens.radiusCards,
        inputDecoratorUnfocusedBorderIsColored: false,
        inputDecoratorFocusedBorderWidth: 1.5,
        inputDecoratorFillColor: AppTokens.pureWhite,
      ),
      extensions: const [
        AppThemeExtension(
          paperStone: AppTokens.paperStone,
          chalk: AppTokens.chalk,
          inkBlack: AppTokens.inkBlack,
          graphite: AppTokens.graphite,
          fogGray: AppTokens.fogGray,
          smoke: AppTokens.smoke,
          iceLine: AppTokens.iceLine,
          ash: AppTokens.ash,
          charcoalBlock: AppTokens.charcoalBlock,
          pureWhite: AppTokens.pureWhite,
          cobaltStamp: AppTokens.cobaltStamp,
        ),
      ],
    );
  }

  /// Dark Theme Configuration constructed using FlexColorScheme
  static ThemeData get dark {
    final textTheme = _buildTextTheme(AppTokens.paperStone, AppTokens.chalk, AppTokens.smoke);
    return FlexThemeData.dark(
      colors: const FlexSchemeColor(
        primary: AppTokens.cobaltStamp,
        primaryContainer: AppTokens.graphite,
        secondary: AppTokens.chalk,
        secondaryContainer: AppTokens.charcoalBlock,
        tertiary: AppTokens.paperStone,
        appBarColor: AppTokens.inkBlack,
      ),
      fontFamily: AppTokens.fontFigtree,
      textTheme: textTheme,
      scaffoldBackground: AppTokens.inkBlack,
      useMaterial3: true,
      subThemesData: const FlexSubThemesData(
        defaultRadius: AppTokens.radiusCards,
        cardRadius: AppTokens.radiusCards,
        dialogRadius: AppTokens.radiusCards,
        textButtonRadius: AppTokens.radiusButtons,
        filledButtonRadius: AppTokens.radiusButtons,
        elevatedButtonRadius: AppTokens.radiusButtons,
        outlinedButtonRadius: AppTokens.radiusButtons,
        buttonPadding: EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: AppTokens.radiusCards,
        inputDecoratorUnfocusedBorderIsColored: false,
        inputDecoratorFocusedBorderWidth: 1.5,
        inputDecoratorFillColor: AppTokens.graphite,
      ),
      extensions: const [
        AppThemeExtension(
          paperStone: AppTokens.paperStone,
          chalk: AppTokens.chalk,
          inkBlack: AppTokens.inkBlack,
          graphite: AppTokens.graphite,
          fogGray: AppTokens.fogGray,
          smoke: AppTokens.smoke,
          iceLine: AppTokens.iceLine,
          ash: AppTokens.ash,
          charcoalBlock: AppTokens.charcoalBlock,
          pureWhite: AppTokens.pureWhite,
          cobaltStamp: AppTokens.cobaltStamp,
        ),
      ],
    );
  }
}
