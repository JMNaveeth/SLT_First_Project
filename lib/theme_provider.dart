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

    useMaterial3: false,
    cardColor: Colors.blueGrey,

    extensions: <ThemeExtension<dynamic>>[
      const CustomColors(
        mainBackgroundColor: mainBackgroundColor,
        appbarColor: appbarColor,
        mainTextColor: mainTextColor,
        subTextColor: subTextColor,
        suqarBackgroundColor: suqarBackgroundColor,
        highlightColor: Colors.blue, // Highlight color for dark theme
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

    useMaterial3: false,
    cardColor: Colors.blue, //tested here for default card color

    extensions: <ThemeExtension<dynamic>>[
      const CustomColors(
        mainBackgroundColor: Colors.white,
        appbarColor: Colors.white54,
        mainTextColor: Colors.black,
        subTextColor: Colors.black87,
        suqarBackgroundColor: Colors.white,
        highlightColor: Colors.blue, // Highlight color for light theme
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
  final Color highlightColor; // Add highlightColor here

  const CustomColors({
    required this.mainBackgroundColor,
    required this.appbarColor,
    required this.mainTextColor,
    required this.subTextColor,
    required this.suqarBackgroundColor,
    required this.highlightColor, // Initialize highlightColor
  });

  @override
  CustomColors copyWith({
    Color? mainBackgroundColor,
    Color? appbarColor,
    Color? mainTextColor,
    Color? subTextColor,
    Color? suqarBackgroundColor,
    Color? highlightColor, // Add highlightColor to copyWith
  }) {
    return CustomColors(
      mainBackgroundColor: mainBackgroundColor ?? this.mainBackgroundColor,
      appbarColor: appbarColor ?? this.appbarColor,
      mainTextColor: mainTextColor ?? this.mainTextColor,
      subTextColor: subTextColor ?? this.subTextColor,
      suqarBackgroundColor: suqarBackgroundColor ?? this.suqarBackgroundColor,
      highlightColor:
          highlightColor ?? this.highlightColor, // Copy highlightColor
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
      suqarBackgroundColor:
          Color.lerp(suqarBackgroundColor, other.suqarBackgroundColor, t)!,
      highlightColor:
          Color.lerp(
            highlightColor,
            other.highlightColor,
            t,
          )!, // Lerp highlightColor
    );
  }
}
import 'package:flutter/material.dart';
import 'package:theme_update/theme_provider.dart';
import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/utils/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:theme_update/utils/utils/colors.dart' as customColors;
import 'ViewComfortAC/ViewComfortAC/SelectComfortACUnit.dart';
import 'ViewElevator/ViewElevator/viewElevator.dart';
import 'ViewRectifier/ViewRectifierDetails.dart';
import 'ViewSPD/ViewSPD/ViewSPDDetails.dart';
import 'ViewSolar/ViewSolar/view_data_screen.dart';
import 'ViewTransformer/ViewTransformer/view_transformer_data.dart';
import 'ViewUPS/ViewUPS/ViewUPShighend.dart';
import 'viewBatterySystem/viewBatterySystem/ViewBatteryDetails.dart';
import 'viewLVPanel/viewLVPanel/viewLVbreaker.dart';
import 'viewPrecisionAC/viewPrecisionAC/PrecisionAcViewCustom.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(create: (_) => ThemeProvider(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(color: customColors.mainTextColor),
        ),
        
        backgroundColor: customColors.appbarColor,
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),

      body: Container(
        color: customColors.mainBackgroundColor,
        child: Center(
          child: ElevatedButton(
            style: buttonStyle(),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RectifierMenu()),
              );
            },
            child: const Text('Search'),
          ),
        ),
      ),
    );
  }
}

class RectifierMenu extends StatelessWidget {
  const RectifierMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Menu',
          style: TextStyle(color: customColors.mainTextColor),
        ),
                iconTheme: IconThemeData(color: customColors.mainTextColor),

        backgroundColor: customColors.appbarColor,
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: buttonStyle(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewRectifierDetails(),
                  ),
                );
              },
              child: const Text('View Rectifier'),
            ),
            ElevatedButton(
              style: buttonStyle(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewUPShighend()),
                );
              },
              child: const Text('View UPS'),
            ),
            ElevatedButton(
              style: buttonStyle(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectComfortACUnit(),
                  ),
                );
              },
              child: const Text('View Comfort AC'),
            ),
            ElevatedButton(
              style: buttonStyle(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewBatteryDetails()),
                );
              },
              child: const Text('View Battery System'),
            ),
            ElevatedButton(
              style: buttonStyle(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewLVBreaker()),
                );
              },
              child: const Text('View LV Panel'),
            ),
            ElevatedButton(
              style: buttonStyle(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewElevatorDetails(),
                  ),
                );
              },
              child: const Text('View Elevator'),
            ),
            ElevatedButton(
              style: buttonStyle(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewSPDDetails()),
                );
              },
              child: const Text('View SPD'),
            ),
            ElevatedButton(
              style: buttonStyle(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewTransformerData(),
                  ),
                );
              },
              child: const Text('View Transformer'),
            ),
            ElevatedButton(
              style: buttonStyle(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrecisionACList()),
                );
              },
              child: const Text('View Precision AC'),
            ),
            ElevatedButton(
              style: buttonStyle(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewDataScreen()),
                );
              },
              child: const Text('View Solar'),
            ),
          ],
        ),
      ),
    );
  }
}

ButtonStyle buttonStyle() {
  return ElevatedButton.styleFrom();
}
