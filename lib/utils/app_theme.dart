import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppThemeData {
  AppThemeData._();

  static final ThemeData defaultTheme = ThemeData(
    // GENERAL CONFIGURATION
    applyElevationOverlayColor: true,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black26),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black54),
      ),
      labelStyle: TextStyle(color: Color.fromARGB(255, 25, 74, 151)),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    platform: TargetPlatform.android,
    visualDensity: VisualDensity.adaptivePlatformDensity,

    // COLOR
    brightness: Brightness.light,
    primaryColor: Color.fromARGB(255, 25, 74, 151),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch(
      accentColor: Colors.orange,
      brightness: Brightness.light,
    ).copyWith(
      secondary: Colors.orange,
    ),

    // TYPOGRAPHY & ICONOGRAPHY
    fontFamily: 'Roboto',
    textTheme: TextTheme(
      displayLarge: TextStyle(
          fontSize: 57.0, fontWeight: FontWeight.bold, color: Colors.black54),
      displayMedium: TextStyle(
          fontSize: 45.0, fontWeight: FontWeight.bold, color: Colors.black54),
      displaySmall: TextStyle(
          fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.black54),
      headlineLarge: TextStyle(
          fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black54),
      headlineMedium: TextStyle(
          fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.black54),
      headlineSmall: TextStyle(
          fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black54),
      titleLarge: TextStyle(
          fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black54),
      titleMedium: TextStyle(
          fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black54),
      titleSmall: TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black54),
      bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black87),
      bodySmall: TextStyle(fontSize: 12.0, color: Colors.black87),
      labelLarge: TextStyle(
          fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black54),
      labelMedium: TextStyle(
          fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.black54),
      labelSmall: TextStyle(
          fontSize: 10.0, fontWeight: FontWeight.bold, color: Colors.black54),
    ),
    primaryTextTheme: TextTheme(
      titleMedium: TextStyle(
          fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    iconTheme: IconThemeData(color: Colors.white),
    primaryIconTheme: IconThemeData(color: Colors.white),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStateProperty.all<Color>(Colors.white),
      ),
    ),

    // COMPONENT THEMES
    appBarTheme: AppBarTheme(
      backgroundColor: Color.fromARGB(255, 25, 74, 151),
      titleTextStyle: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 25, 74, 151),
        foregroundColor: Colors.white,
        textStyle: TextStyle(fontWeight: FontWeight.bold),
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 25, 74, 151),
        side: BorderSide(color: Color.fromARGB(255, 25, 74, 151)),
        textStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 25, 74, 151),
        textStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      shadowColor: Colors.black45,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color.fromARGB(255, 25, 74, 151),
      foregroundColor: Colors.white,
    ),
    tabBarTheme: TabBarTheme(
      labelColor: Color.fromARGB(255, 25, 74, 151),
      unselectedLabelColor: Colors.black54,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Color.fromARGB(255, 25, 74, 151)),
      trackColor: WidgetStateProperty.all(
          Color.fromARGB(255, 25, 74, 151).withOpacity(0.5)),
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(Colors.white),
      fillColor: WidgetStateProperty.all(Color.fromARGB(255, 25, 74, 151)),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(Color.fromARGB(255, 25, 74, 151)),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: Color.fromARGB(255, 25, 74, 151),
      thumbColor: Color.fromARGB(255, 25, 74, 151),
      overlayColor: Color.fromARGB(255, 25, 74, 151).withOpacity(0.2),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color.fromARGB(255, 25, 74, 151),
        selectedIconTheme: IconThemeData(color: Colors.white),
        unselectedIconTheme: IconThemeData(color: Colors.white12),
        selectedLabelStyle: TextStyle(color: Colors.white),
        unselectedLabelStyle: TextStyle(color: Colors.white12)),
    dividerTheme: DividerThemeData(
      color: Colors.grey,
      thickness: 1,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 25, 74, 151),
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: TextStyle(color: Colors.white),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color.fromARGB(255, 25, 74, 151),
      contentTextStyle:
          TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      actionTextColor: Colors.orange,
    ),
  );
}
