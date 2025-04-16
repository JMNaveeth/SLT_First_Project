import 'package:flutter/material.dart';
import 'utils/utils/colors.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = false;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  ThemeData get currentTheme {
    return isDarkMode ? darkTheme : lightTheme;
  }

  ThemeData get lightTheme => ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: appbarColor,
          foregroundColor: mainTextColor,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: mainTextColor),
          bodyMedium: TextStyle(color: mainTextColor),
        ),
        extensions: <ThemeExtension<dynamic>>[
          const CustomColors(
            mainBackgroundColor: mainBackgroundColor,
            appbarColor: appbarColor,
            mainTextColor: mainTextColor,
            subTextColor: subTextColor,
            suqarBackgroundColor: suqarBackgroundColor,
            
          ),
        ],
      );

  ThemeData get darkTheme => ThemeData(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff212529),
          foregroundColor: Color(0xffFFFFFF),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xffFFFFFF)),
          bodyMedium: TextStyle(color: Color(0xffD9D9D9)),
        ),
        extensions: <ThemeExtension<dynamic>>[
          const CustomColors(
            mainBackgroundColor: Colors.white,
            appbarColor: Colors.white54,
            mainTextColor: Colors.black,
            subTextColor: Colors.black87,
            suqarBackgroundColor: Colors.white,
          ),
        ],
      );
}

class CustomColors extends ThemeExtension<CustomColors> {
  final Color mainBackgroundColor;
  final Color appbarColor;
  final Color mainTextColor;
  final Color subTextColor;
  final Color suqarBackgroundColor;

  const CustomColors({
    required this.mainBackgroundColor,
    required this.appbarColor,
    required this.mainTextColor,
    required this.subTextColor,
    required this.suqarBackgroundColor,
  });

  @override
  CustomColors copyWith({
    Color? mainBackgroundColor,
    Color? appbarColor,
    Color? mainTextColor,
    Color? subTextColor,
    Color? suqarBackgroundColor,
  }) {
    return CustomColors(
      mainBackgroundColor: mainBackgroundColor ?? this.mainBackgroundColor,
      appbarColor: appbarColor ?? this.appbarColor,
      mainTextColor: mainTextColor ?? this.mainTextColor,
      subTextColor: subTextColor ?? this.subTextColor,
      suqarBackgroundColor: suqarBackgroundColor ?? this.suqarBackgroundColor,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      mainBackgroundColor:
          Color.lerp(mainBackgroundColor, other.mainBackgroundColor, t)!,
      appbarColor: Color.lerp(appbarColor, other.appbarColor, t)!,
      mainTextColor: Color.lerp(mainTextColor, other.mainTextColor, t)!,
      subTextColor: Color.lerp(subTextColor, other.subTextColor, t)!,
      suqarBackgroundColor: Color.lerp(suqarBackgroundColor, other.suqarBackgroundColor, t)!,
    );
  }
}