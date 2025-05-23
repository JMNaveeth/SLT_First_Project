import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_update/utils/utils/colors.dart';
//import '../../Screens/HomePage/widgets/colors.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = false;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  ThemeProvider() {
    loadTheme();
  }

  void loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('isDarkMode') ?? true;
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
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
    ),
    cardTheme: CardTheme(
      color: Color(0xFFF7F4FA),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    ),

    useMaterial3: false,
    cardColor: Color(0xFFF7F4FA), // soft lavender / pinkish-white

    extensions: <ThemeExtension<dynamic>>[
      CustomColors(
        mainBackgroundColor: mainBackgroundColorLight,
        appbarColor: appbarColorLight,
        mainTextColor: mainTextColorLight,
        subTextColor: subTextColorLight,
        suqarBackgroundColor: suqarBackgroundColorLight,
        hinttColor: Colors.black,

      ),
    ],
  );

  ThemeData get darkTheme => ThemeData(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff212529),
      foregroundColor: Color(0xffFFFFFF),
      iconTheme: IconThemeData(color: Colors.white), // Ensure back arrow is white

    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xffFFFFFF)),
      bodyMedium: TextStyle(color: Color(0xffD9D9D9)),
    ),
    cardTheme: CardTheme(
      color: Color(0xff212529),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    ),

    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: TextStyle(color: Colors.white), // for items inside the menu
      menuStyle: MenuStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xff212529)), // Menu background color
      ),
    ),


    iconTheme: const IconThemeData(color: Colors.white),

    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.white),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(Colors.white),
      checkColor: MaterialStateProperty.all(Colors.black),
    ),


    useMaterial3: false,
    cardColor: Color(0xff212529), //tested here for default card color
    extensions: <ThemeExtension<dynamic>>[
      const CustomColors(
        mainBackgroundColor: Color(0xff212529),
        appbarColor: Color(0xff2B3136),
        mainTextColor: Colors.white,
        subTextColor: Colors.white,
        suqarBackgroundColor: Colors.grey,
        hinttColor: Colors.grey,
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
  final Color hinttColor;

  const CustomColors({
    required this.mainBackgroundColor,
    required this.appbarColor,
    required this.mainTextColor,
    required this.subTextColor,
    required this.suqarBackgroundColor,
    required this.hinttColor,
  });

  @override
  CustomColors copyWith({
    Color? mainBackgroundColor,
    Color? appbarColor,
    Color? mainTextColor,
    Color? subTextColor,
    Color? suqarBackgroundColor,
    Color? hinttColor,
  }) {
    return CustomColors(
      mainBackgroundColor: mainBackgroundColor ?? this.mainBackgroundColor,
      appbarColor: appbarColor ?? this.appbarColor,
      mainTextColor: mainTextColor ?? this.mainTextColor,
      subTextColor: subTextColor ?? this.subTextColor,
      suqarBackgroundColor: suqarBackgroundColor ?? this.suqarBackgroundColor,
      hinttColor: hinttColor ?? this.hinttColor,
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
      hinttColor: Color.lerp(hinttColor, other.hinttColor, t)!,
    );
  }
}



// v1
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../Screens/HomePage/widgets/colors.dart';
//
// class ThemeProvider extends ChangeNotifier {
//   bool isDarkMode = false;
//
//   void toggleTheme() {
//     isDarkMode = !isDarkMode;
//     notifyListeners();
//   }
//
//   ThemeProvider() {
//     loadTheme();
//   }
//
//   void loadTheme() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     isDarkMode = prefs.getBool('isDarkMode') ?? true;
//     notifyListeners();
//   }
//
//
//   ThemeData get currentTheme {
//     return isDarkMode ? darkTheme : lightTheme;
//   }
//
//   ThemeData get lightTheme => ThemeData(
//         scaffoldBackgroundColor: Colors.white,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: appbarColor,
//           foregroundColor: mainTextColor,
//         ),
//         textTheme: const TextTheme(
//           bodyLarge: TextStyle(color: Colors.black),
//           bodyMedium: TextStyle(color: Colors.black),
//         ),
//     cardTheme: CardTheme(
//       color: Color(0xFFF7F4FA),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
//     ),
//
//     useMaterial3: false,
//     cardColor: Color(0xFFF7F4FA), // soft lavender / pinkish-white
//
//         extensions: <ThemeExtension<dynamic>>[
//           CustomColors(
//             mainBackgroundColor: mainBackgroundColor,
//             appbarColor: appbarColor,
//             mainTextColor: mainTextColor,
//             subTextColor: subTextColor,
//             suqarBackgroundColor: suqarBackgroundColorLight,
//               hinttColor: Colors.grey,
//
//           ),
//         ],
//       );
//
//   ThemeData get darkTheme => ThemeData(
//         scaffoldBackgroundColor: Colors.black,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Color(0xff212529),
//           foregroundColor: Color(0xffFFFFFF),
//           iconTheme: IconThemeData(color: Colors.white), // Ensure back arrow is white
//
//         ),
//         textTheme: const TextTheme(
//           bodyLarge: TextStyle(color: Color(0xffFFFFFF)),
//           bodyMedium: TextStyle(color: Color(0xffD9D9D9)),
//         ),
//     cardTheme: CardTheme(
//       color: Color(0xff212529),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
//     ),
//
//     dropdownMenuTheme: DropdownMenuThemeData(
//       textStyle: TextStyle(color: Colors.white), // for items inside the menu
//       menuStyle: MenuStyle(
//         backgroundColor: MaterialStateProperty.all(Color(0xff212529)), // Menu background color
//       ),
//     ),
//
//
//     iconTheme: const IconThemeData(color: Colors.white),
//
//     inputDecorationTheme: const InputDecorationTheme(
//       labelStyle: TextStyle(color: Colors.white),
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.white),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.blue),
//       ),
//     ),
//     checkboxTheme: CheckboxThemeData(
//       fillColor: MaterialStateProperty.all(Colors.white),
//       checkColor: MaterialStateProperty.all(Colors.black),
//     ),
//
//
//     useMaterial3: false,
//     cardColor: Color(0xff212529), //tested here for default card color
//         extensions: <ThemeExtension<dynamic>>[
//           const CustomColors(
//             mainBackgroundColor: Colors.white,
//             appbarColor: Colors.white54,
//             mainTextColor: Colors.black,
//             subTextColor: Colors.black87,
//             suqarBackgroundColor: Colors.white,
//             hinttColor: Colors.grey,
//           ),
//         ],
//       );
// }
//
// class CustomColors extends ThemeExtension<CustomColors> {
//   final Color mainBackgroundColor;
//   final Color appbarColor;
//   final Color mainTextColor;
//   final Color subTextColor;
//   final Color suqarBackgroundColor;
//   final Color hinttColor;
//
//   const CustomColors({
//     required this.mainBackgroundColor,
//     required this.appbarColor,
//     required this.mainTextColor,
//     required this.subTextColor,
//     required this.suqarBackgroundColor,
//     required this.hinttColor,
//   });
//
//   @override
//   CustomColors copyWith({
//     Color? mainBackgroundColor,
//     Color? appbarColor,
//     Color? mainTextColor,
//     Color? subTextColor,
//     Color? suqarBackgroundColor,
//     Color? hinttColor,
//   }) {
//     return CustomColors(
//       mainBackgroundColor: mainBackgroundColor ?? this.mainBackgroundColor,
//       appbarColor: appbarColor ?? this.appbarColor,
//       mainTextColor: mainTextColor ?? this.mainTextColor,
//       subTextColor: subTextColor ?? this.subTextColor,
//       suqarBackgroundColor: suqarBackgroundColor ?? this.suqarBackgroundColor,
//       hinttColor: hinttColor ?? this.hinttColor,
//     );
//   }
//
//   @override
//   CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
//     if (other is! CustomColors) {
//       return this;
//     }
//     return CustomColors(
//       mainBackgroundColor:
//           Color.lerp(mainBackgroundColor, other.mainBackgroundColor, t)!,
//       appbarColor: Color.lerp(appbarColor, other.appbarColor, t)!,
//       mainTextColor: Color.lerp(mainTextColor, other.mainTextColor, t)!,
//       subTextColor: Color.lerp(subTextColor, other.subTextColor, t)!,
//       suqarBackgroundColor: Color.lerp(suqarBackgroundColor, other.suqarBackgroundColor, t)!,
//       hinttColor: Color.lerp(hinttColor, other.hinttColor, t)!,
//     );
//   }
// }