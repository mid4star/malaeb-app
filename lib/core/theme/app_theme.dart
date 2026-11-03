import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF08090C);
  static const Color surface = Color(0xFF111218);
  static const Color surfaceCard = Color(0xFF0F1015);
  static const Color surfaceCardLight = Color(0xFF14151B);
  static const Color surfaceElevated = Color(0xFF1B1C22);
  static const Color surfaceActive = Color(0xFF24262D);
  
  static const Color red = Color(0xFFFF3B3B);
  static const Color redHover = Color(0xFFFF5050);
  static const Color redGlow = Color(0x3BFF3B3B);
  static const Color redBadgeBg = Color(0x26FF3B3B);
  
  static const Color border = Color(0x13FFFFFF); // rgba(255,255,255,0.075)
  static const Color borderHover = Color(0x29FFFFFF); // rgba(255,255,255,0.16)
  
  static const Color textWhite = Color(0xFFF6F7F9);
  static const Color textMuted = Color(0xFF9396A1);
  static const Color textDim = Color(0xFF777983);
  static const Color textKicker = Color(0xFFC5C7CD);
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surfaceCardLight, surfaceCard],
  );
  
  static const LinearGradient heroShadeHorizontal = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0x0D08090C),
      Color(0x8508090C),
      Color(0xFA08090C),
    ],
  );

  static const LinearGradient heroShadeVertical = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      Color(0xFF08090C),
      Colors.transparent,
    ],
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.red,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.red,
        surface: AppColors.surface,
        background: AppColors.background,
        onPrimary: Colors.white,
        onSurface: AppColors.textWhite,
        onBackground: AppColors.textWhite,
      ),
      textTheme: GoogleFonts.tajawalTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: AppColors.textWhite,
        displayColor: AppColors.textWhite,
      ),
      dividerColor: AppColors.border,
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
