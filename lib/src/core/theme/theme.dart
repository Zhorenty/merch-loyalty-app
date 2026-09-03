import 'package:flutter/material.dart';

const _brand = Color(0xFF12164A);
const _onSurfaceVariant = Color(0xFF5C6080);
const _outline = Color(0xFFD8DAE6);
const _surfaceLowest = Color(0xFFF4F5F8);
const _success = Color(0xFF2F9E62);
const _error = Color(0xFFC62828);

/// Light theme of MERCH Касса.
final $lightThemeData = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: _lightColorScheme,
  textTheme: _lightTextTheme,
  scaffoldBackgroundColor: _surfaceLowest,
  appBarTheme: AppBarTheme(
    backgroundColor: _surfaceLowest,
    foregroundColor: _brand,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    titleTextStyle: _lightTextTheme.headlineLarge,
  ),
  splashColor: _brand.withValues(alpha: 0.08),
  highlightColor: _brand.withValues(alpha: 0.04),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    hintStyle: _lightTextTheme.bodyLarge?.copyWith(color: _onSurfaceVariant),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: _textFieldOutlineBorder(scheme: _lightColorScheme),
    enabledBorder: _textFieldOutlineBorder(scheme: _lightColorScheme),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _brand, width: 1.5),
    ),
    errorBorder: _textFieldErrorBorder(scheme: _lightColorScheme),
    focusedErrorBorder: _textFieldErrorBorder(scheme: _lightColorScheme),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: _brand,
      foregroundColor: Colors.white,
      disabledBackgroundColor: _outline,
      disabledForegroundColor: _onSurfaceVariant,
      minimumSize: const Size(double.infinity, 48),
      textStyle: _lightTextTheme.labelLarge?.copyWith(color: Colors.white),
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: _brand,
    selectionColor: _brand.withValues(alpha: 0.2),
    selectionHandleColor: _brand,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(double.infinity, 48),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      backgroundColor: Colors.white,
      foregroundColor: _brand,
      textStyle: _lightTextTheme.labelLarge,
      side: const BorderSide(color: _brand),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: _brand,
      textStyle: _lightTextTheme.bodyLarge,
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: const Color(0xFFE8F6EE),
    selectedColor: _brand,
    labelStyle: _lightTextTheme.labelMedium,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    side: BorderSide.none,
  ),
  dividerTheme: const DividerThemeData(color: _outline, thickness: 1, space: 1),
  sliderTheme: SliderThemeData(
    activeTrackColor: _brand,
    inactiveTrackColor: _outline,
    thumbColor: _brand,
    overlayColor: _brand.withValues(alpha: 0.12),
    tickMarkShape: SliderTickMarkShape.noTickMark,
    overlayShape: SliderComponentShape.noOverlay,
    trackHeight: 6,
    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: _brand,
    contentTextStyle: _lightTextTheme.bodyMedium?.copyWith(color: Colors.white),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: _brand,
    unselectedItemColor: _onSurfaceVariant,
    type: BottomNavigationBarType.fixed,
    elevation: 0,
    selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
    unselectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: _outline),
    ),
  ),
);

const _lightColorScheme = ColorScheme.light(
  primary: _brand,
  onPrimary: Color(0xFFFFFFFF),
  primaryFixed: _onSurfaceVariant,
  primaryFixedDim: _outline,
  primaryContainer: Color(0xFFE8E9F2),
  onPrimaryContainer: _brand,
  secondary: _brand,
  onSecondary: Color(0xFFFFFFFF),
  surface: Color(0xFFFFFFFF),
  surfaceContainerLowest: _surfaceLowest,
  onSurface: _brand,
  onSurfaceVariant: _onSurfaceVariant,
  outline: _outline,
  outlineVariant: _outline,
  tertiary: _success,
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFE8F6EE),
  onTertiaryContainer: _success,
  error: _error,
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFDECEA),
  onErrorContainer: _error,
  scrim: Color(0x9912164A),
);

final _lightTextTheme = TextTheme(
  displayLarge: const TextStyle(
    fontSize: 48,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
    color: _brand,
  ),
  displayMedium: const TextStyle(
    fontSize: 32,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
    color: _brand,
  ),
  displaySmall: const TextStyle(
    fontSize: 24,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
    color: _brand,
  ),
  headlineLarge: const TextStyle(
    fontSize: 18,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
    color: _brand,
  ),
  headlineMedium: const TextStyle(
    fontSize: 28,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
    color: _brand,
  ),
  headlineSmall: const TextStyle(
    fontSize: 22,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
    color: _brand,
  ),
  titleLarge: const TextStyle(
    fontSize: 20,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
    color: _brand,
  ),
  titleMedium: const TextStyle(
    fontSize: 16,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
    color: _brand,
  ),
  titleSmall: const TextStyle(
    fontSize: 14,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
    color: _brand,
  ),
  labelLarge: const TextStyle(
    fontSize: 16,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
    color: _brand,
  ),
  labelMedium: const TextStyle(
    fontSize: 12,
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
    color: _brand,
  ),
  labelSmall: const TextStyle(
    fontSize: 11,
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
    color: _onSurfaceVariant,
  ),
  bodyLarge: const TextStyle(
    fontSize: 16,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
    color: _brand,
  ),
  bodyMedium: const TextStyle(
    fontSize: 14,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
    color: _brand,
  ),
  bodySmall: const TextStyle(
    fontSize: 12,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
    color: _onSurfaceVariant,
  ),
);

InputDecoration fieldDecoration(
  BuildContext context,
  String hintText, {
  Widget? suffixIcon,
  Widget? prefixIcon,
}) => InputDecoration(
  hintText: hintText,
  hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
  prefixIcon: prefixIcon == null
      ? null
      : Padding(
          padding: const EdgeInsets.all(
            16,
          ).subtract(const EdgeInsets.only(right: 8)),
          child: prefixIcon,
        ),
  suffixIcon: suffixIcon,
);

InputBorder _textFieldOutlineBorder({
  required ColorScheme scheme,
  Color? color,
  double? radius,
}) => OutlineInputBorder(
  borderRadius: BorderRadius.circular(radius ?? 12),
  borderSide: BorderSide(color: color ?? scheme.outline, width: 1),
);

InputBorder _textFieldErrorBorder({
  required ColorScheme scheme,
  double? radius,
}) => OutlineInputBorder(
  borderRadius: BorderRadius.circular(radius ?? 12),
  borderSide: BorderSide(color: scheme.error, width: 1),
);
