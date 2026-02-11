import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppState extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  Locale _currentLocale = const Locale('en');
  Locale get currentLocale => _currentLocale;

  void changeLanguage(String code) {
    _currentLocale = Locale(code);
    notifyListeners();
  }

  ThemeData get currentTheme => _isDarkMode ? _darkTheme : _lightTheme;

  static final _textStyle = GoogleFonts.interTextTheme();

  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF1F5F9),
    primaryColor: const Color(0xFF2E86DE),
    cardTheme: CardThemeData(
      color: Colors.white, 
      elevation: 2, 
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textTheme: _textStyle.apply(bodyColor: const Color(0xFF1E293B)),
    iconTheme: const IconThemeData(color: Color(0xFF64748B)),
    useMaterial3: true,
  );

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    primaryColor: const Color(0xFF2E86DE),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E293B), 
      elevation: 0, 
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textTheme: _textStyle.apply(bodyColor: Colors.white),
    iconTheme: const IconThemeData(color: Colors.white70),
    useMaterial3: true,
  );
}