import 'package:flutter/material.dart';

class AppTheme {
  // Define a light theme
  static final lightTheme = ThemeData(
    // Primary color settings
    primarySwatch: Colors.blue,
    // Text Theme with updated names (e.g., displayLarge instead of headline1)
    textTheme: TextTheme(
      displayLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.bold,
          color: Colors.black), // Replaces headline1
      displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black), // Replaces headline2
      displaySmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black), // Replaces headline3
      bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: Colors.black), // Replaces bodyText1
      bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black), // Replaces bodyText2
      bodySmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.black), // Replaces caption
    ),
    // AppBar theme, customized for a modern look
    appBarTheme: AppBarTheme(
      color: Colors.blue,
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    // Button theme for modern UI
    buttonTheme: ButtonThemeData(
      buttonColor:
          const Color.fromARGB(255, 33, 128, 243), // Default button color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    // Color scheme for light mode
    colorScheme:
        ColorScheme.light(primary: Colors.blue, secondary: Colors.blueAccent),
  );

  // You can also define a dark theme similarly
  static final darkTheme = ThemeData.dark();
}
