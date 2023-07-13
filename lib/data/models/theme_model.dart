import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeType { light, dark, custom, black }

class ThemeModel extends ChangeNotifier {
  ThemeModel({
    this.customBlackTheme,
    this.customLightTheme,
    this.customDarkTheme,
    this.customCustomTheme,
    String? key,
  }) {
    init();
  }

  final ThemeData? customLightTheme,
      customDarkTheme,
      customBlackTheme,
      customCustomTheme;

  int _accentColor = Colors.redAccent.value;
  bool _customTheme = false;
  int _darkAccentColor = Colors.greenAccent.value;
  bool _darkMode = false;
  int _primaryColor = Colors.blue.value;
  late SharedPreferences _prefs;
  bool _trueBlack = false;

  ThemeType get type {
    if (_darkMode) {
      if (_trueBlack) return ThemeType.black;
      return ThemeType.dark;
    }
    if (_customTheme) return ThemeType.custom;
    return ThemeType.light;
  }

  void changeDarkMode(bool value) {
    _darkMode = value;
    _prefs.setBool("dark_mode", _darkMode);
    notifyListeners();
  }

  void changeTrueBlack(bool value) {
    _trueBlack = value;
    _prefs.setBool("true_black", _trueBlack);
    notifyListeners();
  }

  void changeCustomTheme(bool value) {
    _customTheme = value;
    _prefs.setBool("custom_theme", _customTheme);
    notifyListeners();
  }

  void changePrimaryColor(Color value) {
    _primaryColor = value.value;
    _prefs.setInt("primary_color", _primaryColor);
    notifyListeners();
  }

  void changeAccentColor(Color value) {
    _accentColor = value.value;
    _prefs.setInt("accent_color", _accentColor);
    notifyListeners();
  }

  void changeDarkAccentColor(Color value) {
    _darkAccentColor = value.value;
    _prefs.setInt("dark_accent_color", _darkAccentColor);
    notifyListeners();
  }

  ThemeData get theme {
    switch (type) {
      case ThemeType.light:
        return customLightTheme ?? ThemeData.light().copyWith();
      case ThemeType.dark:
        return customDarkTheme ??
            ThemeData.dark().copyWith(
                colorScheme: ThemeData.dark()
                    .colorScheme
                    .copyWith(secondary: darkAccentColor));
      case ThemeType.black:
        return customBlackTheme ??
            ThemeData.dark().copyWith(
                colorScheme: ThemeData.dark().colorScheme.copyWith(
                    background: Colors.black,
                    primary: Colors.black,
                    secondary: darkAccentColor));
      case ThemeType.custom:
        return customCustomTheme != null
            ? customCustomTheme!.copyWith(
                colorScheme: customCustomTheme!.colorScheme
                    .copyWith(primary: primaryColor, secondary: accentColor))
            : ThemeData.light().copyWith(
                colorScheme: ThemeData.light()
                    .colorScheme
                    .copyWith(primary: primaryColor, secondary: accentColor));
      default:
        return customLightTheme ?? ThemeData.light().copyWith();
    }
  }

  void checkPlatformBrightness(BuildContext context) {
    if (!darkMode &&
        MediaQuery.of(context).platformBrightness == Brightness.dark) {
      changeDarkMode(true);
    }
  }

  ThemeData get darkTheme {
    if (_trueBlack) {
      return customBlackTheme ??
          ThemeData.dark().copyWith(
            colorScheme: ThemeData.dark()
                .colorScheme
                .copyWith(primary: Colors.black, secondary: darkAccentColor),
          );
    }
    return customDarkTheme ??
        ThemeData.dark().copyWith(
          colorScheme:
              ThemeData.dark().colorScheme.copyWith(secondary: darkAccentColor),
        );
  }

  Color? get backgroundColor {
    if (darkMode) {
      if (trueBlack) return Colors.black;
      return ThemeData.dark().scaffoldBackgroundColor;
    }
    if (customTheme) return primaryColor;
    return null;
  }

  Color get textColor {
    if (customTheme) return Colors.white;
    if (darkMode) return Colors.white;
    return Colors.black;
  }

  Color get textColorInvert {
    if (customTheme) return Colors.black;
    if (darkMode) return Colors.black;
    return Colors.white;
  }

  Future init() async {
    _prefs = await SharedPreferences.getInstance();

    try {
      _darkMode = _prefs.getBool("dark_mode") ?? _darkMode;
      _trueBlack = _prefs.getBool("true_black") ?? _trueBlack;
      _customTheme = _prefs.getBool("custom_theme") ?? _customTheme;
      _primaryColor = _prefs.getInt("primary_color") ?? _primaryColor;
      _accentColor = _prefs.getInt("accent_color") ?? _accentColor;
      _darkAccentColor = _prefs.getInt("dark_accent_color") ?? _darkAccentColor;
    } catch (e, s) {
      print(s);
    }
    notifyListeners();
  }

  bool get darkMode => _darkMode;

  bool get trueBlack => _trueBlack;

  bool get customTheme => _customTheme;

  Color get primaryColor {
    return type == ThemeType.dark
        ? ThemeData.dark().primaryColor
        : ThemeData.light().primaryColor;
  }

  Color get accentColor {
    if (type == ThemeType.dark || type == ThemeType.black) {
      return ThemeData.dark().colorScheme.secondary;
    }

    if (_customTheme) {
      return Color(_accentColor);
    }

    return Colors.redAccent;
  }

  Color get darkAccentColor {
    return Color(_darkAccentColor);
  }

  void reset() {
    _prefs.clear();
    _darkMode = false;
    _trueBlack = false;
    _customTheme = false;
    _primaryColor = Colors.blue.value;
    _accentColor = Colors.redAccent.value;
    _darkAccentColor = Colors.greenAccent.value;
  }
}
