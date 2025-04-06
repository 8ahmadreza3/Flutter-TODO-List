import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

// Main application widget
// A widget that does not require mutable state (immutable UI elements).
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Main app configuration with light blue theme, custom app bar and FAB styling
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        // Color scheme setup (white and sky blue theme)
        colorScheme: ColorScheme.light(
          primary: Colors.blue[200]!, // Sky blue for primary elements
          onPrimary: Colors.black, // Black text on primary
          surface: Colors.white, // White background
          onSurface: Colors.black, // Black text on surface
        ),
        // Enables Material 3 design system with modern UI components and animations
        useMaterial3: true,
        // App bar styling
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[200],
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Floating action button styling : FAB Styles
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue[200],
          foregroundColor: Colors.black,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const TodoListScreen(),
    );
  }
}