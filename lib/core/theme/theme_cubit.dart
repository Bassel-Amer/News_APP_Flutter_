import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences pref;

  ThemeCubit({required this.pref, String? inittheme})
    : super(_getInitialTheme(inittheme));

  static ThemeMode _getInitialTheme(String? savedTheme) {
    switch (savedTheme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void toggleTheme() {
    ThemeMode nexttheme;

    if (state == ThemeMode.system) {
      final brightness = PlatformDispatcher.instance.platformBrightness;

      if (brightness == Brightness.dark) {
        nexttheme = ThemeMode.light;
      } else {
        nexttheme = ThemeMode.dark;
      }
    } else {
      state == ThemeMode.dark
          ? nexttheme = ThemeMode.light
          : nexttheme = ThemeMode.dark;
    }

    pref.setString('theme', nexttheme.name);
    emit(nexttheme);
  }
}
